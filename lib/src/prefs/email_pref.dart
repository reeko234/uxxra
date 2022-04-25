import 'package:shared_preferences/shared_preferences.dart';

class EmailPref {
  Future<void> saveEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
  }

  Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    return email;
  }

  void removeEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
  }
}
