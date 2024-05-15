import "dart:convert";

import "package:ctrl_r/constants/api.dart";
import "package:ctrl_r/services/local_service.dart";
import "package:http/http.dart" as http;

class ProfileService {
  static Future<Map<String, dynamic>?> changePassword(
      {required currentPassword, required newPassword}) async {
    String? token = await LocalService.getUserToken();

    final response = await http.post(Uri.parse("$api/password"), headers: {
      "Authorization": "Bearer $token"
    }, body: {
      "current_password": currentPassword,
      "new_password": newPassword,
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      print("data: ${response.body}");
      return json.decode(response.body);
    } else {
      print('error : ${response.statusCode}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> editProfil(
      {required String name,
      required String email,
      required String contact}) async {
    String? token = await LocalService.getUserToken();
    final response = await http.post(Uri.parse("$api/profile"), headers: {
      "Authorization": "Bearer $token"
    }, body: {
      "name": name,
      "email": email,
      "contact": contact,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('error : ${response.statusCode}');
      return null;
    }
  }
}
