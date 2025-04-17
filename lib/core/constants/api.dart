/// API相关常量
class ApiConstants {
  // 禁止实例化
  ApiConstants._();

  /// Base URLs
  static const String baseUrl = 'https://madlygame.com/api';
  static const String wsUrl = 'wss://madlygame.com/ws';

  /// API Endpoints
  // 首页
  static const String categoryList = '/fgIndex/category/list';
  static const String banner = '/fgIndex/banner';
  static const String gameList = '/fgIndex/game/list';

  // 认证相关接口
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String getUser = '/auth/me';

  // 用户相关接口
  static const String getUserProfile = '/user/profile';
  static const String updateUserProfile = '/user/profile';
  static const String uploadAvatar = '/user/avatar';

  // 其他配置常量
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int sendTimeout = 15000;

  // WebSocket相关配置
  static const int wsReconnectDelay = 3000; // 重连延迟（毫秒）
  static const int wsHeartbeatInterval = 30000; // 心跳间隔（毫秒）

  // 端点路径
  static const String roomsEndpoint = '/gameplay/rooms';
  static const String friendsEndpoint = '/social/friends';
  static const String messagesEndpoint = '/social/messages';
}
