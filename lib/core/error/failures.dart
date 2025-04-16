import 'package:equatable/equatable.dart';

/// 失败基类
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({this.message = 'An unexpected error occurred', this.code});

  @override
  List<Object?> get props => [message, code];
}

/// 服务器错误
class ServerFailure extends Failure {
  const ServerFailure({super.message, super.code});
}

/// 网络错误
class NetworkFailure extends Failure {
  const NetworkFailure({super.message, super.code});
}

/// 认证错误
class AuthFailure extends Failure {
  const AuthFailure({super.message, super.code});
}

/// 未找到数据错误
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message, super.code});
}

/// 输入验证错误
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({super.message, super.code, this.errors});

  @override
  List<Object?> get props => [message, code, errors];
}

/// 缓存错误
class CacheFailure extends Failure {
  const CacheFailure({super.message, super.code});
}

/// 超时错误
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Connection timed out, please try again',
    super.code,
  });
}
