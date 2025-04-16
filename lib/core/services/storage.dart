import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 存储键名常量
class StorageKeys {
  static const String token = 'auth_token'; // 认证令牌
  static const String refreshToken = 'refresh_token'; // 刷新令牌
  static const String userId = 'user_id'; // 用户ID
  static const String username = 'username'; // 用户名
  static const String languageCode = 'language_code'; // 语言代码
  static const String themeMode = 'theme_mode'; // 主题模式
  static const String userSettings = 'user_settings'; // 用户设置
}

/// 存储服务接口
abstract class StorageService {
  // 认证相关
  String? getToken();
  Future<void> setToken(String token);
  Future<void> clearToken();

  String? getRefreshToken();
  Future<void> setRefreshToken(String token);

  String? getUserId();
  Future<void> setUserId(String id);

  String? getUsername();
  Future<void> setUsername(String username);

  Future<void> clearAuthData();

  // 设置相关
  String? getLanguageCode();
  Future<void> setLanguageCode(String languageCode);

  int? getThemeMode();
  Future<void> setThemeMode(int mode);

  // 通用方法
  T? getValue<T>(String key);
  Future<void> setValue<T>(String key, T value);
  Future<void> removeValue(String key);
  Future<void> clearAll();
}

/// SharedPreferences实现的存储服务
class SharedPrefsService implements StorageService {
  final SharedPreferences _prefs;

  SharedPrefsService(this._prefs);

  // 认证相关
  @override
  String? getToken() => _prefs.getString(StorageKeys.token);

  @override
  Future<void> setToken(String token) =>
      _prefs.setString(StorageKeys.token, token);

  @override
  Future<void> clearToken() => _prefs.remove(StorageKeys.token);

  @override
  String? getRefreshToken() => _prefs.getString(StorageKeys.refreshToken);

  @override
  Future<void> setRefreshToken(String token) =>
      _prefs.setString(StorageKeys.refreshToken, token);

  @override
  String? getUserId() => _prefs.getString(StorageKeys.userId);

  @override
  Future<void> setUserId(String id) => _prefs.setString(StorageKeys.userId, id);

  @override
  String? getUsername() => _prefs.getString(StorageKeys.username);

  @override
  Future<void> setUsername(String username) =>
      _prefs.setString(StorageKeys.username, username);

  @override
  Future<void> clearAuthData() async {
    await _prefs.remove(StorageKeys.token);
    await _prefs.remove(StorageKeys.refreshToken);
    await _prefs.remove(StorageKeys.userId);
    await _prefs.remove(StorageKeys.username);
  }

  // 设置相关
  @override
  String? getLanguageCode() => _prefs.getString(StorageKeys.languageCode);

  @override
  Future<void> setLanguageCode(String languageCode) =>
      _prefs.setString(StorageKeys.languageCode, languageCode);

  @override
  int? getThemeMode() => _prefs.getInt(StorageKeys.themeMode);

  @override
  Future<void> setThemeMode(int mode) =>
      _prefs.setInt(StorageKeys.themeMode, mode);

  // 通用方法
  @override
  T? getValue<T>(String key) {
    final value = _prefs.get(key);
    if (value == null) {
      return null;
    }

    // 对于存储的JSON字符串，自动反序列化
    if (T == Map || T == List) {
      if (value is String) {
        try {
          return jsonDecode(value) as T;
        } catch (_) {
          return null;
        }
      }
    }

    return value as T;
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    if (value == null) {
      await _prefs.remove(key);
      return;
    }

    // 根据类型使用不同的设置方法
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      // 其他类型转为JSON字符串存储
      final jsonString = jsonEncode(value);
      await _prefs.setString(key, jsonString);
    }
  }

  @override
  Future<void> removeValue(String key) => _prefs.remove(key);

  @override
  Future<void> clearAll() => _prefs.clear();
}
