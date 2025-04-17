import 'package:fkgame/core/models/game_model.dart';
import 'package:fkgame/core/models/category_model.dart';
import 'package:fkgame/core/services/mock_service.dart';
import 'package:fkgame/features/home/data/models/banner_model.dart';

/// 游戏数据仓库
/// 全局单例模式实现，确保整个应用使用相同的游戏数据
class GameRepository {
  // 单例实现
  static final GameRepository _instance = GameRepository._internal();
  factory GameRepository() => _instance;
  GameRepository._internal();

  final MockService _mockService = MockService();

  // 缓存
  List<CategoryModel>? _categories;
  Map<String, List<GameModel>> _categoryGames = {};
  List<GameModel>? _hotGames;
  List<GameModel>? _newGames;
  List<BannerModel>? _banners;
  Map<String, List<String>>? _categoryGroups;
  Map<String, int>? _categoryGameCounts;

  // 获取游戏分类分组
  Map<String, List<String>> getCategoryGroups() {
    if (_categoryGroups != null) return _categoryGroups!;

    _categoryGroups = _mockService.getCategoryGroups();
    return _categoryGroups!;
  }

  // 获取分类 (只加载一次)
  Future<List<CategoryModel>> getCategories() async {
    if (_categories != null) return _categories!;

    _categories = _mockService.getCategories();
    return _categories!;
  }

  // 获取分类游戏 (按需加载并缓存)
  Future<List<GameModel>> getGamesByCategory(
    String categoryId, {
    bool refresh = false,
    int page = 1,
    int pageSize = 10,
  }) async {
    // 强制刷新或首次加载
    if (refresh || !_categoryGames.containsKey(categoryId)) {
      final games = _mockService.getGamesByCategory(
        categoryId,
        page: page,
        pageSize: pageSize,
      );
      _categoryGames[categoryId] = games;
    }

    return _categoryGames[categoryId] ?? [];
  }

  // 获取分类游戏总数 (不分页)
  Future<int> getCategoryGameCount(String categoryId) async {
    // 初始化计数缓存
    _categoryGameCounts ??= {};

    // 如果已经有缓存的计数，直接返回
    if (_categoryGameCounts!.containsKey(categoryId)) {
      return _categoryGameCounts![categoryId] ?? 0;
    }

    // 获取分类游戏总数
    final count = _mockService.getCategoryGameCount(categoryId);
    _categoryGameCounts![categoryId] = count;

    return count;
  }

  // 获取所有分类游戏计数的映射
  Future<Map<String, int>> getAllCategoryGameCounts() async {
    // 如果已经缓存了所有分类的计数，直接返回
    if (_categoryGameCounts != null && _categories != null) {
      bool allCategoriesCounted = true;
      for (var category in _categories!) {
        if (!_categoryGameCounts!.containsKey(category.id.toString())) {
          allCategoriesCounted = false;
          break;
        }
      }

      if (allCategoriesCounted) {
        return _categoryGameCounts!;
      }
    }

    // 初始化计数缓存
    _categoryGameCounts ??= {};

    // 获取所有分类
    final categories = await getCategories();

    // 获取每个分类的游戏计数
    for (var category in categories) {
      final categoryId = category.id.toString();
      if (!_categoryGameCounts!.containsKey(categoryId)) {
        _categoryGameCounts![categoryId] = _mockService.getCategoryGameCount(
          categoryId,
        );
      }
    }

    return _categoryGameCounts!;
  }

  // 获取热门游戏
  Future<List<GameModel>> getHotGames({
    bool refresh = false,
    int page = 1,
    int pageSize = 10,
  }) async {
    if (refresh || _hotGames == null) {
      _hotGames = _mockService.getHotGames(page: page, pageSize: pageSize);
    }
    return _hotGames ?? [];
  }

  // 获取新游戏
  Future<List<GameModel>> getNewGames({
    bool refresh = false,
    int page = 1,
    int pageSize = 10,
  }) async {
    if (refresh || _newGames == null) {
      _newGames = _mockService.getNewGames(page: page, pageSize: pageSize);
    }
    return _newGames ?? [];
  }

  // 获取轮播图
  Future<List<BannerModel>> getBanners({bool refresh = false}) async {
    if (refresh || _banners == null) {
      _banners = _mockService.getBanners();
    }
    return _banners ?? [];
  }

  // 搜索游戏 (不缓存)
  Future<List<GameModel>> searchGames(
    String query, {
    int page = 1,
    int pageSize = 20,
  }) async {
    return _mockService.searchGames(query, page: page, pageSize: pageSize);
  }

  // 清除缓存
  void clearCache() {
    _categories = null;
    _categoryGames.clear();
    _hotGames = null;
    _newGames = null;
    _banners = null;
    _categoryGameCounts = null;
  }
}
