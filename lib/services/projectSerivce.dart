import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ysi/models/answer.dart';
import 'package:ysi/models/company.dart';
import 'package:ysi/models/linkcode.dart';
import 'package:ysi/models/project.dart';
import 'package:ysi/models/qa.dart';
import 'package:ysi/network_utils/api.dart';
import 'package:ysi/services/sharedPref.dart';

class ProjectService {
  Future<Map<String, dynamic>> checkIfLogin() async {
    print('in checkIfLogin');
    var result;
    var response = await Network().getData("/checkIfLogin");
    if (response == null) {
      result = {
        'success': false,
      };
    } else if (response['success'] == true) {
      result = {
        'success': true,
      };
    } else {
      result = {
        'success': false,
      };
    }
    return result;
  }

  Future getAllComapnies() async {
    var result;
    List<Company?>? companies;
    var response = await Network().getData("/getallcompanies");
    if (response['success'] == true) {
      if (response['companies'] != null) {
        SharedPref().saveCompanies(response['companies']);
        companies = (response['companies'] as List)
            .map((e) =>
                e == null ? null : Company.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      result = {
        'success': true,
        'companies': companies,
      };
    } else {
      result = {'success': false, 'message': response['message']};
    }

    return result;
  }

  Future<Map<String, dynamic>> createProject(Project project) async {
    var result;

    final Map<String, dynamic> projectData = {
      'project': project,
    };
    debugPrint('request:' + json.encode(projectData));

    var response = await Network().postData(projectData, '/project/save');
    if (response['success'] != null) {
      if (response['success'] == true) {
        result = {
          'success': true,
          'project': Project.fromJson(response['project']),
        };
      } else {
        result = {
          'success': false,
          'message': response,
        };
      }
    } else {
      return response;
    }

    return result;
  }

  Future<Map<String, dynamic>> getAllProjects() async {
    var result;
    List<Project?>? projects;
    var response = await Network().getData("/project/getall");
    if (response['success'] == true) {
      if (response['projects'] != null) {
        projects = (response['projects'] as List)
            .map((e) =>
                e == null ? null : Project.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      result = {
        'success': true,
        'projects': projects,
      };
    } else {
      result = {'success': false, 'message': response['message']};
    }

    return result;
  }

  Future<Map<String, dynamic>> getQa(String code) async {
    var result;
    var response = await Network().getData("/qa/$code");
    if (response['success'] == true) {
      result = {
        'success': true,
        'qa': Qa.fromJson(response['qa']),
        'linkcode': Linkcode.fromJson(response['linkcode']),
      };
    } else {
      result = {'success': false, 'message': response['message']};
    }
    return result;
  }

  Future<Map<String, dynamic>> saveAnswers(List<Answer> answers) async {
    var result;

    final Map<String, dynamic> answersData = {
      'answers': answers,
    };
    debugPrint('request:' + json.encode(answersData));

    var response = await Network().postData(answersData, '/answer/save');
    if (response['success'] != null) {
      if (response['success'] == true) {
        result = {
          'success': true,
        };
      } else {
        result = {
          'success': false,
          'message': response['message'],
        };
      }
    } else {
      result = {
        'success': false,
      };
    }

    return result;
  }
}
