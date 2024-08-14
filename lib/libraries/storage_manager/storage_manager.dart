import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:logger/logger.dart';

class FileStorage {
  static final _encrypter =
      encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));
  static final _logger = Logger();

  // Get the directory for storing files
  static Future<Directory> _getDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  // Get a file based on the provided file name
  static Future<File> _getFile(String fileName) async {
    final directory = await _getDirectory();
    final path = '${directory.path}/$fileName';
    return File(path);
  }

  // Save data to a file with the provided key
  static Future<void> save(String key, dynamic value) async {
    try {
      final file = await _getFile(key);
      final jsonString = jsonEncode(value);
      final encrypted =
          _encrypter.encrypt(jsonString, iv: encrypt.IV.fromLength(16)).base64;
      await file.writeAsString(encrypted);
      _logger.i('Data saved successfully for key: $key');
    } catch (e) {
      _logger.e('Error saving data for key: $key', error: e);
    }
  }

  // Read data from a file with the provided key
  static Future<dynamic> read(String key) async {
    try {
      final file = await _getFile(key);
      final encrypted = await file.readAsString();
      final decrypted =
          _encrypter.decrypt64(encrypted, iv: encrypt.IV.fromLength(16));
      _logger.i('Data read successfully for key: $key');
      return jsonDecode(decrypted);
    } catch (e) {
      _logger.e('Error reading data for key: $key', error: e);
      return null;
    }
  }

  // Delete the file with the provided key
  static Future<void> delete(String key) async {
    try {
      final file = await _getFile(key);
      if (await file.exists()) {
        await file.delete();
        _logger.i('File deleted successfully for key: $key');
      }
    } catch (e) {
      _logger.e('Error deleting file for key: $key', error: e);
    }
  }

  // Clear all files in the storage directory
  static Future<void> clear() async {
    try {
      final directory = await _getDirectory();
      final files = directory.listSync();
      for (var file in files) {
        if (file is File) {
          await file.delete();
        }
      }
      _logger.i('All files cleared from storage');
    } catch (e) {
      _logger.e('Error clearing storage', error: e);
    }
  }

  // Set expiration time for a key
  static Future<void> setExpiration(String key, Duration duration) async {
    try {
      final expirationTime = DateTime.now().add(duration).toIso8601String();
      final expirationMap =
          await read('_expiration') as Map<String, String>? ?? {};
      expirationMap[key] = expirationTime;
      await save('_expiration', expirationMap);
      _logger.i('Expiration set for key: $key');
    } catch (e) {
      _logger.e('Error setting expiration for key: $key', error: e);
    }
  }

  // Check if the data for a key has expired
  static Future<bool> isExpired(String key) async {
    try {
      final expirationMap =
          await read('_expiration') as Map<String, String>? ?? {};
      final expirationTime = expirationMap[key];
      if (expirationTime == null) return false;
      final isExpired = DateTime.now().isAfter(DateTime.parse(expirationTime));
      _logger.i('Expiration checked for key: $key, isExpired: $isExpired');
      return isExpired;
    } catch (e) {
      _logger.e('Error checking expiration for key: $key', error: e);
      return false;
    }
  }

  // Delete expired data
  static Future<void> deleteExpired() async {
    try {
      final expirationMap =
          await read('_expiration') as Map<String, String>? ?? {};
      final now = DateTime.now();
      for (final entry in expirationMap.entries) {
        final key = entry.key;
        final expirationTime = DateTime.parse(entry.value);
        if (now.isAfter(expirationTime)) {
          await delete(key);
          expirationMap.remove(key);
        }
      }
      await save('_expiration', expirationMap);
      _logger.i('Expired data deleted');
    } catch (e) {
      _logger.e('Error deleting expired data', error: e);
    }
  }

  // List all files
  static Future<List<String>> listFiles() async {
    try {
      final directory = await _getDirectory();
      final files = directory.listSync().whereType<File>().toList();
      final fileNames =
          files.map((file) => file.uri.pathSegments.last).toList();
      _logger.i('Listed files: $fileNames');
      return fileNames;
    } catch (e) {
      _logger.e('Error listing files', error: e);
      return [];
    }
  }

  // Get the total size of all files
  static Future<int> getStorageSize() async {
    try {
      final directory = await _getDirectory();
      final files = directory.listSync().whereType<File>();
      int totalSize = 0;
      for (var file in files) {
        totalSize += await file.length();
      }
      _logger.i('Total storage size: $totalSize bytes');
      return totalSize;
    } catch (e) {
      _logger.e('Error getting storage size', error: e);
      return 0;
    }
  }

  // Save specific data types
  static Future<void> saveString(String key, String value) async {
    await save(key, value);
  }

  static Future<String?> readString(String key) async {
    final result = await read(key);
    return result is String ? result : null;
  }

  static Future<void> saveInt(String key, int value) async {
    await save(key, value);
  }

  static Future<int?> readInt(String key) async {
    final result = await read(key);
    return result is int ? result : null;
  }

  static Future<void> saveBool(String key, bool value) async {
    await save(key, value);
  }

  static Future<bool?> readBool(String key) async {
    final result = await read(key);
    return result is bool ? result : null;
  }
}
