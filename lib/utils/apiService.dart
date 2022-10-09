import 'dart:developer';

import 'package:http/http.dart' as http;
import '../const/apiConstants.dart';
import '../model/userModel.dart';

class ApiService {
  Future<List<UserModel>> getUsers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        log(response.body);
        List<UserModel> _model = userModelFromJson(response.body);
        // return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}