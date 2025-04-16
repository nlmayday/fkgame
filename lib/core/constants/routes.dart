/// 应用路由常量定义
class Routes {
  // 初始页面
  static const String splash = '/'; // 闪屏页

  // 认证相关
  static const String login = '/login'; // 登录页
  static const String register = '/register'; // 注册页
  static const String forgotPassword = '/forgot-password';

  // 主要页面
  static const String home = '/home';
  static const String profile = '/profile'; // 个人资料
  static const String settings = '/settings'; // 设置

  // 游戏相关
  static const String lobby = '/lobby'; // 游戏大厅
  static const String gameRoom = '/game/:id'; // 游戏房间（使用时: '/game/123'）

  // 社交相关
  static const String friends = '/friends'; // 好友列表
  static const String chat = '/chat/:id'; // 聊天（使用时: '/chat/123'）
  static const String messages = '/messages'; // 消息通知
}
