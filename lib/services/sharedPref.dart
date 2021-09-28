import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ysi/models/company.dart';
import 'dart:convert';

import 'package:ysi/models/user.dart';

class SharedPref {
  void saveUserData(userData) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('token', userData['token']);
    localStorage.setString('user', json.encode(userData['user']));
  }

  void removeUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.clear();
    debugPrint('remove user data!');
  }

  Future<String> getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('token') ?? '';
    return token;
  }

  Future<User?> getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString("user")!);
    if (user == null) {
      return null;
    }
    return User.fromJson(user);
  }

  void saveCompanies(companies) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('companies', json.encode(companies));
  }

  Future getAllCompanies() async {
    List<Company?>? companies;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var companiesData = await json.decode(localStorage.getString('companies')!);
    if (companiesData == null) {
      return null;
    } else {
      companies = (companiesData as List)
          .map((e) =>
              e == null ? null : Company.fromJson(e as Map<String, dynamic>))
          .toList();
      debugPrint(companies.toString());
      inspect(companies);
      return companies;
    }
  }
}
