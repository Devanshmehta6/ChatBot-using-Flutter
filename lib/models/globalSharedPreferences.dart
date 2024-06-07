import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._();

  late SharedPreferences prefs;

  Future<void> initialise() async {
    prefs = await SharedPreferences.  getInstance();
  }

  static final SharedPreferencesHelper instance = SharedPreferencesHelper._();
}