import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fkgame/core/services/auth.dart';
import 'package:fkgame/core/services/storage.dart';
import 'package:fkgame/core/constants/error_messages.dart';
import 'package:fkgame/features/auth/domain/repositories/auth_repository.dart';
import 'package:fkgame/features/auth/data/models/auth_model.dart';
import 'package:fkgame/features/auth/logic/auth_state.dart';

/// 认证Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final AuthService _authService;
  final StorageService _storage;

  AuthCubit(this._authRepository, this._authService, this._storage)
    : super(AuthState.initial());

  /// 检查认证状态
  Future<void> checkAuthStatus() async {
    if (!_authService.isAuthenticated()) {
      emit(state.unauthenticated());
      return;
    }

    emit(state.loading());

    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(state.unauthenticated(message: failure.message)),
      (user) => emit(
        state.authenticated(
          user: user,
          token: _authService.getToken() ?? '',
          refreshToken: _authService.getRefreshToken() ?? '',
        ),
      ),
    );
  }

  /// 登录
  Future<void> login(String email, String password) async {
    emit(state.loading());

    final request = LoginRequest(email: email, password: password);
    final result = await _authRepository.login(request);

    result.fold(
      (failure) => emit(state.error(failure.message)),
      (auth) => emit(
        state.authenticated(
          user: auth.user,
          token: auth.token,
          refreshToken: auth.refreshToken,
        ),
      ),
    );
  }

  /// 注册
  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    emit(state.loading());

    final request = RegisterRequest(
      username: username,
      email: email,
      password: password,
      phone: phone,
    );

    final result = await _authRepository.register(request);

    result.fold(
      (failure) => emit(state.error(failure.message)),
      (auth) => emit(
        state.authenticated(
          user: auth.user,
          token: auth.token,
          refreshToken: auth.refreshToken,
        ),
      ),
    );
  }

  /// 登出
  Future<void> logout() async {
    emit(state.loading());

    final result = await _authRepository.logout();
    result.fold(
      (failure) => emit(state.error(failure.message)),
      (_) => emit(state.unauthenticated()),
    );
  }

  /// 刷新令牌
  Future<void> refreshToken() async {
    final refreshToken = _storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      emit(state.unauthenticated(message: ErrorMessages.refreshTokenNotExist));
      return;
    }

    emit(state.loading());

    final result = await _authRepository.refreshToken(refreshToken);
    result.fold(
      (failure) => emit(state.unauthenticated(message: failure.message)),
      (auth) => emit(
        state.authenticated(
          user: auth.user,
          token: auth.token,
          refreshToken: auth.refreshToken,
        ),
      ),
    );
  }
}
