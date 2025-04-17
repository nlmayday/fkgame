import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/core/theme/app_theme.dart';
import 'package:fkgame/core/models/game_model.dart';
import 'package:fkgame/features/home/logic/home_bloc.dart';
import 'package:fkgame/l10n/app_localizations.dart';
import 'package:fkgame/features/home/widgets/game_card.dart';
import 'package:fkgame/features/home/widgets/game_category_card.dart';
import 'package:fkgame/features/home/pages/search_page.dart';
import 'package:fkgame/features/home/pages/all_games_page.dart';
import 'package:fkgame/features/home/pages/all_categories_page.dart';
import 'package:fkgame/core/localization/locale_cubit.dart';
import 'package:fkgame/core/widgets/app_bar_with_logout.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/features/auth/logic/auth_state.dart';

// 为了避免类名冲突，使用as关键字为导入的类指定别名
import 'package:fkgame/features/home/data/models/banner_model.dart'
    as api_banner;
// 导入banner_slider.dart并为BannerModel类指定别名
import 'package:fkgame/features/home/widgets/banner_slider.dart';

// 将BannerSlider的BannerModel重新导出为ViewBannerModel类型别名
typedef ViewBannerModel = BannerModel;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 加载首页数据
    context.read<HomeBloc>().add(LoadHomeData());
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
    );
  }

  void _showLanguageOptions(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    final currentLocale = localeCubit.state.locale.languageCode;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('语言/Language'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('中文'),
                  trailing:
                      currentLocale == 'zh' ? const Icon(Icons.check) : null,
                  onTap: () {
                    localeCubit.changeToZhCN();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('English'),
                  trailing:
                      currentLocale == 'en' ? const Icon(Icons.check) : null,
                  onTap: () {
                    localeCubit.changeToEnUS();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final authState = context.watch<AuthCubit>().state;

    return Scaffold(
      appBar: AppBarWithLogout(
        title: localizations.appName,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // 打开通知页面
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeRefreshing || state is HomeLoaded) {
            List<GameModel> recommendedGames = [];
            List<GameModel> popularGames = [];
            List<GameModel> newGames = [];
            List<GameCategoryModel> categories = [];

            if (state is HomeRefreshing) {
              // Use hotGames for popularGames
              popularGames = state.hotGames;
              // Use a subset of hotGames for recommendedGames if needed
              recommendedGames = state.hotGames.take(3).toList();
              newGames = state.newGames;
              // Convert CategoryModel to GameCategoryModel
              categories =
                  state.categories
                      .map(
                        (cat) => GameCategoryModel(
                          id: cat.id.toString(),
                          name: cat.name,
                          icon: cat.icon,
                          description: '',
                          games: [],
                        ),
                      )
                      .toList();
            } else if (state is HomeLoaded) {
              // Use hotGames for popularGames
              popularGames = state.hotGames;
              // Use a subset of hotGames for recommendedGames if needed
              recommendedGames = state.hotGames.take(3).toList();
              newGames = state.newGames;
              // Convert CategoryModel to GameCategoryModel
              categories =
                  state.categories
                      .map(
                        (cat) => GameCategoryModel(
                          id: cat.id.toString(),
                          name: cat.name,
                          icon: cat.icon,
                          description: '',
                          games: [],
                        ),
                      )
                      .toList();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(RefreshHomeData());
              },
              child: _buildHomeContent(
                context,
                recommendedGames,
                popularGames,
                newGames,
                categories,
                authState,
                state,
              ),
            );
          } else if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(LoadHomeData());
                    },
                    child: Text(localizations.retry),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    List<GameModel> recommendedGames,
    List<GameModel> popularGames,
    List<GameModel> newGames,
    List<GameCategoryModel> categories,
    AuthState authState,
    HomeState state,
  ) {
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 轮播图 - 使用BlocBuilder来获取最新状态
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoaded && state.banners.isNotEmpty) {
                // 将API返回的BannerModel转换为视图BannerModel
                final viewBanners =
                    state.banners.map((apiBanner) {
                      return ViewBannerModel(
                        imageUrl:
                            apiBanner.img.startsWith('http')
                                ? apiBanner.img
                                : 'https://static.madlygame.com/${apiBanner.img}',
                        linkUrl: apiBanner.link,
                        title: apiBanner.game?.name,
                        subtitle: apiBanner.game?.description,
                      );
                    }).toList();

                return BannerSlider(
                  banners: viewBanners,
                  height: 180.0,
                  showIndicator: true,
                );
              }
              // 如果没有轮播图，显示一个占位符
              if (state is HomeLoaded && state.banners.isEmpty) {
                return Container(
                  height: 180.0,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Center(
                    child: Text('No banner images available'),
                  ),
                );
              }
              // 加载中或者错误时，显示加载中的占位
              return Container(
                height: 180.0,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),

          // 推荐游戏
          _buildGameSection(
            context: context,
            title: localizations.recommended,
            games: recommendedGames,
            seeAllOnTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: context.read<HomeBloc>(),
                        child: AllGamesPage(
                          type: GameListType.recommended,
                          categoryName: localizations.recommended,
                        ),
                      ),
                ),
              );
            },
            isLarge: true,
          ),

          // 热门游戏
          _buildGameSection(
            context: context,
            title: localizations.popular,
            games: popularGames,
            seeAllOnTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: context.read<HomeBloc>(),
                        child: AllGamesPage(
                          type: GameListType.popular,
                          categoryName: localizations.popular,
                        ),
                      ),
                ),
              );
            },
          ),

          // 新游戏
          _buildGameSection(
            context: context,
            title: localizations.newGames,
            games: newGames,
            seeAllOnTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: context.read<HomeBloc>(),
                        child: AllGamesPage(
                          type: GameListType.newGames,
                          categoryName: localizations.newGames,
                        ),
                      ),
                ),
              );
            },
          ),

          // 分类
          if (categories.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.games,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider.value(
                                value: context.read<HomeBloc>(),
                                child: AllCategoriesPage(
                                  categories: categories,
                                ),
                              ),
                        ),
                      );
                    },
                    child: Text(localizations.seeAll),
                  ),
                ],
              ),
            ),

            // 分类列表
            SizedBox(
              height: 110.0,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GameCategoryCard(
                    category: categories[index],
                    onTap: () {
                      // 点击切换分类并加载该分类的游戏
                      context.read<HomeBloc>().add(
                        LoadCategoryGames(
                          categoryId: categories[index].id.toString(),
                        ),
                      );

                      // 导航到该分类的游戏列表页面
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider.value(
                                value: context.read<HomeBloc>(),
                                child: AllGamesPage(
                                  type: GameListType.category,
                                  categoryId: categories[index].id.toString(),
                                  categoryName: categories[index].name,
                                ),
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildGameSection({
    required BuildContext context,
    required String title,
    required List<GameModel> games,
    required VoidCallback seeAllOnTap,
    bool isLarge = false,
  }) {
    final localizations = AppLocalizations.of(context);

    if (games.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: seeAllOnTap,
                child: Text(localizations.seeAll),
              ),
            ],
          ),
        ),
        SizedBox(
          height: isLarge ? 200.0 : 160.0,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            itemBuilder: (context, index) {
              return GameCard(game: games[index], isLarge: isLarge);
            },
          ),
        ),
      ],
    );
  }
}
