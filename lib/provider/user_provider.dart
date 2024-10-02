import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_listing_app/model/user_model.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;
  bool _userLoading = false;
  bool get userLoading => _userLoading;
  List<User> _filteredUsers = [];
  List<User> get filteredUsers => _filteredUsers;

  set setuseroading(bool data) {
    _userLoading = data;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    setuseroading = true;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      _users = snapshot.docs
          .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
      _filteredUsers = _users;
      notifyListeners();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    } finally {
      setuseroading = false;
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        final phoneNumber = user.phoneNumber.toLowerCase();
        final location = user.city.toLowerCase();
        return fullName.contains(query.toLowerCase()) ||
            phoneNumber.contains(query.toLowerCase()) ||
            location.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
