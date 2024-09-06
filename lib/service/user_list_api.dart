// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter_listing_app/constants/api_urls.dart';
// import 'package:flutter_listing_app/model/user_list_model.dart';


// Future<void> fetchUsers() async {
//   final dio = Dio();

//   try {
//     final response = await dio.get(url);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = response.data;

//       final List<dynamic> usersJson = data['data'];

//       final List<UserListModel> users =
//           usersJson.map((json) => UserListModel.fromJson(json)).toList();

//       for (var user in users) {
//         log('User ID: ${user.id}');
//         log('Email: ${user.email}');
//         log('First Name: ${user.firstName}');
//         log('Last Name: ${user.lastName}');
//         log('Avatar: ${user.avatar}');
//         log('---');
//       }
//     } else {
//       log('Failed to load data. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     log('An error occurred: $e');
//   }
// }
