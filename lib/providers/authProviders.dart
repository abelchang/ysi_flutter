import 'dart:async';
import 'dart:convert';
// ignore: unused_import
import 'dart:developer' as developer;
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ysi/network_utils/api.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut,
  CreateBnbing,
  CreateBnbed,
  CreateBnbIn
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;
  Status _createBnbStatus = Status.CreateBnbIn;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;
  Status get createBnbStatus => _createBnbStatus;

  // Future<Map<String, dynamic>> checkIfLogin() async {
  //   print('in checkIfLogin');
  //   var result;
  //   var token;
  //   var isLogin;

  //   token = await UserPreferences().getToken();
  //   print('check token');
  //   if (token == null) {
  //     print('token null');
  //     result = {
  //       'success': false,
  //       'hasBnb': false,
  //       'hasRooms': false,
  //     };
  //     return result;
  //   } else {
  //     print('token ok!');
  //   }

  //   isLogin = await UserPreferences().getLoginStatus();
  //   print('check isLogin');
  //   if (isLogin) {
  //     print('isLogin ok!');
  //   } else {
  //     print('isLogin false');
  //     result = {
  //       'success': false,
  //       'hasBnb': false,
  //       'hasRooms': false,
  //     };
  //     return result;
  //   }

  //   var currentBnb = await UserPreferences().getCuttentBnb();
  //   if (currentBnb == null && token != null) {
  //     print('login but not have Bnb ');
  //     var response = await Network().getData('/getcity');
  //     if (response.statusCode == 200) {
  //       print('in check ok');
  //       var responseData = json.decode(response.body);
  //       List<City> cities = (responseData['cities'] as List)
  //           ?.map((e) =>
  //               e == null ? null : City.fromJson(e as Map<String, dynamic>))
  //           ?.toList();
  //       List<Country> countries = (responseData['countries'] as List)
  //           ?.map((e) =>
  //               e == null ? null : Country.fromJson(e as Map<String, dynamic>))
  //           ?.toList();
  //       result = {
  //         'success': true,
  //         'hasBnb': false,
  //         'hasRooms': false,
  //         'cities': cities,
  //         'countries': countries,
  //       };
  //       return result;
  //     }
  //   } else if (currentBnb == null) {
  //     print('currentBnb null');
  //     result = {
  //       'success': false,
  //       'hasBnb': false,
  //       'hasRooms': false,
  //     };
  //     return result;
  //   } else {
  //     print('check currentBnb ok');
  //   }

  //   var currentRooms = await UserPreferences().getCurrentRooms();
  //   if (currentRooms == null) {
  //     print('currentRooms null');
  //     result = {
  //       'success': true,
  //       'hasBnb': true,
  //       'hasRooms': false,
  //     };
  //     return result;
  //   } else {
  //     print('check room ok!');
  //   }

  //   var response = await Network().getData('/getLoginData/${currentBnb.id}');

  //   print('checkiflogin response');
  //   developer.inspect(response.body);
  //   developer.log(
  //     'log me',
  //     name: 'my.app.main.snapshot.error',
  //     error: response.body,
  //   );
  //   if (response.statusCode == 200) {
  //     print('in check ok');
  //     var responseData = json.decode(response.body);
  //     User user = User.fromJson(responseData['user']);
  //     Bnb bnb = Bnb.fromJson(responseData['bnb']);
  //     UserPreferences().saveCurrentBnb(bnb);
  //     List<Room> rooms = (responseData['rooms'] as List)
  //         ?.map((e) =>
  //             e == null ? null : Room.fromJson(e as Map<String, dynamic>))
  //         ?.toList();
  //     UserPreferences().saveCurrentRooms(rooms);
  //     List<OrderPlace> orderPlaces = (responseData['orderPlaces'] as List)
  //         ?.map((e) =>
  //             e == null ? null : OrderPlace.fromJson(e as Map<String, dynamic>))
  //         ?.toList();
  //     List<OrderStatus> orderStatus = (responseData['orderStatus'] as List)
  //         ?.map((e) => e == null
  //             ? null
  //             : OrderStatus.fromJson(e as Map<String, dynamic>))
  //         ?.toList();
  //     List<City> cities = (responseData['cities'] as List)
  //         ?.map((e) =>
  //             e == null ? null : City.fromJson(e as Map<String, dynamic>))
  //         ?.toList();
  //     List<Country> countries = (responseData['countries'] as List)
  //         ?.map((e) =>
  //             e == null ? null : Country.fromJson(e as Map<String, dynamic>))
  //         ?.toList();
  //     List<User> helpers = (responseData['helpers'] as List)
  //         ?.map((e) =>
  //             e == null ? null : User.fromJson(e as Map<String, dynamic>))
  //         ?.toList();
  //     result = {
  //       'success': true,
  //       'hasBnb': true,
  //       'hasRooms': true,
  //       'user': user,
  //       'bnb': bnb,
  //       'rooms': rooms,
  //       'orderPlaces': orderPlaces,
  //       'orderStatus': orderStatus,
  //       'cities': cities,
  //       'countries': countries,
  //       'helpers': helpers,
  //     };
  //     // return result;
  //   } else {
  //     print('in check false');
  //     result = {
  //       'success': false,
  //       'hasBnb': false,
  //       'hasRooms': false,
  //     };
  //     // return result;
  //   }

  //   // print('result');
  //   // developer.inspect(result);
  //   return result;
  // }

  Future<Map<String, dynamic>> login(
      String phone, String password, BuildContext context) async {
    var result;

    final Map<String, dynamic> loginData = {
      'phone': phone,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    debugPrint("AuthProvider_login Authenticating");
    notifyListeners();
    var response;
    try {
      response = await Network().authData(loginData, '/login', context);
    } catch (e) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      return response;
    }

    // developer.log(
    //   'log me',
    //   name: 'my.app.AuthProvider_login',
    //   error: response.body,
    // );

    if (response == null) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      return response;
    }

    return result;
  }

  // Future<Map<String, dynamic>> register(
  //     String email,
  //     String password,
  //     String phone,
  //     String name,
  //     String permission,
  //     int icodeId,
  //     BuildContext context) async {
  //   await Firebase.initializeApp();
  //   String token = await FirebaseMessaging.instance.getToken();
  //   final Map<String, dynamic> registrationData = {
  //     'email': email,
  //     'password': password,
  //     'phone': phone,
  //     'name': name,
  //     'ftoken': token,
  //     'permission': permission,
  //     'icodeId': icodeId,
  //   };

  //   _registeredInStatus = Status.Registering;
  //   print("AuthProvider_register Registering");
  //   notifyListeners();

  //   var result;
  //   var response =
  //       await Network().authData(registrationData, '/register', context);
  //   final responseData = json.decode(response.body);

  //   if (response.statusCode == 200) {
  //     // developer.log(
  //     //   'in register service',
  //     //   name: 'my.app.main.snapshot.error',
  //     //   error: jsonEncode(responseData),
  //     // );
  //     _registeredInStatus = Status.Registered;
  //     notifyListeners();
  //     User user = User.fromJson(responseData['user']);
  //     String token = responseData['token'];
  //     UserPreferences().saveUser(user, token);

  //     result = {
  //       'success': true,
  //       'message': 'Successfully registered',
  //       'data': user,
  //     };
  //   } else {
  //     _registeredInStatus = Status.NotRegistered;
  //     notifyListeners();
  //     developer.log(
  //       jsonEncode(responseData),
  //       name: 'my.app.AuthProvider_register',
  //     );
  //     result = {
  //       'success': false,
  //       'message': json.decode(response.body)['message'],
  //     };
  //   }

  //   return result;

  //   // return Network()
  //   //     .authData(registrationData, '/register')
  //   //     .then(onValue)
  //   //     .catchError(onError);
  // }

  // Future<Map<String, dynamic>> logout() async {
  //   var response = await Network().getData('/logout');
  //   var result;
  //   print('logout');
  //   if (response.statusCode == 200) {
  //     notifyListeners();
  //     result = {'success': true, 'message': 'Successfully logout'};
  //   } else {
  //     result = {'success': false, 'message': 'logout failure'};
  //   }
  //   UserPreferences().removeUser();
  //   _loggedInStatus = Status.LoggedOut;
  //   return result;
  // }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final Map<String, dynamic> data = {
      'email': email,
    };

    debugPrint("send reset password email request");

    var response = await Network().postUnData(data, '/forgot-password');
    developer.log(
      'log me',
      name: 'my.app.AuthProvider_login',
      error: response,
    );
    return jsonDecode(response);
  }

  static onError(error) {
    debugPrint("the error is $error.detail");
    return {'success': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
