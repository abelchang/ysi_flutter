import 'dart:convert';

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
}
