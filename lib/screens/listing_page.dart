import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_listing_app/model/user_list_model.dart';
import 'package:flutter_listing_app/provider/user_list_provider.dart';
import 'package:flutter_listing_app/screens/listing_details_page.dart';

import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  @override
  void initState() {
    Future.microtask(() async {
      final userListProvider =
          Provider.of<UserListProvider>(context, listen: false);
      await userListProvider.fetchUsers();
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
    super.dispose();
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserListProvider userListProvider =
        Provider.of<UserListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Listing Page"),
        backgroundColor: Colors.blue,
      ),
      body: userListProvider.users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              itemCount: userListProvider.users.length,
              itemBuilder: (context, index) {
                final UserListModel user = userListProvider.users[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ListingDetailsPage(userId: user.id ?? 0),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(),
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showImageDialog(user.avatar ?? "");
                                  },
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: user.avatar ?? "",
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                const Gap(30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.firstName ?? ""),
                                    const Gap(10),
                                    Text(user.lastName ?? ""),
                                    const Gap(10),
                                    Text(user.email ?? ""),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Gap(5)
                    ],
                  ),
                );
              },
            ),
    );
  }
}
