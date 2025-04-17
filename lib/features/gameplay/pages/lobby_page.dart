import 'package:flutter/material.dart';
import 'package:fkgame/features/home/data/models/game_model.dart';
import 'package:fkgame/features/home/widgets/game_card.dart';
import 'package:fkgame/l10n/app_localizations.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['全部', '热门', '新游戏', '休闲', '动作', '策略'];

  // 模拟游戏数据
  final List<GameModel> _mockGames = List.generate(
    10,
    (index) => GameModel(
      id: 1000 + index,
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
      name: '游戏大厅游戏 ${index + 1}',
      description: '这是游戏大厅的一款游戏，有趣刺激。',
      playDesc: '点击开始游戏',
      likes: 5000 - (index * 300),
      playTimes: 20000 - (index * 1000),
      categoryId: (index % 4 + 1).toString(),
      sort: index + 1,
      isHot: index < 3 ? 1 : 0,
      isNew: index < 5 ? 1 : 0,
      bigImage: 'https://picsum.photos/800/400?random=${1000 + index}',
      smallImage: 'https://picsum.photos/400/200?random=${1000 + index}',
      link: 'https://flutter.dev',
      showType: 1,
    ),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.lobby),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) => _buildGameGrid(tab)).toList(),
      ),
    );
  }

  Widget _buildGameGrid(String tabName) {
    // 根据标签筛选不同游戏
    List<GameModel> filteredGames = _mockGames;

    if (tabName == '热门') {
      filteredGames = _mockGames.where((game) => game.isHot == 1).toList();
    } else if (tabName == '新游戏') {
      filteredGames = _mockGames.where((game) => game.isNew == 1).toList();
    } else if (tabName != '全部') {
      // 模拟基于分类名称筛选
      filteredGames =
          _mockGames
              .where(
                (game) =>
                    game.name.contains(tabName) ||
                    game.id % _tabs.indexOf(tabName) == 0,
              )
              .toList();
    }

    if (filteredGames.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videogame_asset_off,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无游戏',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredGames.length,
      itemBuilder: (context, index) {
        return GameCard(game: filteredGames[index]);
      },
    );
  }
}
