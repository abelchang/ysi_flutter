import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:ysi/services/sharedPref.dart';

class Network {
  final String _url = 'https://ysi.beabel.com/api/v1';
  // final String _url = 'http://ysi_backend.test/api/v1';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;
  Dio _dio = Dio(
    BaseOptions(connectTimeout: 5000, receiveTimeout: 5000),
  );

  _getToken() async {
    token = await SharedPref().getToken();
  }

  Future<dynamic> authData(data, apiUrl, BuildContext context) async {
    var fullUrl = _url + apiUrl;
    // debugPrint('authData:' + fullUrl);
    _setDioHeaders();
    try {
      var response = await _dio.post(fullUrl, data: jsonEncode(data));
      return json.decode(response.toString());
    } on DioError catch (e) {
      debugPrint(e.message);
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }
    }
  }

  Future<dynamic> getData(apiUrl) async {
    // debugPrint('get date from: $apiUrl');
    var fullUrl = _url + apiUrl;
    await _getToken();
    _setDioHeaders();
    try {
      final response = await _dio.get(fullUrl);

      return json.decode(response.toString());
    } on DioError catch (e) {
      debugPrint(e.message);
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }

      if (e.response!.statusCode == 401) {
        SharedPref().removeUserData();
        return json.decode(e.response!.data);
      }
    }
  }

  // getData(apiUrl) async {
  //   print('get date from: $apiUrl');
  //   var fullUrl = _url + apiUrl;
  //   await _getToken();
  //   return await http.get(fullUrl, headers: _setHeaders());
  // }

  postData(data, apiUrl) async {
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
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }
      if (e.response!.statusCode == 401) {
        SharedPref().removeUserData();
        return json.decode(e.response.toString());
      }
    }
  }

  postUnData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    _setDioHeaders();
    try {
      final response = await _dio.post(fullUrl, data: jsonEncode(data));
      return json.decode(response.toString());
    } on DioError catch (e) {
      debugPrint(e.message);
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }
      if (e.response!.statusCode == 401) {
        SharedPref().removeUserData();
        return json.decode(e.response.toString());
      }
    }
  }

  Future<dynamic> postAPICall(data, apiUrl, BuildContext context) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    _setDioHeaders();
    try {
      final response = await _dio.post(fullUrl, data: jsonEncode(data));
      return json.decode(response.toString());
    } on DioError catch (e) {
      debugPrint(e.message);
      if (e.response != null) {
        debugPrint('response:' + e.response.toString());
      }
      if (e.response!.statusCode == 401) {
        SharedPref().removeUserData();
        return json.decode(e.response.toString());
      }
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
