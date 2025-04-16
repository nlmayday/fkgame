import 'package:equatable/equatable.dart';
import 'user_model.dart';

/// 登录请求数据
class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  @override
  List<Object> get props => [email, password];
}

/// 注册请求数据
class RegisterRequest extends Equatable {
  final String username;
  final String email;
  final String password;
  final String? phone;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'phone': phone,
  };

  @override
  List<Object?> get props => [username, email, password, phone];
}

/// 认证响应数据
class AuthResponse extends Equatable {
  final UserModel user;
  final String token;
  final String refreshToken;

  const AuthResponse({
    required this.user,
    required this.token,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }

  @override
  List<Object> get props => [user, token, refreshToken];
}
