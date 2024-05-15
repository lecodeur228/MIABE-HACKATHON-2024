import 'dart:convert';

import 'package:ctrl_r/constants/api.dart';
import 'package:ctrl_r/models/alert.dart';
import 'package:ctrl_r/services/local_service.dart';
import 'package:http/http.dart' as http;

class AlertService {
  static Future addAlert(
      {required String plaque,
      required String motif,
      required String descrip}) async {
    String? token = await LocalService.getUserToken();

    final response = await http.post(Uri.parse("$api/alerts/add"), headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "plaque": plaque,
      "motif": motif,
      "description": descrip
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('error : ${response.body}');
      return null;
    }
  }

  static Future getAlerts() async {
    String? token = await LocalService.getUserToken();

    final response = await http.get(
      Uri.parse("$api/alerts"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> alertJsonList = responseData['alerts'];

      return alertJsonList.map((json) => Alert.fromJson(json)).toList();
    } else {
      print('error : ${response.body}');
      return [];
    }
  }

  static Future deleteAlert(int id) async {
    String? token = await LocalService.getUserToken();
    final response = await http.delete(
      Uri.parse("$api/alerts/delete/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
       print('error : ${response.body}');
      return null;
    }
  }
}
