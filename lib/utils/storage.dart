import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? preferences;

  static Future<bool> getInstance() async {
    preferences = await SharedPreferences.getInstance();
    return true;
  }

  static Future<void> setString(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  static Future<String?> getString(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static String? getstaticString(key) {
    return preferences!.getString(key);
  }

  static Future<void> setInt(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(key, value);
  }

  static int getInt(key, {int defValue = 0}) {
    if (preferences == null) return defValue;
    return preferences!.getInt(key) ?? defValue;
  }

  static Future<void> setBool(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(key, value);
  }

  static bool getBool(key, {bool defValue = false}) {
    if (preferences == null) return defValue;
    return preferences!.getBool(key) ?? defValue;
  }

  static Future<bool> remove(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.remove(key);
  }

  static Future<bool> clear(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.clear();
  }

  /// get obj.
  static T? getObj<T>(String key, T f(Map v), {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map? getObject(String key) {
    if (preferences == null) return null;
    String? _data = preferences!.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object.
  static Future<bool>? putObject(String key, Object value) {
    if (preferences == null) return null;
    return preferences!.setString(key, value == null ? "" : json.encode(value));
  }

  /// put object list.
  /// 存储sp中key的list集合
  static Future<bool>? putObjectList(String key, List<Object> list) {
    if (preferences == null) {
      return null;
      //return Future.value(false);
    }
    List<String>? _dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return preferences?.setStringList(key, _dataList);
  }

  /// get object list.
  /// 获取sp中key的list集合
  static List<Map>? getObjectList(String key) {
    if (preferences == null) {
      return null;
    }
    List<String>? dataLis = preferences?.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    }).toList();
  }
}
