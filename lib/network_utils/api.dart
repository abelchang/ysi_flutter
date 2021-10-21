import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:ysi/services/sharedPref.dart';

class Network {
  // final String _url = 'https://ysi.beabel.com/api/v1';
  final String _url = 'http://ysi_backend.test/api/v1';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;
  Dio _dio = Dio(
    BaseOptions(connectTimeout: 10000, receiveTimeout: 10000),
  );

  _getToken() async {
    token = await SharedPref().getToken();
  }

  Future<dynamic> authData(data, apiUrl, BuildContext context) async {
    var fullUrl = _url + apiUrl;
    var result;
    // debugPrint('authData:' + fullUrl);
    _setDioHeaders();
    try {
      var response = await _dio.post(fullUrl, data: jsonEncode(data));
      return json.decode(response.toString());
    } on DioError catch (e) {
      result = {
        'success': false,
        'message': e.message,
      };
      debugPrint(e.message);
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }
      return result;
    }
  }

  Future<dynamic> getData(apiUrl) async {
    // debugPrint('get date from: $apiUrl');
    var fullUrl = _url + apiUrl;
    var result;
    await _getToken();
    _setDioHeaders();
    try {
      final response = await _dio.get(fullUrl);

      return json.decode(response.toString());
    } on DioError catch (e) {
      result = {
        'success': false,
        'message': e.message,
      };
      debugPrint(e.message);
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }

      if (e.response?.statusCode == 401) {
        SharedPref().removeUserData();
      }
      return result;
    }
  }

  // getData(apiUrl) async {
  //   print('get date from: $apiUrl');
  //   var fullUrl = _url + apiUrl;
  //   await _getToken();
  //   return await http.get(fullUrl, headers: _setHeaders());
  // }

  postData(data, apiUrl) async {
    var result;
    var fullUrl = _url + apiUrl;
    await _getToken();
    _setDioHeaders();
    try {
      // debugPrint(jsonEncode(data));
      final response = await _dio.post(fullUrl, data: jsonEncode(data));
      debugPrint('response: $response');
      return json.decode(response.toString());
    } on DioError catch (e) {
      debugPrint(e.message);
      result = {
        'success': false,
        'message': e.message,
      };
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }
      if (e.response?.statusCode == 401) {
        SharedPref().removeUserData();
      }
      return result;
    }
  }

  postUnData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    var result;
    _setDioHeaders();
    try {
      final response = await _dio.post(fullUrl, data: jsonEncode(data));
      return json.decode(response.toString());
    } on DioError catch (e) {
      debugPrint(e.message);
      result = {
        'success': false,
        'message': e.message,
      };
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }
      if (e.response?.statusCode == 401) {
        SharedPref().removeUserData();
      }
      return result;
    }
  }

  Future<dynamic> postAPICall(data, apiUrl, BuildContext context) async {
    var fullUrl = _url + apiUrl;
    var result;
    await _getToken();
    _setDioHeaders();
    try {
      final response = await _dio.post(fullUrl, data: jsonEncode(data));
      return json.decode(response.toString());
    } on DioError catch (e) {
      debugPrint(e.message);
      result = {
        'success': false,
        'message': e.message,
      };
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }
      if (e.response?.statusCode == 401) {
        SharedPref().removeUserData();
      }
      return result;
    }
  }

  // _setHeaders() => {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token'
  //     };

  _setDioHeaders() {
    _dio.options.headers["Authorization"] = "Bearer $token";
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
  }
}
