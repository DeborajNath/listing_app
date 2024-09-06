import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_listing_app/constants/api_urls.dart';
import 'package:flutter_listing_app/model/user_list_model.dart';

UserListProvider userListProvider = UserListProvider();

class UserListProvider extends ChangeNotifier {
  List<UserListModel> _users = [];
  UserListModel? _selectedUser;
  bool _getUserLoading = false;

  List<UserListModel> get users => _users;
  UserListModel? get selectedUser => _selectedUser;
  bool get getUserLoading => _getUserLoading;

  set setClientLoading(bool isLoading) {
    _getUserLoading = isLoading;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await Dio().get(baseUrl + userList);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> usersJson = data['data'];
        _users = usersJson.map((json) => UserListModel.fromJson(json)).toList();
        log("users $response");
        notifyListeners();
      } else {
        log('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('An error occurred: $e');
    }
  }

  Future<void> fetchUserById(int id) async {
    _getUserLoading = true;
    _selectedUser = null;
    notifyListeners();
    try {
      final response = await Dio().get('$baseUrl/$id');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        _selectedUser = UserListModel.fromJson(data['data']);
      } else {
        log('Failed to load user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('An error occurred: $e');
    } finally {
      _getUserLoading = false;
      notifyListeners();
    }
  }

  UserListModel? getUserById(int id) {
    return _selectedUser;
  }

  void resetSelectedUser() {
    _selectedUser = null;
    _getUserLoading = false;
    notifyListeners();
  }
}
