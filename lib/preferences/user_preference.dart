import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubaline_ta/services/service_profile.dart';

class UserPreference {
  ServiceProfile serviceProfile = ServiceProfile();
  late SharedPreferences sharedPreferences;
  setSharedPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  UserPreference() {
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
    serviceProfile.setProfile(id).then((value) {
      sharedPreferences.setString('profile', value);
      sharedPreferences.setBool('login', login);
      sharedPreferences.setString('id', id);
    });
  }

  void setLogout() {
    sharedPreferences.remove('login');
    sharedPreferences.remove('id');
    sharedPreferences.remove('profile');
  }
}
