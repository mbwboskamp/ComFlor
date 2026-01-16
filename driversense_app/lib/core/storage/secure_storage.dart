import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Secure storage wrapper for sensitive data
@lazySingleton
class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  /// Read a value from secure storage
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  /// Write a value to secure storage
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Delete a value from secure storage
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all values from secure storage
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Check if a key exists in secure storage
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Read all values from secure storage
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
