import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'FKGame',
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'username': 'Username',
      'phone': 'Phone',
      'confirmPassword': 'Confirm Password',
      'rememberMe': 'Remember me',
      'forgotPassword': 'Forgot Password?',
      'noAccount': 'Don\'t have an account?',
      'alreadyHaveAccount': 'Already have an account?',
      'or': 'OR',
      'and': 'and',
      'agreeToThe': 'I agree to the ',
      'termsOfService': 'Terms of Service',
      'privacyPolicy': 'Privacy Policy',
      'switchLanguage': 'Switch Language',
      'currentLanguage': 'Current: English',

      // 首页文本
      'welcome': 'Welcome',
      'games': 'Games',
      'myGames': 'My Games',
      'popular': 'Popular',
      'recommended': 'Recommended for you',
      'newGames': 'New Games',
      'seeAll': 'See All',
      'ranking': 'Ranking',
      'community': 'Community',
      'settings': 'Settings',
      'profile': 'Profile',
      'friends': 'Friends',
      'messages': 'Messages',
      'search': 'Search games...',
      'home': 'Home',
      'lobby': 'Lobby',
      'social': 'Social',
      'me': 'Me',

      // 游戏详情页
      'howToPlay': 'How to Play',
      'playNow': 'Play Now',
      'description': 'Description',
      'noDescriptionAvailable': 'No description available for this game.',
      'noPlayInstructionsAvailable':
          'No play instructions available for this game.',
      'gameUrlNotAvailable': 'Game URL not available',
      'couldNotLaunchGameUrl': 'Could not launch game URL',

      // 通用按钮和提示
      'retry': 'Retry',

      // 搜索相关文本
      'searchGames': 'Search Games',
      'searchHint': 'Enter keywords to search games',
      'searchNoResults': 'No games found',
      'searchInputPrompt': 'Enter keywords to search',
      'searchGameCategories': 'Search game categories...',
      'noGameCategoriesFound': 'No game categories found',
      'clearFilters': 'Clear filters',
      'allCategories': 'All',
      'gameCategory': 'Game Category',

      // 密码重置相关
      'resetPassword': 'Reset Password',
      'newPassword': 'New Password',
      'enterEmailToReset':
          'Enter your email address and we\'ll send you a link to reset your password.',
      'sendResetLink': 'Send Reset Link',
      'backToLogin': 'Back to Login',
      'emailRequired': 'Email is required',
      'invalidEmail': 'Please enter a valid email address',
      'resetLinkSent': 'Reset link has been sent to your email',
      'enterTokenAndNewPassword':
          'Enter the reset token sent to your email and your new password',
      'resetToken': 'Reset Token',
      'resetTokenHint': 'Enter the code from your email',
      'resetTokenRequired': 'Reset token is required',
      'passwordRequired': 'Password is required',
      'passwordTooShort': 'Password must be at least 6 characters',
      'confirmPasswordRequired': 'Please confirm your password',
      'passwordsDoNotMatch': 'Passwords do not match',
      'passwordResetSuccess': 'Your password has been reset successfully',
      'backToStep1': 'Back to Step 1',
    },
    'zh': {
      'appName': 'FKGame',
      'login': '登录',
      'register': '注册',
      'logout': '退出登录',
      'email': '邮箱',
      'password': '密码',
      'username': '用户名',
      'phone': '手机号码',
      'confirmPassword': '确认密码',
      'rememberMe': '记住我',
      'forgotPassword': '忘记密码？',
      'noAccount': '没有账号？',
      'alreadyHaveAccount': '已有账号？',
      'or': '或者',
      'and': '和',
      'agreeToThe': '我同意',
      'termsOfService': '服务条款',
      'privacyPolicy': '隐私政策',
      'switchLanguage': '切换语言',
      'currentLanguage': '当前: 中文',

      // 首页文本
      'welcome': '欢迎',
      'games': '游戏',
      'myGames': '我的游戏',
      'popular': '热门游戏',
      'recommended': '为您推荐',
      'newGames': '新游戏',
      'seeAll': '查看全部',
      'ranking': '排行榜',
      'community': '社区',
      'settings': '设置',
      'profile': '个人资料',
      'friends': '好友',
      'messages': '消息',
      'search': '搜索游戏...',
      'home': '首页',
      'lobby': '游戏大厅',
      'social': '社交',
      'me': '我的',

      // 游戏详情页
      'howToPlay': '游戏玩法',
      'playNow': '立即开始',
      'description': '游戏介绍',
      'noDescriptionAvailable': '暂无游戏介绍。',
      'noPlayInstructionsAvailable': '暂无游戏玩法说明。',
      'gameUrlNotAvailable': '游戏链接不可用',
      'couldNotLaunchGameUrl': '无法启动游戏链接',

      // 通用按钮和提示
      'retry': '重试',

      // 搜索相关文本
      'searchGames': '搜索游戏',
      'searchHint': '输入关键词搜索游戏',
      'searchNoResults': '没有找到相关游戏',
      'searchInputPrompt': '输入关键词搜索',
      'searchGameCategories': '搜索游戏分类...',
      'noGameCategoriesFound': '没有找到相关游戏分类',
      'clearFilters': '清除过滤器',
      'allCategories': '全部',
      'gameCategory': '游戏分类',

      // 密码重置相关
      'resetPassword': '重置密码',
      'newPassword': '新密码',
      'enterEmailToReset': '请输入您的邮箱地址，我们将发送链接以重置您的密码。',
      'sendResetLink': '发送重置链接',
      'backToLogin': '返回登录',
      'emailRequired': '邮箱是必填的',
      'invalidEmail': '请输入有效的邮箱地址',
      'resetLinkSent': '重置链接已发送至您的邮箱',
      'enterTokenAndNewPassword': '输入收到的重置令牌和您的新密码',
      'resetToken': '重置令牌',
      'resetTokenHint': '输入邮箱中的代码',
      'resetTokenRequired': '重置令牌是必填的',
      'passwordRequired': '密码是必填的',
      'passwordTooShort': '密码至少需要6个字符',
      'confirmPasswordRequired': '请确认密码',
      'passwordsDoNotMatch': '两次输入的密码不一致',
      'passwordResetSuccess': '您的密码已成功重置',
      'backToStep1': '返回步骤1',
    },
  };

  // 常规文本 getter
  String get appName =>
      _localizedValues[locale.languageCode]?['appName'] ?? 'FKGame';
  String get login =>
      _localizedValues[locale.languageCode]?['login'] ?? 'Login';
  String get register =>
      _localizedValues[locale.languageCode]?['register'] ?? 'Register';
  String get logout =>
      _localizedValues[locale.languageCode]?['logout'] ?? 'Logout';
  String get email =>
      _localizedValues[locale.languageCode]?['email'] ?? 'Email';
  String get password =>
      _localizedValues[locale.languageCode]?['password'] ?? 'Password';
  String get username =>
      _localizedValues[locale.languageCode]?['username'] ?? 'Username';
  String get phone =>
      _localizedValues[locale.languageCode]?['phone'] ?? 'Phone';
  String get confirmPassword =>
      _localizedValues[locale.languageCode]?['confirmPassword'] ??
      'Confirm Password';
  String get rememberMe =>
      _localizedValues[locale.languageCode]?['rememberMe'] ?? 'Remember me';
  String get forgotPassword =>
      _localizedValues[locale.languageCode]?['forgotPassword'] ??
      'Forgot Password?';
  String get noAccount =>
      _localizedValues[locale.languageCode]?['noAccount'] ??
      'Don\'t have an account?';
  String get alreadyHaveAccount =>
      _localizedValues[locale.languageCode]?['alreadyHaveAccount'] ??
      'Already have an account?';
  String get or => _localizedValues[locale.languageCode]?['or'] ?? 'OR';
  String get and => _localizedValues[locale.languageCode]?['and'] ?? 'and';
  String get agreeToThe =>
      _localizedValues[locale.languageCode]?['agreeToThe'] ?? 'I agree to the ';
  String get termsOfService =>
      _localizedValues[locale.languageCode]?['termsOfService'] ??
      'Terms of Service';
  String get privacyPolicy =>
      _localizedValues[locale.languageCode]?['privacyPolicy'] ??
      'Privacy Policy';
  String get switchLanguage =>
      _localizedValues[locale.languageCode]?['switchLanguage'] ??
      'Switch Language';
  String get currentLanguage =>
      _localizedValues[locale.languageCode]?['currentLanguage'] ??
      'Current: English';

  // 首页文本 getter
  String get welcome =>
      _localizedValues[locale.languageCode]?['welcome'] ?? 'Welcome';
  String get games =>
      _localizedValues[locale.languageCode]?['games'] ?? 'Games';
  String get myGames =>
      _localizedValues[locale.languageCode]?['myGames'] ?? 'My Games';
  String get popular =>
      _localizedValues[locale.languageCode]?['popular'] ?? 'Popular';
  String get recommended =>
      _localizedValues[locale.languageCode]?['recommended'] ?? 'Recommended';
  String get newGames =>
      _localizedValues[locale.languageCode]?['newGames'] ?? 'New Games';
  String get seeAll =>
      _localizedValues[locale.languageCode]?['seeAll'] ?? 'See All';
  String get ranking =>
      _localizedValues[locale.languageCode]?['ranking'] ?? 'Ranking';
  String get community =>
      _localizedValues[locale.languageCode]?['community'] ?? 'Community';
  String get settings =>
      _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
  String get profile =>
      _localizedValues[locale.languageCode]?['profile'] ?? 'Profile';
  String get friends =>
      _localizedValues[locale.languageCode]?['friends'] ?? 'Friends';
  String get messages =>
      _localizedValues[locale.languageCode]?['messages'] ?? 'Messages';
  String get search =>
      _localizedValues[locale.languageCode]?['search'] ?? 'Search games...';
  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'Home';
  String get lobby =>
      _localizedValues[locale.languageCode]?['lobby'] ?? 'Lobby';
  String get social =>
      _localizedValues[locale.languageCode]?['social'] ?? 'Social';
  String get me => _localizedValues[locale.languageCode]?['me'] ?? 'Me';

  // 游戏详情页文本 getter
  String get howToPlay =>
      _localizedValues[locale.languageCode]?['howToPlay'] ?? 'How to Play';
  String get playNow =>
      _localizedValues[locale.languageCode]?['playNow'] ?? 'Play Now';
  String get description =>
      _localizedValues[locale.languageCode]?['description'] ?? 'Description';
  String get noDescriptionAvailable =>
      _localizedValues[locale.languageCode]?['noDescriptionAvailable'] ??
      'No description available for this game.';
  String get noPlayInstructionsAvailable =>
      _localizedValues[locale.languageCode]?['noPlayInstructionsAvailable'] ??
      'No play instructions available for this game.';
  String get gameUrlNotAvailable =>
      _localizedValues[locale.languageCode]?['gameUrlNotAvailable'] ??
      'Game URL not available';
  String get couldNotLaunchGameUrl =>
      _localizedValues[locale.languageCode]?['couldNotLaunchGameUrl'] ??
      'Could not launch game URL';

  // Common buttons and messages
  String get retry =>
      _localizedValues[locale.languageCode]?['retry'] ?? 'Retry';

  // Search related texts
  String get searchHint =>
      _localizedValues[locale.languageCode]?['searchHint'] ??
      'Enter keywords to search games';
  String get searchNoResults =>
      _localizedValues[locale.languageCode]?['searchNoResults'] ??
      'No games found';
  String get searchInputPrompt =>
      _localizedValues[locale.languageCode]?['searchInputPrompt'] ??
      'Enter keywords to search';
  String get searchGameCategories =>
      _localizedValues[locale.languageCode]?['searchGameCategories'] ??
      'Search game categories...';
  String get noGameCategoriesFound =>
      _localizedValues[locale.languageCode]?['noGameCategoriesFound'] ??
      'No game categories found';
  String get clearFilters =>
      _localizedValues[locale.languageCode]?['clearFilters'] ?? 'Clear filters';
  String get allCategories =>
      _localizedValues[locale.languageCode]?['allCategories'] ?? 'All';
  String get gameCategory =>
      _localizedValues[locale.languageCode]?['gameCategory'] ?? 'Game Category';

  // 表单验证相关文本
  static final Map<String, Map<String, String>> _validationMessages = {
    'en': {
      'username.required': 'Please enter your username',
      'username.tooShort': 'Username must be at least 3 characters',
      'email.required': 'Please enter your email',
      'email.invalid': 'Please enter a valid email',
      'password.required': 'Please enter your password',
      'password.tooShort': 'Password must be at least 6 characters',
      'confirmPassword.required': 'Please confirm your password',
      'confirmPassword.notMatch': 'Passwords do not match',
      'phone.invalid': 'Please enter a valid phone number',
      'terms.required': 'You must agree to the terms and conditions',
    },
    'zh': {
      'username.required': '请输入用户名',
      'username.tooShort': '用户名至少需要3个字符',
      'email.required': '请输入邮箱',
      'email.invalid': '请输入有效的邮箱地址',
      'password.required': '请输入密码',
      'password.tooShort': '密码至少需要6个字符',
      'confirmPassword.required': '请确认密码',
      'confirmPassword.notMatch': '两次输入的密码不一致',
      'phone.invalid': '请输入有效的手机号码',
      'terms.required': '您必须同意条款和条件',
    },
  };

  String validationMessage(String key) {
    final parts = key.split('.');
    if (parts.length != 2) return key;

    return _validationMessages[locale
            .languageCode]?['${parts[0]}.${parts[1]}'] ??
        _validationMessages['en']?['${parts[0]}.${parts[1]}'] ??
        key;
  }

  // 错误信息相关文本
  static final Map<String, Map<String, String>> _errorMessages = {
    'en': {
      'unknown': 'Unknown error, please try again later',
      'server': 'Server error, please try again later',
      'network.timeout':
          'Network connection timed out, please check your network',
      'network.failed': 'Network connection failed, please check your network',
      'auth.expired': 'Login expired, please login again',
      'auth.failed': 'Authentication failed, please login again',
      'auth.not_logged_in': 'Not logged in',
      'login.failed': 'Login failed, please try again later',
      'register.failed': 'Registration failed, please try again later',
      'token.refresh_failed': 'Failed to refresh token',
      'token.not_exist': 'Refresh token does not exist',
      'user.get_info_failed': 'Failed to get user information',
    },
    'zh': {
      'unknown': '未知错误，请稍后重试',
      'server': '服务器错误，请稍后重试',
      'network.timeout': '网络连接超时，请检查您的网络',
      'network.failed': '网络连接失败，请检查您的网络',
      'auth.expired': '登录已过期，请重新登录',
      'auth.failed': '认证失败，请重新登录',
      'auth.not_logged_in': '未登录',
      'login.failed': '登录失败，请稍后重试',
      'register.failed': '注册失败，请稍后重试',
      'token.refresh_failed': '刷新令牌失败',
      'token.not_exist': '刷新令牌不存在',
      'user.get_info_failed': '获取用户信息失败',
    },
  };

  String errorMessage(String key) {
    final parts = key.split('.');
    if (parts.length < 2)
      return _errorMessages[locale.languageCode]?[key] ??
          _errorMessages['en']?[key] ??
          'Unknown error';

    final mainKey = parts[0];
    final subKey = parts.sublist(1).join('.');

    return _errorMessages[locale.languageCode]?['$mainKey.$subKey'] ??
        _errorMessages['en']?['$mainKey.$subKey'] ??
        'Unknown error';
  }

  // 密码重置相关 getter
  String get resetPassword =>
      _localizedValues[locale.languageCode]?['resetPassword'] ??
      'Reset Password';
  String get newPassword =>
      _localizedValues[locale.languageCode]?['newPassword'] ?? 'New Password';
  String get enterEmailToReset =>
      _localizedValues[locale.languageCode]?['enterEmailToReset'] ??
      'Enter your email address and we\'ll send you a link to reset your password.';
  String get sendResetLink =>
      _localizedValues[locale.languageCode]?['sendResetLink'] ??
      'Send Reset Link';
  String get backToLogin =>
      _localizedValues[locale.languageCode]?['backToLogin'] ?? 'Back to Login';
  String get emailRequired =>
      _localizedValues[locale.languageCode]?['emailRequired'] ??
      'Email is required';
  String get invalidEmail =>
      _localizedValues[locale.languageCode]?['invalidEmail'] ??
      'Please enter a valid email address';
  String get resetLinkSent =>
      _localizedValues[locale.languageCode]?['resetLinkSent'] ??
      'Reset link has been sent to your email';
  String get enterTokenAndNewPassword =>
      _localizedValues[locale.languageCode]?['enterTokenAndNewPassword'] ??
      'Enter the reset token sent to your email and your new password';
  String get resetToken =>
      _localizedValues[locale.languageCode]?['resetToken'] ?? 'Reset Token';
  String get resetTokenHint =>
      _localizedValues[locale.languageCode]?['resetTokenHint'] ??
      'Enter the code from your email';
  String get resetTokenRequired =>
      _localizedValues[locale.languageCode]?['resetTokenRequired'] ??
      'Reset token is required';
  String get passwordRequired =>
      _localizedValues[locale.languageCode]?['passwordRequired'] ??
      'Password is required';
  String get passwordTooShort =>
      _localizedValues[locale.languageCode]?['passwordTooShort'] ??
      'Password must be at least 6 characters';
  String get confirmPasswordRequired =>
      _localizedValues[locale.languageCode]?['confirmPasswordRequired'] ??
      'Please confirm your password';
  String get passwordsDoNotMatch =>
      _localizedValues[locale.languageCode]?['passwordsDoNotMatch'] ??
      'Passwords do not match';
  String get passwordResetSuccess =>
      _localizedValues[locale.languageCode]?['passwordResetSuccess'] ??
      'Your password has been reset successfully';
  String get backToStep1 =>
      _localizedValues[locale.languageCode]?['backToStep1'] ?? 'Back to Step 1';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
