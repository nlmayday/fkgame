lib/
├── main.dart                     # 应用入口，初始化配置（主题、语言、路由、依赖注入）
├── app.dart                      # 根组件，配置全局设置（MaterialApp、主题、路由）
├── router.dart                   # 路由管理，使用 GoRouter 配置页面导航
├── core/                         # 核心模块，包含网络、状态管理、工具等
│   ├── network/                  # 网络通信模块，处理 REST API 和 WebSocket
│   │   ├── api/                  # REST API 请求封装（基于 Dio）
│   │   │   ├── client.dart       # Dio 实例配置，包含拦截器（认证、日志）
│   │   │   └── endpoints/        # 按功能模块划分 API
│   │   │       ├── auth/         # 认证相关 API
│   │   │       │   ├── login.dart
│   │   │       │   └── register.dart
│   │   │       ├── user/         # 用户相关 API
│   │   │       │   ├── profile.dart
│   │   │       │   └── settings.dart
│   │   │       ├── gameplay/     # 游戏相关 API
│   │   │       │   ├── lobby.dart
│   │   │       │   └── room.dart
│   │   │       └── social/       # 社交相关 API
│   │   │           ├── chat.dart
│   │   │           ├── friends.dart
│   │   │           └── messages.dart
│   │   ├── ws/                   # WebSocket 模块，处理实时通信
│   │   │   ├── client.dart       # WebSocket 客户端，包含重连、心跳检测
│   │   │   ├── channels/         # 按功能划分 WebSocket 通道
│   │   │   │   ├── chat.dart
│   │   │   │   └── game.dart
│   │   │   └── protocol/         # 消息协议定义
│   │   │       ├── message.dart  # 消息模型
│   │   │       ├── types.dart    # 消息类型枚举
│   │   │       └── codec.dart    # 消息编解码（支持 JSON、Protobuf）
│   ├── theme/                    # 主题管理
│   │   ├── app_theme.dart        # 主题配置（明暗模式、颜色、字体）
│   │   └── theme_cubit.dart      # 主题状态管理
│   ├── localization/             # 国际化管理
│   │   ├── app_localizations.dart # 国际化配置
│   │   └── locale_cubit.dart     # 语言状态管理
│   ├── constants/                # 全局常量
│   │   ├── api.dart              # API 基础 URL、超时时间
│   │   ├── routes.dart           # 路由路径常量
│   │   └── ui.dart               # UI 相关常量（尺寸、间距等）
│   ├── utils/                    # 通用工具函数
│   │   ├── format.dart           # 格式化工具（日期、货币等）
│   │   ├── logger.dart           # 日志工具
│   │   └── validators.dart       # 输入验证工具
│   ├── services/                 # 本地服务
│   │   ├── storage.dart          # 本地存储（SharedPreferences、Hive）
│   │   ├── device.dart           # 设备信息（屏幕尺寸、平台）
│   │   └── auth.dart             # 认证服务（用户信息、Token 管理）
│   └── di.dart                   # 依赖注入配置（使用 get_it）
├── common/                       # 通用 UI 组件
│   ├── widgets/                  # 基础 UI 组件
│   │   ├── buttons.dart          # 自定义按钮
│   │   ├── text_fields.dart      # 自定义输入框
│   │   ├── dialogs.dart          # 对话框
│   │   ├── loadings.dart         # 加载动画
│   │   └── toasts.dart           # Toast 提示
│   └── providers/                # 通用 Provider（非 BLoC 的轻量状态管理）
│       ├── connectivity.dart     # 网络状态
│       └── settings.dart        # 用户设置
├── features/                     # 业务功能模块
│   ├── auth/                     # 认证模块（登录、注册、注销）
│   │   ├── data/                 # 数据层
│   │   │   ├── models/           # 数据模型
│   │   │   │   ├── user.dart
│   │   │   │   └── token.dart
│   │   │   └── repository.dart   # 数据仓库（调用 API）
│   │   ├── logic/                # 状态管理
│   │   │   ├── auth_cubit.dart   # 认证状态管理
│   │   │   └── state.dart        # 状态定义
│   │   ├── pages/                # 页面
│   │   │   ├── login.dart
│   │   │   └── register.dart
│   │   └── widgets/              # UI 组件
│   │       ├── login_form.dart
│   │       └── register_form.dart
│   ├── user/                     # 用户模块（个人信息、设置、反馈）
│   │   ├── data/                 # 数据层
│   │   │   ├── models/           # 数据模型
│   │   │   │   ├── profile.dart
│   │   │   │   └── settings.dart
│   │   │   └── repository.dart   # 数据仓库
│   │   ├── logic/                # 状态管理
│   │   │   ├── user_cubit.dart   # 用户信息状态
│   │   │   ├── settings_cubit.dart # 设置状态
│   │   │   └── state.dart        # 状态定义
│   │   ├── pages/                # 页面
│   │   │   ├── profile.dart      # 个人信息
│   │   │   ├── settings.dart     # 设置（语言、音效）
│   │   │   └── feedback.dart     # 反馈
│   │   └── widgets/              # UI 组件
│   │       ├── profile_card.dart
│   │       └── settings_form.dart
│   ├── gameplay/                 # 游戏相关模块（大厅、房间）
│   │   ├── lobby/                # 游戏大厅
│   │   │   ├── data/             # 数据层
│   │   │   │   ├── models/       # 数据模型
│   │   │   │   │   └── room.dart
│   │   │   │   └── repository.dart
│   │   │   ├── logic/            # 状态管理
│   │   │   │   ├── lobby_cubit.dart
│   │   │   │   └── state.dart
│   │   │   ├── pages/            # 页面
│   │   │   │   └── lobby.dart
│   │   │   └── widgets/          # UI 组件
│   │   │       └── room_card.dart
│   │   └── game/                 # 游戏房间
│   │       ├── data/             # 数据层
│   │       │   ├── models/       # 数据模型
│   │       │   │   ├── game.dart
│   │       │   │   └── player.dart
│   │       │   └── repository.dart
│   │       ├── logic/            # 状态管理
│   │       │   ├── game_cubit.dart
│   │       │   └── state.dart
│   │       ├── pages/            # 页面
│   │       │   └── game.dart
│   │       └── widgets/          # UI 组件
│   │           ├── game_board.dart
│   │           └── player_list.dart
│   ├── social/                   # 社交相关模块（聊天、好友、消息）
│   │   ├── chat/                 # 聊天模块
│   │   │   ├── data/             # 数据层
│   │   │   │   ├── models/       # 数据模型
│   │   │   │   │   ├── message.dart
│   │   │   │   │   └── chat.dart
│   │   │   │   └── repository.dart
│   │   │   ├── logic/            # 状态管理
│   │   │   │   ├── chat_cubit.dart
│   │   │   │   └── state.dart
│   │   │   ├── pages/            # 页面
│   │   │   │   └── chat.dart
│   │   │   └── widgets/          # UI 组件
│   │   │       ├── message_list.dart
│   │   │       └── input_bar.dart
│   │   ├── friends/              # 好友模块
│   │   │   ├── data/             # 数据层
│   │   │   │   ├── models/       # 数据模型
│   │   │   │   │   └── friend.dart
│   │   │   │   └── repository.dart
│   │   │   ├── logic/            # 状态管理
│   │   │   │   ├── friends_cubit.dart
│   │   │   │   └── state.dart
│   │   │   ├── pages/            # 页面
│   │   │   │   └── friends.dart
│   │   │   └── widgets/          # UI 组件
│   │   │       └── friend_card.dart
│   │   └── messages/             # 消息通知模块
│   │       ├── data/             # 数据层
│   │       │   ├── models/       # 数据模型
│   │       │   │   └── notification.dart
│   │       │   └── repository.dart
│   │       ├── logic/            # 状态管理
│   │       │   ├── messages_cubit.dart
│   │       │   └── state.dart
│   │       ├── pages/            # 页面
│   │       │   └── messages.dart
│   │       └── widgets/          # UI 组件
│   │           └── notification_card.dart
├── l10n/                         # 国际化资源
│   ├── intl_en.arb               # 英文翻译
│   ├── intl_zh.arb               # 中文翻译
│   └── app_localizations.dart    # 国际化生成文件
└── test/                         # 测试目录
    ├── core/                     # 核心模块测试
    │   ├── network/
    │   ├── theme/
    │   └── utils/
    ├── common/                   # 通用组件测试
    │   ├── widgets/
    │   └── providers/
    └── features/                 # 功能模块测试
        ├── auth/
        ├── user/
        ├── gameplay/
        └── social/# fkgame
