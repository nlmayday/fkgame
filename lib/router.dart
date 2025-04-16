import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fkgame/core/constants/routes.dart';
import 'package:fkgame/features/auth/pages/login_page.dart';
import 'package:fkgame/features/auth/pages/register_page.dart';

/// 路由管理器
class AppRouter {
  /// 全局路由实例
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    routes: [
      // 初始页面
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const HomePage(),
      ),
      // 登录页面
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginPage(),
      ),
      // 注册页面
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      // 首页
      GoRoute(path: Routes.home, builder: (context, state) => const HomePage()),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
}

/// 临时首页
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FKGame')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to FKGame', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go(Routes.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 错误页面
class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('页面不存在')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('页面不存在或发生错误', style: TextStyle(fontSize: 18)),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                '错误详情: $error',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go(Routes.splash),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}
