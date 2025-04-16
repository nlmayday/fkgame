import 'package:equatable/equatable.dart';

/// 用户角色
enum UserRole { user, moderator, admin }

/// 用户状态
enum UserStatus { active, inactive, banned }

/// 用户模型类
class UserModel extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final UserRole role;
  final UserStatus status;
  final int gamePoint;
  final int level;
  final int exp;
  final String? loginIp;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.role,
    required this.status,
    required this.gamePoint,
    required this.level,
    required this.exp,
    this.loginIp,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从JSON映射
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      role: _parseRole(json['role']),
      status: _parseStatus(json['status']),
      gamePoint: json['game_point'],
      level: json['level'],
      exp: json['exp'],
      loginIp: json['login_ip'],
      lastLoginAt:
          json['last_login_at'] != null
              ? DateTime.parse(json['last_login_at'])
              : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'role': role.toString().split('.').last,
      'status': status.toString().split('.').last,
      'game_point': gamePoint,
      'level': level,
      'exp': exp,
      'login_ip': loginIp,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 复制方法
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    UserStatus? status,
    int? gamePoint,
    int? level,
    int? exp,
    String? loginIp,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      gamePoint: gamePoint ?? this.gamePoint,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      loginIp: loginIp ?? this.loginIp,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 解析用户角色
  static UserRole _parseRole(String roleStr) {
    switch (roleStr) {
      case 'admin':
        return UserRole.admin;
      case 'moderator':
        return UserRole.moderator;
      case 'user':
      default:
        return UserRole.user;
    }
  }

  /// 解析用户状态
  static UserStatus _parseStatus(String statusStr) {
    switch (statusStr) {
      case 'inactive':
        return UserStatus.inactive;
      case 'banned':
        return UserStatus.banned;
      case 'active':
      default:
        return UserStatus.active;
    }
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    phone,
    avatarUrl,
    role,
    status,
    gamePoint,
    level,
    exp,
    loginIp,
    lastLoginAt,
    createdAt,
    updatedAt,
  ];
}
