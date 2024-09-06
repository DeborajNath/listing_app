import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:flutter_listing_app/provider/user_list_provider.dart';

class ListingDetailsPage extends StatefulWidget {
  final int userId;

  const ListingDetailsPage({super.key, required this.userId});

  @override
  State<ListingDetailsPage> createState() => _ListingDetailsPageState();
}

class _ListingDetailsPageState extends State<ListingDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userListProvider =
          Provider.of<UserListProvider>(context, listen: false);
      userListProvider.fetchUserById(widget.userId);
    });
  }

  @override
  void dispose() {
    userListProvider.resetSelectedUser();
    super.dispose();
  }

  Future<void> _saveData() async {
    final userListProvider =
        Provider.of<UserListProvider>(context, listen: false);
    final user = userListProvider.selectedUser;

    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'avatar': user.avatar,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  Future<void> _deleteData() async {
    final userListProvider =
        Provider.of<UserListProvider>(context, listen: false);
    final user = userListProvider.selectedUser;

    if (user == null) return;

    try {
      final userCollection = FirebaseFirestore.instance.collection('users');
      final snapshot =
          await userCollection.where('id', isEqualTo: user.id).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data found to delete.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting data: $e')),
      );
    }
  }

  Future<void> _showEditDialog() async {
    final userListProvider =
        Provider.of<UserListProvider>(context, listen: false);
    final user = userListProvider.selectedUser;

    if (user == null) return;

    final TextEditingController firstNameController =
        TextEditingController(text: user.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: user.lastName);
    final TextEditingController emailController =
        TextEditingController(text: user.email);

    return showDialog<void>(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                try {
                  final snapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .where('id', isEqualTo: user.id)
                      .limit(1)
                      .get();

                  if (snapshot.docs.isNotEmpty) {
                    await snapshot.docs.first.reference.update({
                      'firstName': firstNameController.text,
                      'lastName': lastNameController.text,
                      'email': emailController.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Data updated successfully in firebase!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Data not found in Firebase to edit.')),
                    );
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating data: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserListProvider userListProvider =
        Provider.of<UserListProvider>(context);
    final user = userListProvider.selectedUser;
    // log('User avatar URL: ${user?.avatar}');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: userListProvider.getUserLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: user?.avatar ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const Gap(20),
                Text(
                  "First Name :- ${user?.firstName}",
                  style: const TextStyle(fontSize: 20),
                ),
                const Gap(10),
                Text(
                  "Last Name :- ${user?.lastName}",
                  style: const TextStyle(fontSize: 20),
                ),
                const Gap(10),
                Text(
                  "Email Id :- ${user?.email}",
                  style: const TextStyle(fontSize: 20),
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(150, 50),
                      ),
                      onPressed: _saveData,
                      child: const Text(
                        "Add Data",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(150, 50),
                      ),
                      onPressed: _showEditDialog,
                      child: const Text(
                        "Edit Data",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: const Size(150, 50),
                  ),
                  onPressed: _deleteData,
                  child: const Text(
                    "Delete Data",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }
}
