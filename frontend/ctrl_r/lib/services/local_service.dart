import 'package:ctrl_r/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  static Future<void> saveUserData(User user) async {
    final pref = await SharedPreferences.getInstance();
    final userData = user.toJson();
    await pref.setString('token', userData['token']);
    await pref.setInt('id', userData['id']);
    await pref.setString('name', userData['name']);
    await pref.setString('email', userData['email']);
    await pref.setString('contact', userData['contact']);
    await pref.setString('matricule', userData['matricule']);
    await pref.setString('role', userData['role']);
  }

  static Future<User?> getUserData() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final id = pref.getInt('id');
    final name = pref.getString('name');
    final email = pref.getString('email');
    final contact = pref.getString('contact');
    final matricule = pref.getString('matricule');
    final role = pref.getString('role');

    if (token != null &&
        id != null &&
        name != null &&
        email != null &&
        contact != null &&
        matricule != null && role != null) {
      return User(
          id: id,
          name: name,
          email: email,
          contact: contact,
          token: token,
          matricule: matricule,
          role: role,
          );
    } else {
      return null;
    }
  }

  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      return token;
    } else {
      return null;
    }
  }

  static Future<void> deleteAllUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Supprime toutes les préférences
  }
}
