import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/l10n/app_localizations.dart';

/// 带有登出功能的自定义AppBar
class AppBarWithLogout extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;
  final bool automaticallyImplyLeading;
  final Widget? leading;

  const AppBarWithLogout({
    Key? key,
    required this.title,
    this.additionalActions,
    this.automaticallyImplyLeading = true,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: [
        if (additionalActions != null) ...additionalActions!,
        // 登出按钮
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: localizations.logout,
          onPressed: () {
            // 显示确认对话框
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text(localizations.logout),
                  content: Text('确定要退出登录吗？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        // 关闭对话框
                        Navigator.of(dialogContext).pop();
                        // 执行登出
                        context.read<AuthCubit>().logout();
                        // 导航到登录页
                        context.go('/login');
                      },
                      child: Text(
                        localizations.logout,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
