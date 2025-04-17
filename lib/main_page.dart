import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/features/home/data/repository/home_repository.dart';
import 'package:fkgame/features/home/logic/home_bloc.dart';
import 'package:fkgame/features/home/pages/home_page.dart';
import 'package:fkgame/features/gameplay/pages/lobby_page.dart';
import 'package:fkgame/features/social/pages/social_page.dart';
import 'package:fkgame/features/user/pages/profile_page.dart';
import 'package:fkgame/core/network/api/client.dart';
import 'package:fkgame/l10n/app_localizations.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/features/auth/logic/auth_state.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // 使用PageController实现页面切换动画
  final PageController _pageController = PageController();

  // 缓存页面实例，避免重复创建
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 检查用户认证状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkAuthStatus();
    });
    _initPages();
  }

  void _initPages() {
    final apiClient = ApiClient();
    final homeRepository = HomeRepositoryImpl(apiClient);

    _pages = [
      BlocProvider(
        create: (context) => HomeBloc(homeRepository),
        child: const HomePage(),
      ),
      const LobbyPage(),
      const SocialPage(),
      const ProfilePage(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    // 如果点击的是个人主页且未登录，则跳转到登录页面
    if (index == 3) {
      final authState = context.read<AuthCubit>().state;
      if (!authState.isAuthenticated) {
        context.go('/login');
        return;
      }
    }

    // 使用animateToPage实现平滑动画
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // 禁用滑动切换，仅使用底部导航
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.games),
            label: localizations.lobby,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: localizations.social,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localizations.me,
          ),
        ],
      ),
    );
  }
}
