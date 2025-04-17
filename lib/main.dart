import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di.dart';
import 'core/services/log.dart';
import 'features/auth/logic/auth_cubit.dart';
import 'features/home/logic/home_bloc.dart';

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
  await setupDependencies();

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
