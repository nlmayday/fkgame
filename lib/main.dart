import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:fkgame/router.dart';
import 'package:fkgame/core/theme/app_theme.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/l10n/app_localizations.dart';
import 'package:fkgame/core/repositories/game_repository.dart';
import 'package:fkgame/features/home/logic/home_bloc.dart';
import 'package:fkgame/features/home/data/repository/home_repository.dart';
import 'package:fkgame/core/network/api/client.dart';
import 'package:fkgame/core/services/log.dart';
import 'package:fkgame/core/services/auth.dart';
import 'package:fkgame/core/services/storage.dart';
import 'package:fkgame/features/auth/domain/repositories/auth_repository.dart';
import 'package:fkgame/features/auth/data/repository/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fkgame/core/localization/locale_cubit.dart';

final GetIt getIt = GetIt.instance;

// 应用主入口
Future<void> main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 设置设备方向为竖屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 初始化依赖注入
  _setupDependencies();

  // 注册Bloc观察器
  Bloc.observer = AppBlocObserver();

  // 配置全局错误处理
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    getIt<LogService>().logError(details.exception, details.stack);
  };

  // 启动应用并捕获全局异常
  runZonedGuarded(
    () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
          BlocProvider<HomeBloc>(create: (context) => getIt<HomeBloc>()),
          BlocProvider<LocaleCubit>(create: (context) => getIt<LocaleCubit>()),
        ],
        child: const MyApp(),
      ),
    ),
    (error, stackTrace) {
      developer.log('🔴 全局错误:', error: error, stackTrace: stackTrace);
      getIt<LogService>().logError(error, stackTrace);
    },
  );
}

void _setupDependencies() {
  // 注册服务
  getIt.registerLazySingleton<LogService>(() => LogService());

  // 注册API客户端
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // 注册存储服务
  SharedPreferences.getInstance().then((prefs) {
    getIt.registerLazySingleton<StorageService>(
      () => SharedPrefsService(prefs),
    );

    // 在存储服务注册后注册LocaleCubit
    getIt.registerFactory<LocaleCubit>(
      () => LocaleCubit(getIt<StorageService>()),
    );

    // 在存储服务注册后注册认证服务
    getIt.registerLazySingleton<AuthService>(
      () => AuthServiceImpl(getIt<StorageService>()),
    );

    // 在认证服务注册后注册认证仓库
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<ApiClient>(), getIt<StorageService>()),
    );

    // 最后注册AuthCubit
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        getIt<AuthRepository>(),
        getIt<AuthService>(),
        getIt<StorageService>(),
      ),
    );
  });

  // 注册仓库
  getIt.registerLazySingleton<GameRepository>(() => GameRepository());
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<ApiClient>()),
  );

  // 注册Bloc
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getIt<HomeRepository>(), getIt<GameRepository>()),
  );
}

// Bloc观察器，用于调试状态管理
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    developer.log('🟢 创建: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    developer.log(
      '📦 ${bloc.runtimeType} 状态变化: \n前: ${change.currentState}\n后: ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    developer.log('🔴 ${bloc.runtimeType} 错误: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    developer.log('🔵 关闭: ${bloc.runtimeType}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return MaterialApp.router(
          title: 'FK Game',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          routerConfig: AppRouter.router,
          locale: localeState.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', ''), Locale('zh', '')],
        );
      },
    );
  }
}
