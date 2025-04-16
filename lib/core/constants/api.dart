/// API相关常量定义
class ApiConstants {
  // 基础URL
  static const String baseUrl = 'https://api.fkgame.com/v1';

  // WebSocket URL
  static const String wsUrl = 'wss://api.fkgame.com/ws';

  // 超时设置（毫秒）
  static const int connectionTimeout = 15000; // 连接超时
  static const int receiveTimeout = 15000; // 接收超时
  static const int sendTimeout = 15000; // 发送超时

  // WebSocket相关配置
  static const int wsReconnectDelay = 3000; // 重连延迟（毫秒）
  static const int wsHeartbeatInterval = 30000; // 心跳间隔（毫秒）

  // 端点路径
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String userProfileEndpoint = '/user/profile';
  static const String roomsEndpoint = '/gameplay/rooms';
  static const String friendsEndpoint = '/social/friends';
  static const String messagesEndpoint = '/social/messages';
}
