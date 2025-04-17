import 'dart:convert';
import 'dart:math';

import 'package:fkgame/core/error/failures.dart';
import 'package:fkgame/core/services/storage.dart';
import 'package:fkgame/features/auth/data/models/auth_model.dart';
import 'package:fkgame/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:crypto/crypto.dart';

/// 用于模拟身份验证的服务类
/// 提供模拟的登录、注册和密码重置功能
class MockAuthService {
  final StorageService _storage;

  // 内存中的用户数据库
  final Map<String, _MockUser> _users = {};

  // 模拟的重置密码令牌
  final Map<String, String> _resetTokens = {};

  MockAuthService(this._storage) {
    _initializeDefaultUsers();
  }

  /// 初始化默认用户账号
  void _initializeDefaultUsers() {
    // 添加默认测试账号: 123456@qq.com / 123456
    final defaultUser = _MockUser(
      email: '123456@qq.com',
      password: _hashPassword('123456'),
      username: '测试用户',
      id: 1001,
      role: UserRole.user,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );

    _users[defaultUser.email] = defaultUser;

    // 添加管理员账号: admin@example.com / admin123
    final adminUser = _MockUser(
      email: 'admin@example.com',
      password: _hashPassword('admin123'),
      username: '管理员',
      id: 1,
      role: UserRole.admin,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    );

    _users[adminUser.email] = adminUser;
  }

  /// 模拟登录
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    // 检查用户是否存在
    final user = _users[request.email];
    if (user == null) {
      return Left(AuthFailure(message: '用户不存在'));
    }

    // 验证密码
    if (user.password != _hashPassword(request.password)) {
      return Left(AuthFailure(message: '密码错误'));
    }

    // 生成令牌
    final token = _generateToken();
    final refreshToken = _generateToken(isRefresh: true);

    // 更新最后登录时间
    final now = DateTime.now();
    user.lastLoginAt = now;
    user.loginIp = '192.168.1.${Random().nextInt(255)}';

    // 创建用户模型
    final userModel = _createUserModel(user);

    // 创建认证响应
    final authResponse = AuthResponse(
      user: userModel,
      token: token,
      refreshToken: refreshToken,
    );

    // 保存身份验证数据
    await _saveAuthData(authResponse);

    return Right(authResponse);
  }

  /// 模拟注册
  Future<Either<Failure, AuthResponse>> register(
    RegisterRequest request,
  ) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 1000));

    // 检查邮箱是否已存在
    if (_users.containsKey(request.email)) {
      return Left(AuthFailure(message: '该邮箱已被注册'));
    }

    // 创建新用户
    final now = DateTime.now();
    final newUser = _MockUser(
      id: _generateUserId(),
      email: request.email,
      password: _hashPassword(request.password),
      username: request.username,
      phone: request.phone,
      role: UserRole.user,
      createdAt: now,
      lastLoginAt: now,
      loginIp: '192.168.1.${Random().nextInt(255)}',
    );

    // 将用户添加到"数据库"
    _users[newUser.email] = newUser;

    // 生成令牌
    final token = _generateToken();
    final refreshToken = _generateToken(isRefresh: true);

    // 创建用户模型
    final userModel = _createUserModel(newUser);

    // 创建认证响应
    final authResponse = AuthResponse(
      user: userModel,
      token: token,
      refreshToken: refreshToken,
    );

    // 保存身份验证数据
    await _saveAuthData(authResponse);

    return Right(authResponse);
  }

  /// 模拟获取当前用户信息
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));

    // 获取存储的ID
    final userId = _storage.getUserId();
    if (userId == null) {
      return Left(AuthFailure(message: '用户未登录'));
    }

    // 查找用户
    final id = int.tryParse(userId);
    if (id == null) {
      return Left(AuthFailure(message: '无效的用户ID'));
    }

    // 在"数据库"中查找用户
    final user = _users.values.firstWhere(
      (u) => u.id == id,
      orElse: () => throw Exception('用户不存在'),
    );

    final userModel = _createUserModel(user);
    return Right(userModel);
  }

  /// 模拟退出登录
  Future<Either<Failure, bool>> logout() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));

    // 清除存储的认证数据
    await _storage.clearAuthData();

    return const Right(true);
  }

  /// 模拟刷新令牌
  Future<Either<Failure, AuthResponse>> refreshToken(
    String refreshToken,
  ) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));

    // 获取存储的ID
    final userId = _storage.getUserId();
    if (userId == null) {
      return Left(AuthFailure(message: '用户未登录'));
    }

    // 查找用户
    final id = int.tryParse(userId);
    if (id == null) {
      return Left(AuthFailure(message: '无效的用户ID'));
    }

    // 在"数据库"中查找用户
    try {
      final user = _users.values.firstWhere((u) => u.id == id);

      // 生成新令牌
      final newToken = _generateToken();
      final newRefreshToken = _generateToken(isRefresh: true);

      // 创建用户模型
      final userModel = _createUserModel(user);

      // 创建认证响应
      final authResponse = AuthResponse(
        user: userModel,
        token: newToken,
        refreshToken: newRefreshToken,
      );

      // 保存身份验证数据
      await _saveAuthData(authResponse);

      return Right(authResponse);
    } catch (e) {
      return Left(AuthFailure(message: '用户不存在'));
    }
  }

  /// 模拟请求重置密码
  Future<Either<Failure, bool>> requestPasswordReset(String email) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    // 检查用户是否存在
    if (!_users.containsKey(email)) {
      return Left(AuthFailure(message: '该邮箱未注册'));
    }

    // 生成重置令牌
    final resetToken = _generateResetToken();
    _resetTokens[email] = resetToken;

    // 模拟发送重置链接到邮箱（实际上只是打印到控制台）
    print('密码重置链接已发送到 $email');
    print('重置令牌: $resetToken');

    return const Right(true);
  }

  /// 模拟重置密码
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 1000));

    // 检查用户是否存在
    if (!_users.containsKey(email)) {
      return Left(AuthFailure(message: '该邮箱未注册'));
    }

    // 验证重置令牌
    final savedToken = _resetTokens[email];
    if (savedToken == null || savedToken != token) {
      return Left(AuthFailure(message: '无效的重置令牌'));
    }

    // 更新密码
    final user = _users[email]!;
    user.password = _hashPassword(newPassword);

    // 移除使用过的令牌
    _resetTokens.remove(email);

    return const Right(true);
  }

  // 辅助方法

  /// 保存身份验证数据到存储
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _storage.setToken(authResponse.token);
    await _storage.setRefreshToken(authResponse.refreshToken);
    await _storage.setUserId(authResponse.user.id.toString());
    await _storage.setUsername(authResponse.user.username);
  }

  /// 生成访问令牌或刷新令牌
  String _generateToken({bool isRefresh = false}) {
    final random = Random();
    final tokenPrefix = isRefresh ? 'refresh_' : 'access_';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomValue = random.nextInt(100000);

    final data = utf8.encode('$tokenPrefix$timestamp$randomValue');
    final hash = sha256.convert(data);

    return hash.toString();
  }

  /// 生成重置令牌
  String _generateResetToken() {
    final random = Random();
    final tokenPrefix = 'reset_';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomValue = random.nextInt(100000);

    final data = utf8.encode('$tokenPrefix$timestamp$randomValue');
    final hash = sha256.convert(data);

    // 取前8位作为简短重置码
    return hash.toString().substring(0, 8).toUpperCase();
  }

  /// 散列密码（简单示例，实际应用中应使用更强的算法和盐值）
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 生成唯一用户ID
  int _generateUserId() {
    // 如果没有用户，从1000开始
    if (_users.isEmpty) {
      return 1000;
    }

    // 否则找到最大ID并加1
    final maxId = _users.values.map((u) => u.id).reduce(max);
    return maxId + 1;
  }

  /// 从内部用户对象创建UserModel
  UserModel _createUserModel(_MockUser user) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      phone: user.phone,
      avatarUrl:
          user.avatarUrl ?? 'https://picsum.photos/200/200?random=${user.id}',
      role: user.role,
      status: UserStatus.active,
      gamePoint: user.gamePoint,
      level: user.level,
      exp: user.exp,
      loginIp: user.loginIp,
      lastLoginAt: user.lastLoginAt,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}

/// 内部使用的用户类模型
class _MockUser {
  final int id;
  final String email;
  String password;
  String username;
  String? phone;
  String? avatarUrl;
  UserRole role;
  UserStatus status;
  int gamePoint;
  int level;
  int exp;
  String? loginIp;
  DateTime? lastLoginAt;
  final DateTime createdAt;
  DateTime updatedAt;

  _MockUser({
    required this.id,
    required this.email,
    required this.password,
    required this.username,
    this.phone,
    this.avatarUrl,
    required this.role,
    this.status = UserStatus.active,
    this.gamePoint = 0,
    this.level = 1,
    this.exp = 0,
    this.loginIp,
    this.lastLoginAt,
    required this.createdAt,
  }) : updatedAt = createdAt;
}
