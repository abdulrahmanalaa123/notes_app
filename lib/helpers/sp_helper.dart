import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  late final Future<SharedPreferences> _mySp;

  SharedPreferenceHelper() {
    _mySp = SharedPreferences.getInstance();
  }

  Future<dynamic> get(String name, Type type) async {
    final hereSp = await _mySp;
    switch (type) {
      case int:
        return hereSp.getInt(name);
      case double:
        return hereSp.getDouble(name);
      case String:
        return hereSp.getString(name);
      case bool:
        return hereSp.getBool(name);
      default:
        return hereSp.getStringList(name);
    }
  }

  Future<bool> set(dynamic value, String key) async {
    final hereSp = await _mySp;
    Type type = value.runtimeType;
    switch (type) {
      case int:
        return hereSp.setInt(key, value);
      case double:
        return hereSp.setDouble(key, value);
      case String:
        return hereSp.setString(key, value);
      case bool:
        return hereSp.setBool(key, value);
      default:
        return hereSp.setStringList(key, value);
    }
  }

  Future<void> remove(String key) async {
    final hereSp = await _mySp;
    await hereSp.remove(key);
  }
}
