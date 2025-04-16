import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/localization/locale_cubit.dart';
import 'features/auth/logic/auth_cubit.dart'; // 添加认证Cubit
import 'l10n/app_localizations.dart'; // 更新导入
// import 'l10n/app_localizations.dart'; // Will be implemented later
import 'router.dart';

/// 应用根组件
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 全局状态提供者
        BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()),
        BlocProvider<LocaleCubit>(create: (_) => getIt<LocaleCubit>()),
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
      ],
      child: _buildMaterialApp(),
    );
  }

  /// 构建MaterialApp
  Widget _buildMaterialApp() {
    return Builder(
      builder: (context) {
        // 监听主题变化
        final themeState = context.watch<ThemeCubit>().state;

        // 监听语言变化
        final localeState = context.watch<LocaleCubit>().state;

        // 获取路由配置
        final router = AppRouter.router;

        return MaterialApp.router(
          title: 'FKGame',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.mode,

          // 国际化配置
          locale: localeState.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate, // 添加我们自己的Delegate
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // 英语
            Locale('zh'), // 中文
          ],

          // 路由配置
          routerConfig: router,
        );
      },
    );
  }
}
