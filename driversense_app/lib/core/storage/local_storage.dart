import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage wrapper for non-sensitive data
@lazySingleton
class LocalStorage {
  SharedPreferences? _prefs;

  /// Initialize shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw StateError('LocalStorage not initialized. Call init() first.');
    }
    return _prefs!;
  }

  /// Get a string value
  String? getString(String key) {
    return _preferences.getString(key);
  }

  /// Set a string value
  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  /// Get an int value
  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// Set an int value
  Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  /// Get a double value
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  /// Set a double value
  Future<bool> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  /// Get a bool value
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// Set a bool value
  Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  /// Get a string list
  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  /// Set a string list
  Future<bool> setStringList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  /// Get a JSON object
  Map<String, dynamic>? getJson(String key) {
    final jsonString = _preferences.getString(key);
    if (jsonString == null) return null;
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Set a JSON object
  Future<bool> setJson(String key, Map<String, dynamic> value) {
    return _preferences.setString(key, json.encode(value));
  }

  /// Get a DateTime value
  DateTime? getDateTime(String key) {
    final millis = _preferences.getInt(key);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Set a DateTime value
  Future<bool> setDateTime(String key, DateTime value) {
    return _preferences.setInt(key, value.millisecondsSinceEpoch);
  }

  /// Remove a key
  Future<bool> remove(String key) {
    return _preferences.remove(key);
  }

  /// Clear all preferences
  Future<bool> clear() {
    return _preferences.clear();
  }

  /// Check if a key exists
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  /// Get all keys
  Set<String> getKeys() {
    return _preferences.getKeys();
  }
}
