import 'package:fkgame/features/home/data/models/game_model.dart';
import 'package:fkgame/features/home/data/models/banner_model.dart';
import 'package:fkgame/features/home/data/models/category_model.dart';

/// 模拟数据服务，集中管理所有模拟数据
/// 后期可以轻松切换到真实API
class MockService {
  // 单例实现
  static final MockService _instance = MockService._internal();
  factory MockService() => _instance;
  MockService._internal();

  /// 获取模拟轮播图数据
  List<BannerModel> getBanners() {
    return [
      BannerModel(
        id: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        img: 'https://picsum.photos/800/400?random=1',
        bgImg: 'https://picsum.photos/800/400?random=1',
        sort: 1,
        link: 'https://flutter.dev',
        gameId: 1,
        game: GameModel(
          id: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          name: '热门游戏1',
          description: '这是一个精彩的游戏',
          playDesc: '点击开始',
          likes: 5000,
          playTimes: 20000,
          categoryId: '1',
          sort: 1,
          isHot: 1,
          isNew: 0,
          bigImage: 'https://picsum.photos/800/400?random=2',
          smallImage: 'https://picsum.photos/400/200?random=2',
          link: 'https://flutter.dev',
          showType: 1,
        ),
      ),
      BannerModel(
        id: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        img: 'https://picsum.photos/800/400?random=3',
        bgImg: 'https://picsum.photos/800/400?random=3',
        sort: 2,
        link: 'https://flutter.dev',
        gameId: 2,
        game: GameModel(
          id: 2,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          name: '新游戏2',
          description: '刚上线的精彩游戏',
          playDesc: '立即尝试',
          likes: 3000,
          playTimes: 15000,
          categoryId: '2',
          sort: 2,
          isHot: 0,
          isNew: 1,
          bigImage: 'https://picsum.photos/800/400?random=4',
          smallImage: 'https://picsum.photos/400/200?random=4',
          link: 'https://flutter.dev',
          showType: 1,
        ),
      ),
      BannerModel(
        id: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        img: 'https://picsum.photos/800/400?random=5',
        bgImg: 'https://picsum.photos/800/400?random=5',
        sort: 3,
        link: 'https://flutter.dev',
        gameId: 3,
        game: GameModel(
          id: 3,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          name: '推荐游戏3',
          description: '最受欢迎的游戏之一',
          playDesc: '马上体验',
          likes: 8000,
          playTimes: 30000,
          categoryId: '1',
          sort: 3,
          isHot: 1,
          isNew: 0,
          bigImage: 'https://picsum.photos/800/400?random=6',
          smallImage: 'https://picsum.photos/400/200?random=6',
          link: 'https://flutter.dev',
          showType: 1,
        ),
      ),
    ];
  }

  /// 获取模拟分类数据
  List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        id: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: '休闲游戏',
        icon: 'https://picsum.photos/100/100?random=14',
        sort: 1,
      ),
      CategoryModel(
        id: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: '益智游戏',
        icon: 'https://picsum.photos/100/100?random=15',
        sort: 2,
      ),
      CategoryModel(
        id: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: '动作游戏',
        icon: 'https://picsum.photos/100/100?random=16',
        sort: 3,
      ),
      CategoryModel(
        id: 4,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: '策略游戏',
        icon: 'https://picsum.photos/100/100?random=17',
        sort: 4,
      ),
      CategoryModel(
        id: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: '冒险游戏',
        icon: 'https://picsum.photos/100/100?random=18',
        sort: 5,
      ),
    ];
  }

  /// 获取模拟热门游戏数据
  List<GameModel> getHotGames({int page = 1, int pageSize = 10}) {
    // 构建大量模拟数据
    final List<GameModel> allHotGames = _buildLargeGamesList(
      prefix: '热门游戏',
      count: 50,
      startId: 100,
      isHot: 1,
      isNew: 0,
      categoryId: '1',
    );

    // 分页返回数据
    final int startIndex = (page - 1) * pageSize;
    final int endIndex = startIndex + pageSize;

    if (startIndex >= allHotGames.length) {
      return [];
    }

    return allHotGames.sublist(
      startIndex,
      endIndex > allHotGames.length ? allHotGames.length : endIndex,
    );
  }

  /// 获取模拟新游戏数据
  List<GameModel> getNewGames({int page = 1, int pageSize = 10}) {
    // 构建大量模拟数据
    final List<GameModel> allNewGames = _buildLargeGamesList(
      prefix: '新游戏',
      count: 50,
      startId: 200,
      isHot: 0,
      isNew: 1,
      categoryId: '2',
    );

    // 分页返回数据
    final int startIndex = (page - 1) * pageSize;
    final int endIndex = startIndex + pageSize;

    if (startIndex >= allNewGames.length) {
      return [];
    }

    return allNewGames.sublist(
      startIndex,
      endIndex > allNewGames.length ? allNewGames.length : endIndex,
    );
  }

  /// 根据分类ID获取模拟游戏数据
  List<GameModel> getGamesByCategory(
    String categoryId, {
    int page = 1,
    int pageSize = 10,
  }) {
    // 构建每个分类的大量模拟数据
    final Map<String, List<GameModel>> categoryGames = {
      '1': _buildLargeGamesList(
        prefix: '休闲游戏',
        count: 30,
        startId: 300,
        categoryId: '1',
      ),
      '2': _buildLargeGamesList(
        prefix: '益智游戏',
        count: 30,
        startId: 400,
        categoryId: '2',
      ),
      '3': _buildLargeGamesList(
        prefix: '动作游戏',
        count: 30,
        startId: 500,
        categoryId: '3',
      ),
      '4': _buildLargeGamesList(
        prefix: '策略游戏',
        count: 30,
        startId: 600,
        categoryId: '4',
      ),
      '5': _buildLargeGamesList(
        prefix: '冒险游戏',
        count: 30,
        startId: 700,
        categoryId: '5',
      ),
    };

    // 获取对应分类的游戏列表
    final List<GameModel> gamesForCategory = categoryGames[categoryId] ?? [];

    // 分页返回数据
    final int startIndex = (page - 1) * pageSize;
    final int endIndex = startIndex + pageSize;

    if (startIndex >= gamesForCategory.length) {
      return [];
    }

    return gamesForCategory.sublist(
      startIndex,
      endIndex > gamesForCategory.length ? gamesForCategory.length : endIndex,
    );
  }

  /// 搜索游戏
  List<GameModel> searchGames(String query, {int page = 1, int pageSize = 20}) {
    // 构建一个包含所有游戏的大列表
    final List<GameModel> allGames = [
      ..._buildLargeGamesList(prefix: '热门游戏', count: 50, startId: 100),
      ..._buildLargeGamesList(prefix: '新游戏', count: 50, startId: 200),
      ..._buildLargeGamesList(
        prefix: '休闲游戏',
        count: 30,
        startId: 300,
        categoryId: '1',
      ),
      ..._buildLargeGamesList(
        prefix: '益智游戏',
        count: 30,
        startId: 400,
        categoryId: '2',
      ),
      ..._buildLargeGamesList(
        prefix: '动作游戏',
        count: 30,
        startId: 500,
        categoryId: '3',
      ),
    ];

    // 去重
    final Map<int, GameModel> uniqueGames = {};
    for (final game in allGames) {
      uniqueGames[game.id] = game;
    }

    // 根据关键词搜索
    final searchQuery = query.toLowerCase();
    final List<GameModel> searchResults =
        uniqueGames.values.where((game) {
          // 在游戏名称、描述和玩法说明中搜索
          return game.name.toLowerCase().contains(searchQuery) ||
              game.description.toLowerCase().contains(searchQuery) ||
              game.playDesc.toLowerCase().contains(searchQuery);
        }).toList();

    // 分页返回数据
    final int startIndex = (page - 1) * pageSize;
    final int endIndex = startIndex + pageSize;

    if (startIndex >= searchResults.length) {
      return [];
    }

    return searchResults.sublist(
      startIndex,
      endIndex > searchResults.length ? searchResults.length : endIndex,
    );
  }

  /// 辅助方法：构建大量游戏数据
  List<GameModel> _buildLargeGamesList({
    required String prefix,
    required int count,
    required int startId,
    String categoryId = '1',
    int isHot = 0,
    int isNew = 0,
  }) {
    final List<GameModel> gamesList = [];

    // 可能的游戏类型描述
    final List<String> gameDescriptions = [
      '这是一个非常受欢迎的游戏，玩家需要收集资源并建造自己的城市。',
      '在这个冒险游戏中，你将扮演一名勇士，探索神秘的洞穴和森林。',
      '一款策略游戏，需要精心规划你的军队和资源，击败敌人的防线。',
      '轻松有趣的休闲游戏，适合所有年龄段的玩家消磨时间。',
      '挑战你的大脑，解决各种复杂谜题，提升你的逻辑思维能力。',
      '刺激的动作游戏，享受紧张刺激的战斗体验。',
      '模拟真实生活的游戏，你可以在游戏中体验不同的职业和生活。',
      '与朋友一起合作，共同完成任务和挑战的多人游戏。',
      '需要快速反应和精准操作的技巧型游戏。',
      '融合多种元素的创新游戏，带给你前所未有的游戏体验。',
    ];

    // 可能的游戏玩法说明
    final List<String> playDescriptions = [
      '点击开始按钮，使用方向键控制角色移动。',
      '收集资源，建造建筑，发展你的帝国。',
      '解决谜题，找到隐藏的线索，完成任务。',
      '与其他玩家组队，一起挑战强大的敌人。',
      '自由探索开放世界，发现隐藏的宝藏和秘密。',
      '根据屏幕提示操作，体验故事情节。',
      '选择适合的装备，提升角色属性。',
      '通过完成日常任务获取奖励和经验值。',
      '使用触摸屏滑动控制游戏角色。',
      '关注游戏内提示，学习高级技巧。',
    ];

    for (int i = 0; i < count; i++) {
      final int gameId = startId + i;
      final DateTime createdAt = DateTime.now().subtract(Duration(days: i));
      final int likes = 5000 - (i * 50);
      final int playTimes = 20000 - (i * 200);

      // 计算是否为热门或新游戏
      final int isGameHot = isHot == 1 ? (i < count * 0.3 ? 1 : 0) : 0;
      final int isGameNew = isNew == 1 ? (i < count * 0.3 ? 1 : 0) : 0;

      // 随机选择描述和玩法说明
      final String description = gameDescriptions[i % gameDescriptions.length];
      final String playDesc = playDescriptions[i % playDescriptions.length];

      gamesList.add(
        GameModel(
          id: gameId,
          createdAt: createdAt,
          updatedAt: createdAt.add(const Duration(days: 1)),
          name: '$prefix ${i + 1}',
          description: description,
          playDesc: playDesc,
          likes: likes,
          playTimes: playTimes,
          categoryId: categoryId,
          sort: i + 1,
          isHot: isGameHot,
          isNew: isGameNew,
          bigImage: 'https://picsum.photos/800/400?random=${gameId}',
          smallImage: 'https://picsum.photos/400/200?random=${gameId}',
          link: 'https://flutter.dev',
          showType: 1,
        ),
      );
    }

    return gamesList;
  }
}
