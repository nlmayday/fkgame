import 'package:dartz/dartz.dart';

import 'package:fkgame/core/error/failures.dart';
import 'package:fkgame/core/network/api/client.dart';
import 'package:fkgame/core/services/storage.dart';
import 'package:fkgame/core/constants/error_messages.dart';
import 'package:fkgame/features/auth/domain/repositories/auth_repository.dart';
import 'package:fkgame/features/auth/data/models/auth_model.dart';
import 'package:fkgame/features/auth/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storage;

  AuthRepositoryImpl(this._apiClient, this._storage);

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response);

      // 保存认证信息
      await _saveAuthData(authResponse);

      return Right(authResponse);
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
      final response = await _apiClient.post(
        '/auth/register',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response);

      // 保存认证信息
      await _saveAuthData(authResponse);

      return Right(authResponse);
    } on ApiException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: ErrorMessages.registerFailed));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final token = _storage.getToken();

      if (token == null) {
        return Left(AuthFailure(message: ErrorMessages.notLoggedIn));
      }

      final response = await _apiClient.get('/auth/me');
      final user = UserModel.fromJson(response);

      return Right(user);
    } on ApiException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: ErrorMessages.getUserInfoFailed));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _apiClient.post('/auth/logout');
      await _storage.clearAuthData();
      return const Right(true);
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
      final response = await _apiClient.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final authResponse = AuthResponse.fromJson(response);

      // 保存更新的认证信息
      await _saveAuthData(authResponse);

      return Right(authResponse);
    } on ApiException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: ErrorMessages.refreshTokenFailed));
    }
  }

  /// 保存认证数据到本地存储
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _storage.setToken(authResponse.token);
    await _storage.setRefreshToken(authResponse.refreshToken);
    await _storage.setUserId(authResponse.user.id.toString());
    await _storage.setUsername(authResponse.user.username);
  }
}
