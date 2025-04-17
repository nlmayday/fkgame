import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/l10n/app_localizations.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/core/widgets/app_bar_with_logout.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // 确认用户是否已登录，如果未登录重定向到登录页面
    final authState = context.watch<AuthCubit>().state;
    if (!authState.isAuthenticated) {
      // 自动导航到登录页面
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      // 显示加载中的界面
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 使用真实用户数据
    final user = authState.user;

    // 模拟用户的游戏统计数据
    final Map<String, dynamic> userStats = {
      'playedGames': 126,
      'favorites': 45,
      'friends': 68,
      'achievements': 24,
    };

    return Scaffold(
      appBar: AppBarWithLogout(
        title: localizations.profile,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 打开设置
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // 编辑个人资料
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context, user),
            _buildStatsSection(context, userStats),
            _buildMenuSection(context),
            _buildRecentGames(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              user?.avatarUrl ?? 'https://picsum.photos/200/200?random=123',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user?.username ?? "游戏玩家",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'LV.${user?.level ?? 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (user?.exp ?? 0) / 1000, // 假设每级1000经验
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 4),
                Text(
                  'EXP: ${user?.exp ?? 0}/1000',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('${user?.gamePoint ?? 0}'),
                    const SizedBox(width: 16),
                    Icon(Icons.diamond, color: Colors.purple, size: 16),
                    const SizedBox(width: 4),
                    Text('0'), // 假设钻石数量
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Map<String, dynamic> stats) {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('我的统计', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                Icons.videogame_asset,
                '${stats['playedGames']}',
                '已玩游戏',
              ),
              _buildStatItem(
                context,
                Icons.favorite,
                '${stats['favorites']}',
                '收藏',
              ),
              _buildStatItem(
                context,
                Icons.people,
                '${stats['friends']}',
                '好友',
              ),
              _buildStatItem(
                context,
                Icons.emoji_events,
                '${stats['achievements']}',
                '成就',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.history, '游戏历史', () {
            // 打开游戏历史
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.favorite, '我的收藏', () {
            // 打开收藏
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.wallet, '我的钱包', () {
            // 打开钱包
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.emoji_events, '成就中心', () {
            // 打开成就中心
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.help, '帮助与反馈', () {
            // 打开帮助与反馈
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.logout, localizations.logout, () {
            // 登出
            context.read<AuthCubit>().logout();
            context.go('/login');
          }, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).primaryColor),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildRecentGames(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('最近玩过', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://picsum.photos/200/300?random=${index + 30}',
                          height: 120,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '游戏 ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '上次游玩: 2小时前',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
