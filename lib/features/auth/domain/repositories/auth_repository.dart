import 'package:dartz/dartz.dart';

import 'package:fkgame/core/error/failures.dart';
import 'package:fkgame/features/auth/data/models/auth_model.dart';
import 'package:fkgame/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  /// 用户登录
  Future<Either<Failure, AuthResponse>> login(LoginRequest request);

  /// 用户注册
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request);

  /// 获取当前已登录用户信息
  Future<Either<Failure, UserModel>> getCurrentUser();

  /// 退出登录
  Future<Either<Failure, bool>> logout();

  /// 刷新令牌
  Future<Either<Failure, AuthResponse>> refreshToken(String refreshToken);

  /// 请求重置密码（发送重置邮件）
  Future<Either<Failure, bool>> requestPasswordReset(String email);

  /// 重置密码
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });
}
