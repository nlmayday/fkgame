import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fkgame/core/network/api/client.dart';
import 'package:fkgame/core/network/ws/client.dart';
import 'package:fkgame/core/services/storage.dart';
import 'package:fkgame/core/services/auth.dart';
import 'package:fkgame/core/services/log.dart';
import 'package:fkgame/core/constants/api.dart';
import 'package:fkgame/core/theme/theme_cubit.dart';
import 'package:fkgame/core/localization/locale_cubit.dart';

// 认证模块导入
import 'package:fkgame/features/auth/data/repository/auth_repository_impl.dart';
import 'package:fkgame/features/auth/domain/repositories/auth_repository.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';

// Feature imports - commented out until implemented
// import '../features/user/data/repository.dart';
// import '../features/user/logic/user_cubit.dart';
// import '../features/gameplay/lobby/data/repository.dart';
// import '../features/gameplay/lobby/logic/lobby_cubit.dart';
// import '../features/gameplay/game/data/repository.dart';
// import '../features/gameplay/game/logic/game_cubit.dart';
// import '../features/social/chat/data/repository.dart';
// import '../features/social/chat/logic/chat_cubit.dart';
// import '../features/social/friends/data/repository.dart';
// import '../features/social/friends/logic/friends_cubit.dart';
// import '../features/social/messages/data/repository.dart';
// import '../features/social/messages/logic/messages_cubit.dart';

/// 全局依赖注入服务定位器
final GetIt getIt = GetIt.instance;

/// 初始化所有依赖
Future<void> setupDependencies() async {
  // 初始化SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();

  // 核心服务
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);
  getIt.registerSingleton<LogService>(LogService());

  // 网络客户端
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<WebSocketClient>(
    () => WebSocketClient(url: ApiConstants.wsUrl),
  );

  // 本地服务
  getIt.registerLazySingleton<StorageService>(
    () => SharedPrefsService(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(getIt<StorageService>()),
  );

  // 核心功能
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt<StorageService>()));
  getIt.registerFactory<LocaleCubit>(
    () => LocaleCubit(getIt<StorageService>()),
  );

  // 数据仓库
  _registerRepositories();

  // Cubits/Blocs
  _registerCubits();
}

/// 注册所有数据仓库
void _registerRepositories() {
  // 认证
  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(getIt<ApiClient>(), getIt<StorageService>()),
  );

  // 其他仓库 - 暂时注释
  /*
  // 用户
  getIt.registerFactory<UserRepository>(() => UserRepositoryImpl(
    getIt<ApiClient>(),
  ));
  
  // 游戏功能
  getIt.registerFactory<LobbyRepository>(() => LobbyRepositoryImpl(
    getIt<ApiClient>(),
  ));
  getIt.registerFactory<GameRepository>(() => GameRepositoryImpl(
    getIt<ApiClient>(),
    getIt<WebSocketClient>(),
  ));
  
  // 社交功能
  getIt.registerFactory<ChatRepository>(() => ChatRepositoryImpl(
    getIt<ApiClient>(),
    getIt<WebSocketClient>(),
  ));
  getIt.registerFactory<FriendsRepository>(() => FriendsRepositoryImpl(
    getIt<ApiClient>(),
  ));
  getIt.registerFactory<MessagesRepository>(() => MessagesRepositoryImpl(
    getIt<ApiClient>(),
  ));
  */
}

/// 注册所有Cubits
void _registerCubits() {
  // 认证功能
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<AuthRepository>(),
      getIt<AuthService>(),
      getIt<StorageService>(),
    ),
  );

  // 其他功能 - 暂时注释
  /*
  // 用户功能
  getIt.registerFactory<UserCubit>(() => UserCubit(getIt<UserRepository>()));
  
  // 游戏功能
  getIt.registerFactory<LobbyCubit>(() => LobbyCubit(getIt<LobbyRepository>()));
  
  // 社交功能
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt<ChatRepository>()));
  getIt.registerFactory<FriendsCubit>(() => FriendsCubit(getIt<FriendsRepository>()));
  getIt.registerFactory<MessagesCubit>(() => MessagesCubit(getIt<MessagesRepository>()));
  
  // 游戏Cubit使用工厂参数模式，确保每个游戏实例有自己的Cubit
  getIt.registerFactoryParam<GameCubit, String, void>(
    (gameId, _) => GameCubit(getIt<GameRepository>(), gameId),
  );
  */
}
