import 'package:shared_preferences/shared_preferences.dart';

import '../models/token.dart';

class SharedStorage {
  final SharedPreferences _prefs;

  SharedStorage._internal(this._prefs);

  static Future<SharedStorage> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return SharedStorage._internal(prefs);
  }

  setBool(key, value) async {
    _prefs.setBool(key, value);
  }

  setString(key, value) async {
    _prefs.setString(key, value);
  }

  setDouble(key, value) async {
    _prefs.setDouble(key, value);
  }

  setInt(key, value) async {
    _prefs.setInt(key, value);
  }

  setStringList(key, value) async {
    _prefs.setStringList(key, value);
  }

  bool? getBool(key)  {
    return _prefs.getBool(key);
  }

  getString(key) {
    return _prefs.getString(key);
  }

  getInt(key) {
    return _prefs.getInt(key);
  }

  getDouble(key) {
    return _prefs.getDouble(key);
  }

  getStringList(key) {
    return _prefs.getStringList(key);
  }

  remove(key){
    _prefs.remove(key);
  }

}
