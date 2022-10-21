import 'package:shared_preferences/shared_preferences.dart';

class LoginPreference {
  late SharedPreferences sharedPreferences;
  setSharedPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  LoginPreference() {
    setSharedPreference();
  }
  Future<bool> getLogin() async {
    if (!sharedPreferences.containsKey('login')) {
      await sharedPreferences.setBool('login', false);
      var data = sharedPreferences.getBool('login');
      return data!;
    } else {
      var data = sharedPreferences.getBool('login');
      return data!;
    }
  }

  void setLogin(bool login, String id) {
    sharedPreferences.setBool('login', login);
    sharedPreferences.setString('id', id);
  }

  void setLogout() {
    sharedPreferences.remove('login');
  }
}