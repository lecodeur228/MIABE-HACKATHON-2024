import 'dart:convert';

import 'package:ctrl_r/constants/api.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String,dynamic>?> login({required String matricule, password}) async {
    final response = await http.post(Uri.parse("$api/login"), body: {
      "matricule": matricule,
      "password": password,
    });
    if (response.statusCode == 200) {
      print("data: ${response.body}");
      return json.decode(response.body);
    } else {
      print('error : ${response.statusCode}');
      return null;
    }
  }


 
}
