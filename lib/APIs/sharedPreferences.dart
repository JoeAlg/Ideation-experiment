import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

Future<void> initSharedPreferences() async => prefs = await SharedPreferences.getInstance();

sharedPreferencesGetValue(String _key) => prefs.get(_key);

sharedPreferencesRemoveValue(String _key) => prefs.remove(_key);

Future<void> sharedPreferencesSetInt(String _key, int _value) async => await prefs.setInt(_key, _value);

Future<void> sharedPreferencesSetString(String _key, String _value) async => await prefs.setString(_key, _value);

Future<void> sharedPreferencesSetBool(String _key, bool _value) async => await prefs.setBool(_key, _value);
