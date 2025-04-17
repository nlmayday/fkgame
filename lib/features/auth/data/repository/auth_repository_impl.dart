import 'package:dartz/dartz.dart';

import 'package:fkgame/core/error/failures.dart';
import 'package:fkgame/core/network/api/client.dart';
import 'package:fkgame/core/services/storage.dart';
import 'package:fkgame/core/services/mock_auth_service.dart';
import 'package:fkgame/core/constants/error_messages.dart';
import 'package:fkgame/features/auth/domain/repositories/auth_repository.dart';
import 'package:fkgame/features/auth/data/models/auth_model.dart';
import 'package:fkgame/features/auth/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storage;
  final MockAuthService _mockAuthService;

  AuthRepositoryImpl(this._apiClient, this._storage)
    : _mockAuthService = MockAuthService(_storage);

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      // 使用模拟服务进行登录
      return await _mockAuthService.login(request);

      // 注释掉真实API调用
      /*
      final response = await _apiClient.post(
        '/auth/login',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response);

      // 保存认证信息
      await _saveAuthData(authResponse);

      return Right(authResponse);
      */
    } on ApiException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: ErrorMessages.loginFailed));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      // 使用模拟服务进行注册
      return await _mockAuthService.register(request);

      // 注释掉真实API调用
      /*
      final response = await _apiClient.post(
        '/auth/register',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response);

      // 保存认证信息
      await _saveAuthData(authResponse);

      return Right(authResponse);
      */
    } on ApiException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: ErrorMessages.registerFailed));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      // 使用模拟服务获取当前用户
      return await _mockAuthService.getCurrentUser();

      // 注释掉真实API调用
      /*
      final token = _storage.getToken();

      if (token == null) {
        return Left(AuthFailure(message: ErrorMessages.notLoggedIn));
      }

      final response = await _apiClient.get('/auth/me');
      final user = UserModel.fromJson(response);

      return Right(user);
      */
    } on ApiException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: ErrorMessages.getUserInfoFailed));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      // 使用模拟服务退出登录
      return await _mockAuthService.logout();

      // 注释掉真实API调用
      /*
      await _apiClient.post('/auth/logout');
      await _storage.clearAuthData();
      return const Right(true);
      */
    } catch (e) {
      // 即使API调用失败，也要清除本地存储
      await _storage.clearAuthData();
      return const Right(true);
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken(
    String refreshToken,
  ) async {
    try {
      // 使用模拟服务刷新令牌
      return await _mockAuthService.refreshToken(refreshToken);

      // 注释掉真实API调用
      /*
      final response = await _apiClient.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final authResponse = AuthResponse.fromJson(response);

      // 保存更新的认证信息
      await _saveAuthData(authResponse);

      return Right(authResponse);
      */
    } on ApiException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: ErrorMessages.refreshTokenFailed));
    }
  }

  /// 保存认证数据到本地存储（已由模拟服务处理，保留以便将来切换回真实API）
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _storage.setToken(authResponse.token);
    await _storage.setRefreshToken(authResponse.refreshToken);
    await _storage.setUserId(authResponse.user.id.toString());
    await _storage.setUsername(authResponse.user.username);
  }

  // 添加密码重置相关方法

  /// 请求重置密码（发送重置邮件）
  Future<Either<Failure, bool>> requestPasswordReset(String email) async {
    try {
      return await _mockAuthService.requestPasswordReset(email);
    } catch (e) {
      return Left(ServerFailure(message: ErrorMessages.resetPasswordFailed));
    }
  }

  /// 重置密码
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      return await _mockAuthService.resetPassword(
        email: email,
        token: token,
        newPassword: newPassword,
      );
    } catch (e) {
      return Left(ServerFailure(message: ErrorMessages.resetPasswordFailed));
    }
  }
}
