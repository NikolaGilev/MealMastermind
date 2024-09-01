import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meal_mastermind/models/user.dart';
import 'package:meal_mastermind/utils/constants.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl + '/login'),
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      _currentUser = User.fromJson(json.decode(response.body));
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      _currentUser = User.fromJson(json.decode(response.body));
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
