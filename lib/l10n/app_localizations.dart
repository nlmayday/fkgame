import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

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

      // 金币变动记录相关
      'coinHistory': 'Coin History',
      'coinStatistics': 'Coin Statistics',
      'totalIncome': 'Total Income',
      'totalExpense': 'Total Expense',
      'netChange': 'Net Change',
      'coinRecords': 'Records',
      'noTransactionRecords': 'No transaction records',
      'transactionDetails': 'Transaction Details',
      'transactionType': 'Transaction Type',
      'transactionAmount': 'Amount',
      'transactionTime': 'Transaction Time',
      'coinsBefore': 'Coins Before',
      'coinsAfter': 'Coins After',
      'filterCoinRecords': 'Filter Coin Records',
      'filterByTime': 'Filter by Time',
      'sortByAmount': 'Sort by Amount',
      'advancedSearch': 'Advanced Search',
      'all': 'All',
      'income': 'Income',
      'expense': 'Expense',
      'game': 'Game',
      'recharge': 'Recharge',
      'reward': 'Reward',
      'purchase': 'Purchase',
      'today': 'Today',
      'yesterday': 'Yesterday',

      // 交易类型
      'transactionTypeGameWin': 'Game Victory',
      'transactionTypeGameLose': 'Game Defeat',
      'transactionTypeRecharge': 'Recharge',
      'transactionTypeDailyReward': 'Daily Reward',
      'transactionTypeAchievement': 'Achievement',
      'transactionTypeGift': 'Gift',
      'transactionTypePurchase': 'Purchase',

      // 个人资料页相关
      'editProfile': 'Edit Profile',
      'userStats': 'User Stats',
      'playedGames': 'Played Games',
      'favorites': 'Favorites',
      'achievements': 'Achievements',
      'statistics': 'Statistics',
      'level': 'LV.',
      'exp': 'EXP',
      'gamePoints': 'Game Points',
      'recharge': 'Recharge',
      'functionMenu': 'Functions',
      'gameRecords': 'Game Records',
      'myFavorites': 'My Favorites',
      'myWallet': 'My Wallet',
      'achievementCenter': 'Achievement Center',
      'friendsList': 'Friends List',
      'helpAndFeedback': 'Help & Feedback',
      'gameHistory': 'Game History',
      'recentlyPlayed': 'Recently Played',
      'lastPlayed': 'Last played',
      'viewAll': 'View All',
      'noData': 'No data available',
      'retry': 'Retry',
      'cannotLoadUserData': 'Unable to load user data',
      'hoursAgo': 'hours ago',
      'hours': 'hours',
      'shareResults': 'Share Results',
      'close': 'Close',

      // 钱包和充值
      'currentBalance': 'Current Balance',
      'rechargeOptions': 'Recharge Options',
      'selectPaymentMethod': 'Select Payment Method',
      'popular': 'Popular',
      'bonus': 'Bonus',
      'confirmRecharge': 'Confirm Recharge',
      'rechargeFee': 'Fee',
      'totalAmount': 'Total Amount',
      'paymentMethod': 'Payment Method',
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'processingPayment': 'Processing payment...',
      'rechargePlaceholder':
          'Payment feature will be available in future updates',

      // 修改资料
      'editUserProfile': 'Edit User Profile',
      'changeAvatar': 'Change Avatar',
      'chooseFromStandard': 'Choose from standard avatars',
      'takePhoto': 'Take a photo',
      'chooseFromGallery': 'Choose from gallery',
      'save': 'Save',
      'updateSuccessful': 'Update successful',

      // 各种提示和功能占位符
      'comingSoon': 'Coming soon in future updates',
      'settingsFeature': 'Settings feature will be available in future updates',
      'editProfileFeature':
          'Edit profile feature will be available in future updates',
      'gameHistoryFeature':
          'Game history feature will be available in future updates',
      'favoritesFeature':
          'Favorites feature will be available in future updates',
      'walletFeature': 'Wallet feature will be available in future updates',
      'achievementFeature':
          'Achievement feature will be available in future updates',
      'friendsFeature':
          'Friends list feature will be available in future updates',
      'helpFeature':
          'Help and feedback feature will be available in future updates',
      'gameDetails': 'Game details',
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

      // 金币变动记录相关
      'coinHistory': '金币变动记录',
      'coinStatistics': '金币统计',
      'totalIncome': '总收入',
      'totalExpense': '总支出',
      'netChange': '净变化',
      'coinRecords': '记录',
      'noTransactionRecords': '暂无交易记录',
      'transactionDetails': '交易详情',
      'transactionType': '交易类型',
      'transactionAmount': '变动金额',
      'transactionTime': '交易时间',
      'coinsBefore': '变动前金币',
      'coinsAfter': '变动后金币',
      'filterCoinRecords': '筛选金币记录',
      'filterByTime': '按时间筛选',
      'sortByAmount': '按金额排序',
      'advancedSearch': '高级搜索',
      'all': '全部',
      'income': '收入',
      'expense': '支出',
      'game': '游戏',
      'recharge': '充值',
      'reward': '奖励',
      'purchase': '购买',
      'today': '今天',
      'yesterday': '昨天',

      // 交易类型
      'transactionTypeGameWin': '游戏胜利',
      'transactionTypeGameLose': '游戏失败',
      'transactionTypeRecharge': '金币充值',
      'transactionTypeDailyReward': '每日奖励',
      'transactionTypeAchievement': '成就奖励',
      'transactionTypeGift': '系统赠送',
      'transactionTypePurchase': '道具购买',

      // 个人资料页相关
      'editProfile': '编辑资料',
      'userStats': '用户数据',
      'playedGames': '已玩游戏',
      'favorites': '收藏',
      'achievements': '成就',
      'statistics': '统计',
      'level': 'LV.',
      'exp': '经验值',
      'gamePoints': '游戏点',
      'recharge': '充值',
      'functionMenu': '功能',
      'gameRecords': '游戏记录',
      'myFavorites': '我的收藏',
      'myWallet': '我的钱包',
      'achievementCenter': '成就中心',
      'friendsList': '好友列表',
      'helpAndFeedback': '帮助与反馈',
      'gameHistory': '游戏历史',
      'recentlyPlayed': '最近玩过',
      'lastPlayed': '上次游玩',
      'viewAll': '查看全部',
      'noData': '暂无数据',
      'retry': '重试',
      'cannotLoadUserData': '无法加载用户数据',
      'hoursAgo': '小时前',
      'hours': '小时',
      'shareResults': '分享战绩',
      'close': '关闭',

      // 钱包和充值
      'currentBalance': '当前余额',
      'rechargeOptions': '充值游戏点',
      'selectPaymentMethod': '选择支付方式',
      'popular': '推荐',
      'bonus': '赠送',
      'confirmRecharge': '确认充值',
      'rechargeFee': '手续费',
      'totalAmount': '总计',
      'paymentMethod': '支付方式',
      'confirm': '确认',
      'cancel': '取消',
      'processingPayment': '正在跳转至支付平台...',
      'rechargePlaceholder': '充值功能将在后续版本推出',

      // 修改资料
      'editUserProfile': '编辑用户资料',
      'changeAvatar': '修改头像',
      'chooseFromStandard': '选择标准头像',
      'takePhoto': '拍照',
      'chooseFromGallery': '从相册选择',
      'save': '保存',
      'updateSuccessful': '更新成功',

      // 各种提示和功能占位符
      'comingSoon': '即将在后续版本推出',
      'settingsFeature': '设置页面将在后续版本推出',
      'editProfileFeature': '编辑个人资料功能将在后续版本推出',
      'gameHistoryFeature': '游戏历史功能将在后续版本推出',
      'favoritesFeature': '我的收藏功能将在后续版本推出',
      'walletFeature': '钱包功能将在后续版本推出',
      'achievementFeature': '成就中心功能将在后续版本推出',
      'friendsFeature': '好友列表功能将在后续版本推出',
      'helpFeature': '帮助与反馈功能将在后续版本推出',
      'gameDetails': '游戏详情',
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

  // Add new getters for coin history related texts
  String get coinHistory =>
      _localizedValues[locale.languageCode]?['coinHistory'] ?? 'Coin History';
  String get coinStatistics =>
      _localizedValues[locale.languageCode]?['coinStatistics'] ??
      'Coin Statistics';
  String get totalIncome =>
      _localizedValues[locale.languageCode]?['totalIncome'] ?? 'Total Income';
  String get totalExpense =>
      _localizedValues[locale.languageCode]?['totalExpense'] ?? 'Total Expense';
  String get netChange =>
      _localizedValues[locale.languageCode]?['netChange'] ?? 'Net Change';
  String get coinRecords =>
      _localizedValues[locale.languageCode]?['coinRecords'] ?? 'Records';
  String get noTransactionRecords =>
      _localizedValues[locale.languageCode]?['noTransactionRecords'] ??
      'No transaction records';
  String get transactionDetails =>
      _localizedValues[locale.languageCode]?['transactionDetails'] ??
      'Transaction Details';
  String get transactionType =>
      _localizedValues[locale.languageCode]?['transactionType'] ??
      'Transaction Type';
  String get transactionAmount =>
      _localizedValues[locale.languageCode]?['transactionAmount'] ?? 'Amount';
  String get transactionTime =>
      _localizedValues[locale.languageCode]?['transactionTime'] ??
      'Transaction Time';
  String get coinsBefore =>
      _localizedValues[locale.languageCode]?['coinsBefore'] ?? 'Coins Before';
  String get coinsAfter =>
      _localizedValues[locale.languageCode]?['coinsAfter'] ?? 'Coins After';
  String get filterCoinRecords =>
      _localizedValues[locale.languageCode]?['filterCoinRecords'] ??
      'Filter Coin Records';
  String get filterByTime =>
      _localizedValues[locale.languageCode]?['filterByTime'] ??
      'Filter by Time';
  String get sortByAmount =>
      _localizedValues[locale.languageCode]?['sortByAmount'] ??
      'Sort by Amount';
  String get advancedSearch =>
      _localizedValues[locale.languageCode]?['advancedSearch'] ??
      'Advanced Search';
  String get all => _localizedValues[locale.languageCode]?['all'] ?? 'All';
  String get income =>
      _localizedValues[locale.languageCode]?['income'] ?? 'Income';
  String get expense =>
      _localizedValues[locale.languageCode]?['expense'] ?? 'Expense';
  String get game => _localizedValues[locale.languageCode]?['game'] ?? 'Game';
  String get recharge =>
      _localizedValues[locale.languageCode]?['recharge'] ?? 'Recharge';
  String get reward =>
      _localizedValues[locale.languageCode]?['reward'] ?? 'Reward';
  String get purchase =>
      _localizedValues[locale.languageCode]?['purchase'] ?? 'Purchase';
  String get today =>
      _localizedValues[locale.languageCode]?['today'] ?? 'Today';
  String get yesterday =>
      _localizedValues[locale.languageCode]?['yesterday'] ?? 'Yesterday';

  // Helper for transaction type localization
  String getTransactionTypeName(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // 添加个人资料页相关的getter
  String get editProfile =>
      _localizedValues[locale.languageCode]?['editProfile'] ?? 'Edit Profile';
  String get userStats =>
      _localizedValues[locale.languageCode]?['userStats'] ?? 'User Stats';
  String get playedGames =>
      _localizedValues[locale.languageCode]?['playedGames'] ?? 'Played Games';
  String get favorites =>
      _localizedValues[locale.languageCode]?['favorites'] ?? 'Favorites';
  String get achievements =>
      _localizedValues[locale.languageCode]?['achievements'] ?? 'Achievements';
  String get statistics =>
      _localizedValues[locale.languageCode]?['statistics'] ?? 'Statistics';
  String get level => _localizedValues[locale.languageCode]?['level'] ?? 'LV.';
  String get exp => _localizedValues[locale.languageCode]?['exp'] ?? 'EXP';
  String get gamePoints =>
      _localizedValues[locale.languageCode]?['gamePoints'] ?? 'Game Points';
  String get recharge =>
      _localizedValues[locale.languageCode]?['recharge'] ?? 'Recharge';
  String get functionMenu =>
      _localizedValues[locale.languageCode]?['functionMenu'] ?? 'Functions';
  String get gameRecords =>
      _localizedValues[locale.languageCode]?['gameRecords'] ?? 'Game Records';
  String get myFavorites =>
      _localizedValues[locale.languageCode]?['myFavorites'] ?? 'My Favorites';
  String get myWallet =>
      _localizedValues[locale.languageCode]?['myWallet'] ?? 'My Wallet';
  String get achievementCenter =>
      _localizedValues[locale.languageCode]?['achievementCenter'] ??
      'Achievement Center';
  String get friendsList =>
      _localizedValues[locale.languageCode]?['friendsList'] ?? 'Friends List';
  String get helpAndFeedback =>
      _localizedValues[locale.languageCode]?['helpAndFeedback'] ??
      'Help & Feedback';
  String get gameHistory =>
      _localizedValues[locale.languageCode]?['gameHistory'] ?? 'Game History';
  String get recentlyPlayed =>
      _localizedValues[locale.languageCode]?['recentlyPlayed'] ??
      'Recently Played';
  String get lastPlayed =>
      _localizedValues[locale.languageCode]?['lastPlayed'] ?? 'Last played';
  String get viewAll =>
      _localizedValues[locale.languageCode]?['viewAll'] ?? 'View All';
  String get noData =>
      _localizedValues[locale.languageCode]?['noData'] ?? 'No data available';
  String get cannotLoadUserData =>
      _localizedValues[locale.languageCode]?['cannotLoadUserData'] ??
      'Unable to load user data';
  String get hoursAgo =>
      _localizedValues[locale.languageCode]?['hoursAgo'] ?? 'hours ago';
  String get hours =>
      _localizedValues[locale.languageCode]?['hours'] ?? 'hours';
  String get shareResults =>
      _localizedValues[locale.languageCode]?['shareResults'] ?? 'Share Results';
  String get close =>
      _localizedValues[locale.languageCode]?['close'] ?? 'Close';

  // 钱包和充值相关的getter
  String get currentBalance =>
      _localizedValues[locale.languageCode]?['currentBalance'] ??
      'Current Balance';
  String get rechargeOptions =>
      _localizedValues[locale.languageCode]?['rechargeOptions'] ??
      'Recharge Options';
  String get selectPaymentMethod =>
      _localizedValues[locale.languageCode]?['selectPaymentMethod'] ??
      'Select Payment Method';
  String get bonus =>
      _localizedValues[locale.languageCode]?['bonus'] ?? 'Bonus';
  String get confirmRecharge =>
      _localizedValues[locale.languageCode]?['confirmRecharge'] ??
      'Confirm Recharge';
  String get rechargeFee =>
      _localizedValues[locale.languageCode]?['rechargeFee'] ?? 'Fee';
  String get totalAmount =>
      _localizedValues[locale.languageCode]?['totalAmount'] ?? 'Total Amount';
  String get paymentMethod =>
      _localizedValues[locale.languageCode]?['paymentMethod'] ??
      'Payment Method';
  String get confirm =>
      _localizedValues[locale.languageCode]?['confirm'] ?? 'Confirm';
  String get cancel =>
      _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get processingPayment =>
      _localizedValues[locale.languageCode]?['processingPayment'] ??
      'Processing payment...';

  // 修改资料相关的getter
  String get editUserProfile =>
      _localizedValues[locale.languageCode]?['editUserProfile'] ??
      'Edit User Profile';
  String get changeAvatar =>
      _localizedValues[locale.languageCode]?['changeAvatar'] ?? 'Change Avatar';
  String get chooseFromStandard =>
      _localizedValues[locale.languageCode]?['chooseFromStandard'] ??
      'Choose from standard avatars';
  String get takePhoto =>
      _localizedValues[locale.languageCode]?['takePhoto'] ?? 'Take a photo';
  String get chooseFromGallery =>
      _localizedValues[locale.languageCode]?['chooseFromGallery'] ??
      'Choose from gallery';
  String get save => _localizedValues[locale.languageCode]?['save'] ?? 'Save';
  String get updateSuccessful =>
      _localizedValues[locale.languageCode]?['updateSuccessful'] ??
      'Update successful';

  // 功能占位符相关的getter
  String get comingSoon =>
      _localizedValues[locale.languageCode]?['comingSoon'] ??
      'Coming soon in future updates';
  String get settingsFeature =>
      _localizedValues[locale.languageCode]?['settingsFeature'] ??
      'Settings feature will be available in future updates';
  String get editProfileFeature =>
      _localizedValues[locale.languageCode]?['editProfileFeature'] ??
      'Edit profile feature will be available in future updates';
  String get gameHistoryFeature =>
      _localizedValues[locale.languageCode]?['gameHistoryFeature'] ??
      'Game history feature will be available in future updates';
  String get favoritesFeature =>
      _localizedValues[locale.languageCode]?['favoritesFeature'] ??
      'Favorites feature will be available in future updates';
  String get walletFeature =>
      _localizedValues[locale.languageCode]?['walletFeature'] ??
      'Wallet feature will be available in future updates';
  String get achievementFeature =>
      _localizedValues[locale.languageCode]?['achievementFeature'] ??
      'Achievement feature will be available in future updates';
  String get friendsFeature =>
      _localizedValues[locale.languageCode]?['friendsFeature'] ??
      'Friends list feature will be available in future updates';
  String get helpFeature =>
      _localizedValues[locale.languageCode]?['helpFeature'] ??
      'Help and feedback feature will be available in future updates';
  String get gameDetails =>
      _localizedValues[locale.languageCode]?['gameDetails'] ?? 'Game details';
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
