import 'dart:convert';

import 'package:ysi/models/project.dart';
import 'package:ysi/network_utils/api.dart';
import 'package:ysi/services/sharedPref.dart';

class ProjectService {
  Future getAllComapnies() async {
    var result;

    var response = await Network().getData("/getallcompanies");
    if (response['success'] == true) {
      if (response['companies'] != null) {
        SharedPref().saveCompanies(response['companies']);
      }

      result = {
        'success': true,
      };
    } else {
      result = {'success': false, 'message': json.decode(response)['message']};
    }

    return result;
  }

  Future<Map<String, dynamic>> createProject(Project project) async {
    var result;

    final Map<String, dynamic> projectData = {
      'project': project,
    };

    var response = await Network().postData(projectData, '/project/save');
    if (response['success'] != null) {
      if (response['success'] == true) {
        result = {'success': true, 'project': project};
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
}
