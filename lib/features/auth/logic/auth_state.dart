import 'package:equatable/equatable.dart';

import 'package:fkgame/features/auth/data/models/user_model.dart';

/// 认证状态枚举
enum AuthStatus {
  initial, // 初始状态
  authenticated, // 已认证
  unauthenticated, // 未认证
}

/// 认证状态类
class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? token;
  final String? refreshToken;
  final String? message;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.token,
    this.refreshToken,
    this.message,
    this.isLoading = false,
  });

  /// 初始状态工厂方法
  factory AuthState.initial() => const AuthState();

  /// 加载中状态
  AuthState loading() => copyWith(isLoading: true, message: null);

  /// 认证成功状态
  AuthState authenticated({
    required UserModel user,
    required String token,
    required String refreshToken,
  }) {
    return copyWith(
      status: AuthStatus.authenticated,
      user: user,
      token: token,
      refreshToken: refreshToken,
      isLoading: false,
      message: null,
    );
  }

  /// 未认证状态
  AuthState unauthenticated({String? message}) {
    return copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      token: null,
      refreshToken: null,
      isLoading: false,
      message: message,
    );
  }

  /// 错误状态
  AuthState error(String message) {
    return copyWith(isLoading: false, message: message);
  }

  /// 判断是否已认证
  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  /// 复制方法
  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? token,
    String? refreshToken,
    String? message,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      message: message,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    token,
    refreshToken,
    message,
    isLoading,
  ];
}
