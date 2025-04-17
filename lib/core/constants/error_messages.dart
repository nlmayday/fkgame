/// 错误消息常量
class ErrorMessages {
  // 通用错误
  static const String unknownError = 'errors.unknown';
  static const String serverError = 'errors.server';

  // 网络错误
  static const String connectionTimeout = 'errors.network.timeout';
  static const String connectionFailed = 'errors.network.failed';

  // 认证错误
  static const String authExpired = 'errors.auth.expired';
  static const String authFailed = 'errors.auth.failed';
  static const String notLoggedIn = 'errors.auth.not_logged_in';

  // 登录错误
  static const String loginFailed = 'errors.login.failed';
  // 注册错误
  static const String registerFailed = 'errors.register.failed';

  // 刷新令牌错误
  static const String refreshTokenFailed = 'errors.token.refresh_failed';
  static const String refreshTokenNotExist = 'errors.token.not_exist';

  // 用户信息错误
  static const String getUserInfoFailed = 'errors.user.get_info_failed';

  // 密码重置错误
  static const String resetPasswordFailed = 'errors.password.reset_failed';
  static const String resetEmailNotFound = 'errors.password.email_not_found';
  static const String resetTokenInvalid = 'errors.password.token_invalid';

  // 错误代码映射
  static String getMessageByCode(String code) {
    final Map<String, String> codeToMessage = {
      'AUTH_EXPIRED': authExpired,
      'CONNECTION_TIMEOUT': connectionTimeout,
      'CONNECTION_FAILED': connectionFailed,
      'SERVER_ERROR': serverError,
      // 可以添加更多错误代码映射
    };

    return codeToMessage[code] ?? unknownError;
  }
}
