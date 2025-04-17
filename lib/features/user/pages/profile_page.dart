import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/l10n/app_localizations.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/core/widgets/app_bar_with_logout.dart';
import 'package:go_router/go_router.dart';
import 'package:fkgame/features/home/logic/home_bloc.dart';
import 'package:fkgame/core/models/game_model.dart';
import 'package:fkgame/features/auth/data/models/user_model.dart';
import 'package:fkgame/core/services/mock_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

    // 如果用户数据为空，显示错误信息
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.profile)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('无法加载用户数据'),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().checkAuthStatus();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

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
              _showSettingsPage(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditProfilePage(context, user);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // 刷新用户数据
          await context.read<AuthCubit>().checkAuthStatus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(context, user),
              _buildStatsSection(context, userStats),
              _buildTabBar(context),
              _buildTabBarView(context, user),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      tabs: const [Tab(text: '功能'), Tab(text: '游戏记录'), Tab(text: '成就')],
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildTabBarView(BuildContext context, UserModel user) {
    return SizedBox(
      // 适应内容的高度，避免溢出
      height: MediaQuery.of(context).size.height * 0.4,
      child: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(child: _buildMenuSection(context)),
          SingleChildScrollView(child: _buildRecentGames(context)),
          _buildAchievements(context),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserModel user) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _showAvatarOptions(context);
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child:
                        user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                            ? ClipOval(
                              child: Image.network(
                                user.avatarUrl!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // 网络图片加载失败时显示本地默认头像
                                  return Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Theme.of(context).primaryColor,
                                  );
                                },
                              ),
                            )
                            : Icon(
                              Icons.person,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
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
                        user.username,
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
                          'LV.${user.level}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (user.role == UserRole.admin ||
                          user.role == UserRole.moderator)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                user.role == UserRole.admin
                                    ? Colors.red
                                    : Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.role == UserRole.admin ? '管理员' : '版主',
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
                    value: user.exp / _calculateNextLevelExp(user.level),
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'EXP: ${user.exp}/${_calculateNextLevelExp(user.level)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text('${user.gamePoint}'),
                      TextButton(
                        onPressed: () => _showWalletPage(context, user),
                        child: const Text('充值'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.diamond, color: Colors.purple, size: 16),
                      const SizedBox(width: 4),
                      const Text('0'), // 假设钻石数量
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 计算下一级所需经验值
  int _calculateNextLevelExp(int level) {
    return level * 1000; // 每级需要 level*1000 经验
  }

  Widget _buildStatsSection(BuildContext context, Map<String, dynamic> stats) {
    final localizations = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              Icons.videogame_asset,
              '${stats['playedGames']}',
              '已玩游戏',
              onTap: () => _showGameHistoryPage(context),
            ),
            _buildStatItem(
              context,
              Icons.favorite,
              '${stats['favorites']}',
              '收藏',
              onTap: () => _showFavoritesPage(context),
            ),
            _buildStatItem(
              context,
              Icons.people,
              '${stats['friends']}',
              '好友',
              onTap: () => _showFriendsPage(context),
            ),
            _buildStatItem(
              context,
              Icons.emoji_events,
              '${stats['achievements']}',
              '成就',
              onTap: () => _tabController.animateTo(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.history, '游戏历史', () {
            _showGameHistoryPage(context);
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.favorite, '我的收藏', () {
            _showFavoritesPage(context);
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.wallet, '我的钱包', () {
            // 获取非空用户信息
            final user = context.read<AuthCubit>().state.user;
            if (user != null) {
              _showWalletPage(context, user);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('无法获取用户信息')));
            }
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.emoji_events, '成就中心', () {
            _tabController.animateTo(2);
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.people, '好友列表', () {
            _showFriendsPage(context);
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.help, '帮助与反馈', () {
            _showHelpPage(context);
          }),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.logout, localizations.logout, () {
            _showLogoutConfirmation(context);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('最近玩过', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => _showGameHistoryPage(context),
                child: const Text('查看全部'),
              ),
            ],
          ),
          SizedBox(
            height: 200,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                List<GameModel> displayGames = [];

                if (state is HomeLoaded) {
                  try {
                    displayGames = state.hotGames;
                  } catch (e) {
                    // 处理错误
                  }
                }

                if (displayGames.isEmpty) {
                  return const Center(child: Text('暂无游戏数据'));
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: displayGames.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap:
                          () => _showGameDetail(context, displayGames[index]),
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    displayGames[index].smallImage,
                                    height: 120,
                                    width: 140,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 120,
                                        width: 140,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // 添加一个显示游戏时长的角标
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      '${(index + 1) * 5}小时',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              displayGames[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '上次游玩: 2小时前',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    // 模拟成就数据
    final achievements = [
      {
        'name': '初出茅庐',
        'description': '完成第一局游戏',
        'icon': Icons.star,
        'completed': true,
        'progress': 100,
      },
      {
        'name': '游戏达人',
        'description': '游戏时长超过100小时',
        'icon': Icons.access_time,
        'completed': true,
        'progress': 100,
      },
      {
        'name': '收藏家',
        'description': '收藏10个游戏',
        'icon': Icons.favorite,
        'completed': false,
        'progress': 45,
      },
      {
        'name': '社交达人',
        'description': '添加10个好友',
        'icon': Icons.people,
        'completed': false,
        'progress': 68,
      },
      {
        'name': '常胜将军',
        'description': '连胜10局游戏',
        'icon': Icons.emoji_events,
        'completed': false,
        'progress': 30,
      },
      {
        'name': '消费者',
        'description': '充值满1000点',
        'icon': Icons.monetization_on,
        'completed': false,
        'progress': 5,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final bool completed = achievement['completed'] as bool;
        final int progress = achievement['progress'] as int;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  completed ? Theme.of(context).primaryColor : Colors.grey[300],
              child: Icon(
                achievement['icon'] as IconData,
                color: completed ? Colors.white : Colors.grey[600],
              ),
            ),
            title: Text(
              achievement['name'] as String,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: completed ? Theme.of(context).primaryColor : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(achievement['description'] as String),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    completed ? Theme.of(context).primaryColor : Colors.orange,
                  ),
                ),
                const SizedBox(height: 2),
                Text('$progress%', style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing:
                completed
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
          ),
        );
      },
    );
  }

  // 弹出退出登录确认
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('退出登录'),
            content: const Text('确定要退出登录吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthCubit>().logout();
                  context.go('/login');
                },
                child: const Text('确定'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );
  }

  // 显示修改头像选项
  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('选择标准头像'),
                onTap: () {
                  Navigator.pop(context);
                  _showStandardAvatars(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('拍照'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 实现拍照功能
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('从相册选择'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 实现从相册选择功能
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStandardAvatars(BuildContext context) {
    final List<String> standardAvatars = [
      'assets/avatars/avatar1.png',
      'assets/avatars/avatar2.png',
      'assets/avatars/avatar3.png',
      'assets/avatars/avatar4.png',
      'assets/avatars/avatar5.png',
      'assets/avatars/avatar6.png',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('选择标准头像'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: standardAvatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // TODO: 实现头像选择后的逻辑，例如更新用户头像
                    // final selectedAvatar = standardAvatars[index];
                    // context.read<UserBloc>().add(UserEvent.updateAvatar(selectedAvatar));
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 30,
                    child: ClipOval(
                      child: Image.asset(
                        standardAvatars[index],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  // 以下是各种页面跳转方法的实现
  void _showSettingsPage(BuildContext context) {
    // TODO: 实现设置页面
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('设置页面将在后续版本推出')));
  }

  void _showEditProfilePage(BuildContext context, UserModel user) {
    // TODO: 实现编辑个人资料页面
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('编辑个人资料功能将在后续版本推出')));
  }

  void _showWalletPage(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return _WalletBottomSheet(
                user: user,
                scrollController: scrollController,
              );
            },
          ),
    );
  }

  void _showGameHistoryPage(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('游戏历史功能将在后续版本推出')));
  }

  void _showFavoritesPage(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('我的收藏功能将在后续版本推出')));
  }

  void _showFriendsPage(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('好友列表功能将在后续版本推出')));
  }

  void _showHelpPage(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('帮助与反馈功能将在后续版本推出')));
  }

  void _showGameDetail(BuildContext context, GameModel game) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('游戏详情：${game.name}')));
  }
}

// 钱包底部弹出页面
class _WalletBottomSheet extends StatefulWidget {
  final UserModel user;
  final ScrollController scrollController;

  const _WalletBottomSheet({
    Key? key,
    required this.user,
    required this.scrollController,
  }) : super(key: key);

  @override
  _WalletBottomSheetState createState() => _WalletBottomSheetState();
}

class _WalletBottomSheetState extends State<_WalletBottomSheet> {
  int _selectedAmount = 0;
  String _selectedPaymentMethod = 'alipay'; // 默认支付宝

  // 获取模拟数据服务
  final MockService _mockService = MockService();

  // 从MockService获取数据
  late final List<Map<String, dynamic>> _rechargeOptions;
  late final List<Map<String, dynamic>> _paymentMethods;
  late final List<Map<String, dynamic>> _promotions;
  late final List<Map<String, dynamic>> _rechargeHistory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 加载所有需要的数据
  void _loadData() {
    _rechargeOptions = _mockService.getRechargeOptions();
    _paymentMethods = _mockService.getPaymentMethods();
    _promotions = _mockService.getRechargePromotions();
    _rechargeHistory = _mockService.getUserRechargeHistory(widget.user.id);

    // 默认选择标记为popular的充值选项，如果没有则选择第一个
    final popularOption = _rechargeOptions.firstWhere(
      (option) => option['popular'] == true,
      orElse: () => _rechargeOptions.first,
    );

    setState(() {
      _selectedAmount = popularOption['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部拖动条
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // 标题
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '我的钱包',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        // 余额信息
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '当前余额',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.user.gamePoint}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '游戏点',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // 充值选项
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              // 优惠活动展示
              if (_promotions.isNotEmpty) ...[
                _buildPromotionsSection(),
                const SizedBox(height: 16),
              ],

              const Text(
                '充值游戏点',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _rechargeOptions.length,
                itemBuilder: (context, index) {
                  final option = _rechargeOptions[index];
                  final bool isSelected = _selectedAmount == option['amount'];
                  final bool isPopular = option['popular'] == true;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAmount = option['amount'];
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.monetization_on,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${option['amount']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  if (option['bonus'] > 0) ...[
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '+${option['bonus']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '￥${option['price']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isPopular)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: const Text(
                                '推荐',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 支付方式选择区域
              const Text(
                '选择支付方式',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 支付方式列表
              Column(
                children:
                    _paymentMethods.map((method) {
                      bool isSelected = _selectedPaymentMethod == method['id'];
                      bool hasFee = (method['fee'] as double) > 0;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = method['id'] as String;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[300]!,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                method['icon'] as IconData,
                                color:
                                    isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[700],
                                size: 28,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method['name'] as String,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color:
                                            isSelected
                                                ? Theme.of(context).primaryColor
                                                : Colors.black,
                                      ),
                                    ),
                                    if (hasFee)
                                      Text(
                                        '手续费: ${method['fee']}元',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    _selectedAmount > 0
                        ? () => _processRecharge(context)
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('立即充值'),
              ),

              if (_rechargeHistory.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildRechargeHistorySection(),
              ],

              const SizedBox(height: 8),
              const Text(
                '说明：充值的游戏点可用于购买游戏内道具、解锁高级功能等。',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 构建优惠活动展示
  Widget _buildPromotionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '充值优惠',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _promotions.length,
            itemBuilder: (context, index) {
              final promotion = _promotions[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade300, Colors.purple.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promotion['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      promotion['description'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      promotion['conditions'] as String,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 构建充值历史记录部分
  Widget _buildRechargeHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '充值记录',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // 查看更多充值记录
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('充值记录功能将在后续版本推出')));
              },
              child: const Text('查看更多'),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              _rechargeHistory.length > 2
                  ? 2
                  : _rechargeHistory.length, // 只显示最近2条
          itemBuilder: (context, index) {
            final record = _rechargeHistory[index];
            final DateTime date = record['createdAt'] as DateTime;
            final String formattedDate =
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            final bool isSuccess = record['status'] == 'success';

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.pending,
                    color: isSuccess ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '充值 ${record['amount']} 游戏点',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$formattedDate · ￥${record['price']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isSuccess ? '成功' : '处理中',
                    style: TextStyle(
                      color: isSuccess ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _processRecharge(BuildContext context) {
    // 获取选中的充值选项
    final option = _rechargeOptions.firstWhere(
      (o) => o['amount'] == _selectedAmount,
      orElse: () => _rechargeOptions.first,
    );

    // 获取选择的支付方式
    final paymentMethod = _paymentMethods.firstWhere(
      (method) => method['id'] == _selectedPaymentMethod,
      orElse: () => _paymentMethods.first,
    );

    // 计算手续费
    final double fee = paymentMethod['fee'] as double;
    final double totalPrice = option['price'] + fee;

    // 显示确认对话框
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('确认充值'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('充值金额：￥${option['price']}'),
                if (fee > 0) Text('手续费：￥$fee'),
                if (fee > 0) Text('总计：￥$totalPrice'),
                Text('游戏点：${option['amount']}'),
                if (option['bonus'] > 0) Text('赠送：${option['bonus']}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('支付方式：'),
                    Icon(
                      paymentMethod['icon'] as IconData,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      paymentMethod['name'] as String,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 关闭对话框

                  // 根据不同的支付方式跳转到不同的支付界面
                  _navigateToPayment(
                    context,
                    paymentMethod['id'] as String,
                    option,
                  );
                },
                child: const Text('确认'),
              ),
            ],
          ),
    );
  }

  void _navigateToPayment(
    BuildContext context,
    String paymentMethodId,
    Map<String, dynamic> option,
  ) {
    // 关闭钱包底部弹出页
    Navigator.pop(context);

    // 显示加载对话框，模拟支付跳转
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('正在跳转至支付平台...'),
              ],
            ),
          ),
    );

    // 模拟支付跳转延迟
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // 关闭加载对话框

      // 不同支付方式的不同提示
      String paymentName = '';
      switch (paymentMethodId) {
        case 'alipay':
          paymentName = '支付宝';
          break;
        case 'wechat':
          paymentName = '微信支付';
          break;
        case 'bank':
          paymentName = '银行卡';
          break;
        case 'apple':
          paymentName = 'Apple Pay';
          break;
        case 'paypal':
          paymentName = 'PayPal';
          break;
      }

      // 显示支付成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已通过${paymentName}成功充值${option['amount']}游戏点！')),
      );
    });
  }
}
