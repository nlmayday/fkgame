import 'package:flutter/foundation.dart';

import 'storage.dart';
import '../../features/auth/data/models/user_model.dart';

/// 认证服务接口
abstract class AuthService {
  /// 获取访问令牌
  String? getToken();

  /// 获取刷新令牌
  String? getRefreshToken();

  /// 设置访问令牌
  Future<void> setToken(String token);

  /// 设置刷新令牌
  Future<void> setRefreshToken(String token);

  /// 获取用户ID
  String? getUserId();

  /// 获取用户名
  String? getUsername();

  /// 清除认证数据
  Future<void> clearAuthData();

  /// 检查用户是否已认证
  bool isAuthenticated();
}

/// 认证服务实现
class AuthServiceImpl implements AuthService {
  final StorageService _storage;

  AuthServiceImpl(this._storage);

  @override
  String? getToken() => _storage.getToken();

  @override
  String? getRefreshToken() => _storage.getRefreshToken();

  @override
  Future<void> setToken(String token) => _storage.setToken(token);

  @override
  Future<void> setRefreshToken(String token) => _storage.setRefreshToken(token);

  @override
  String? getUserId() => _storage.getUserId();

  @override
  String? getUsername() => _storage.getUsername();

  @override
  Future<void> clearAuthData() => _storage.clearAuthData();

  @override
  bool isAuthenticated() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}
