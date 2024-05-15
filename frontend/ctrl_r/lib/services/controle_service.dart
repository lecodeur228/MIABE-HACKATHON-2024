import 'dart:convert';

import 'package:ctrl_r/models/controle.dart';
import 'package:ctrl_r/services/local_service.dart';
import 'package:http/http.dart' as http;
import 'package:ctrl_r/constants/api.dart';

class ControleService {
  static Future addControls(Map<String, dynamic> data) async {
    String? token = await LocalService.getUserToken();

    Map<String, dynamic> requestBody = {
      "plaque": data["plaque"],
      "nom_conducteur": data["nom_conducteur"],
      "permit_conduire": data["permit_conduire"],
      "date_validite_carte_grise": data["date_validite_carte_grise"],
      "carte_visite_technique": data["carte_visite_technique"],
      "date_expiration": null,
      "assurance": data["assurance"],
      "tvm": data["tvm"],
      "latitude": data["latitude"],
      "longitude": data["longitude"],
    };

    // Convertissez l'objet Map en JSON
    String jsonData = jsonEncode(requestBody);

    // Envoi des données JSON dans le corps de la requête HTTP POST
    final response = await http.post(
      Uri.parse("$api/controls/add"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type":
            "application/json", // Définissez le type de contenu sur JSON
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print("data: ${response.body}");
      return json.decode(response.body);
    } else {
      print('error : ${response.body}');
      return null;
    }
  }

  static Future<List<Controle>> getControls() async {
    String? token = await LocalService.getUserToken();
    final response = await http.get(
      Uri.parse("$api/controls"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> controleJsonList = responseData['controls'];
      print(controleJsonList);
      return controleJsonList.map((json) => Controle.fromJson(json)).toList();
    } else {
      print('error : ${response.body}');
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  static Future<Map<String, dynamic>?> getBilan() async {
    String? token = await LocalService.getUserToken();
    final response = await http.get(
      Uri.parse("$api/controls/bilan"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print("status : ${response.statusCode}");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('error : ${response.body}');
      return null; // Retourner null en cas d'échec de la requête
    }
  }

  static Future fakeDelete(int id) async {
    String? token = await LocalService.getUserToken();
    final response = await http.post(Uri.parse("$api/controls/fakeDelete/$id"),
    headers: {
       "Authorization": "Bearer $token",
    }
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
       print('error : ${response.body}');
      return null;
    }
  }
}
