import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_listing_app/constants/colors.dart';
import 'package:flutter_listing_app/constants/dimensions.dart';
import 'package:flutter_listing_app/constants/routes.dart';
import 'package:flutter_listing_app/model/user_model.dart';
import 'package:flutter_listing_app/provider/user_provider.dart';
import 'package:flutter_listing_app/screens/linkedin.dart';
import 'package:flutter_listing_app/screens/website.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  //
  //
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<UserProvider>(context, listen: false).fetchUsers());
  }

  void showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Fetch Details",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        RoutingService.goBack(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                      ),
                    )
                  ],
                ),
                Text(
                  "Here are the details of following employee.",
                  style: TextStyle(color: grey),
                ),
                Text(
                  "Name : ${user.firstName} ${user.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap(5),
                Text(
                  "Location : ${user.city}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap(5),
                Text(
                  "Contact Number : ${user.phoneNumber}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap(5),
                Text(
                  "Profile Image : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap(5),
                Container(
                  height: 180 * Dimensions.heightF(context),
                  width: 180 * Dimensions.widthP(context),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/image/profilepic.webp"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact@girmantech.com',
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No email app available to handle the request')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showAddUserForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add New User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Gap(20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "First name can't be empty";
                      }
                      return null;
                    },
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Gap(10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Last name can't be empty";
                      }
                      return null;
                    },
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Gap(10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "City can't be empty";
                      }
                      return null;
                    },
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Gap(10),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty && value.length < 10) {
                        return "Phone Number should be 10 digits";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          RoutingService.goBack(context);
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            CollectionReference collRef =
                                FirebaseFirestore.instance.collection('users');
                            try {
                              await collRef.add({
                                'First Name': firstNameController.text,
                                'Last Name': lastNameController.text,
                                'City': cityController.text,
                                'Phone Number': phoneController.text,
                              });
                              firstNameController.clear();
                              lastNameController.clear();
                              cityController.clear();
                              phoneController.clear();
                              await RoutingService.goBack(context);
                              await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .fetchUsers();
                              await ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Succesfully Added User')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error adding user: $e')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please fill out the form correctly.')),
                            );
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                  Gap(20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.filteredUsers.isNotEmpty
        ? userProvider.filteredUsers
        : userProvider.users;
    return Scaffold(
      appBar: AppBar(
        shadowColor: black,
        elevation: 4,
        backgroundColor: white,
        title: Row(
          children: [
            Image.asset("assets/logo/logo.png"),
            const Gap(10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Girman",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "TECHNOLOGIES",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.menu,
                color: black,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Website':
                    RoutingService.goto(context, Website());
                    break;
                  case 'LinkedIn':
                    RoutingService.goto(context, Linkedin());
                    break;
                  case 'Contacts':
                    launchEmail();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'Website',
                  child: Text('Website'),
                ),
                const PopupMenuItem<String>(
                  value: 'LinkedIn',
                  child: Text('LinkedIn'),
                ),
                const PopupMenuItem<String>(
                  value: 'Contacts',
                  child: Text('Contacts'),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 65 * Dimensions.heightF(context),
        color: black,
        child: Center(
          child: GestureDetector(
            onTap: () => _showAddUserForm(context),
            child: Text(
              "Add More User",
              style: TextStyle(
                  color: white, fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        if (userProvider.userLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                white,
                lightBlue,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/logo/logo 2.png"),
                      Gap(20),
                      Text(
                        "Girman",
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                  Gap(30),
                  TextFormField(
                    onChanged: (value) {
                      userProvider.searchUsers(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: black, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: black, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: blue, width: 2.0),
                      ),
                      hintText: "Search",
                    ),
                  ),
                  Gap(20),
                  Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                    if (userProvider.filteredUsers.isEmpty) {
                      return Center(
                        child: Image.asset("assets/image/no_result.png"),
                      );
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        User user = users[index];
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: black),
                                borderRadius: BorderRadius.circular(20),
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      color: grey,
                                      spreadRadius: 1)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: white,
                                        ),
                                        CircleAvatar(
                                          radius: 30,
                                          foregroundImage: AssetImage(
                                              "assets/image/profilepic.webp"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${user.firstName} ${user.lastName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        Text(user.city),
                                      ],
                                    ),
                                    Gap(20),
                                    Divider(
                                      color: black,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.call),
                                                Gap(5),
                                                Text(user.phoneNumber),
                                              ],
                                            ),
                                            Gap(5),
                                            Text("Available on Phone")
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => showUserDetails(user),
                                          child: Container(
                                            height: 40 *
                                                Dimensions.heightF(context),
                                            width: 130 *
                                                Dimensions.widthP(context),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: black),
                                            child: Center(
                                              child: Text(
                                                "Fetch Details",
                                                style: TextStyle(
                                                    color: white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Gap(20),
                          ],
                        );
                      },
                    );
                  })
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
