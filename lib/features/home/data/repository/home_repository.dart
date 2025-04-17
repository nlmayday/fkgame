import 'package:dartz/dartz.dart';

import 'package:fkgame/core/error/failures.dart';
import 'package:fkgame/core/network/api/client.dart';
import 'package:fkgame/core/constants/api.dart';
import 'package:fkgame/core/utils/api_response.dart';
import 'package:fkgame/core/services/mock_service.dart';
import 'package:fkgame/core/models/game_model.dart';
import 'package:fkgame/features/home/data/models/banner_model.dart';
import 'package:fkgame/core/models/category_model.dart';

/// 首页仓库接口
abstract class HomeRepository {
  /// 获取轮播图
  Future<Either<Failure, List<BannerModel>>> getBanners();

  /// 获取分类列表
  Future<Either<Failure, List<CategoryModel>>> getCategories({
    int page = 1,
    int pageSize = 10,
  });

  /// 获取游戏列表
  Future<Either<Failure, List<GameModel>>> getGamesByCategory({
    required String categoryId,
    int page = 1,
    int pageSize = 10,
  });

  /// 获取热门游戏列表
  Future<Either<Failure, List<GameModel>>> getHotGames({
    int page = 1,
    int pageSize = 10,
  });

  /// 获取新游戏列表
  Future<Either<Failure, List<GameModel>>> getNewGames({
    int page = 1,
    int pageSize = 10,
  });

  /// 搜索游戏
  Future<Either<Failure, List<GameModel>>> searchGames({
    required String query,
    int page = 1,
    int pageSize = 20,
  });
}

/// 首页仓库实现
class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;
  final MockService _mockService;

  HomeRepositoryImpl(this._apiClient, [MockService? mockService])
    : _mockService = mockService ?? MockService();

  @override
  Future<Either<Failure, List<BannerModel>>> getBanners() async {
    try {
      print('开始获取轮播图数据...');

      // 使用MockService获取模拟数据
      final List<BannerModel> mockBanners = _mockService.getBanners();
      print('使用模拟数据: ${mockBanners.length} 个轮播图');
      return Right(mockBanners);

      // 注释掉真实API调用
      /*
      final response = await _apiClient.post(ApiConstants.banner);

      final apiResponse = ApiResponse.fromJson(
        response,
        (data) =>
            (data as List).map((item) => BannerModel.fromJson(item)).toList(),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Right(apiResponse.data!);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message ?? 'Failed to get banners',
          ),
        );
      }
      */
    } on ApiException catch (e) {
      print('获取轮播图失败: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print('获取轮播图意外错误: $e');
      return Left(ServerFailure(message: 'Failed to get banners'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      print('开始获取分类数据...');

      // 使用MockService获取模拟数据
      final List<CategoryModel> mockCategories = _mockService.getCategories();
      print('使用模拟数据: ${mockCategories.length} 个分类');
      return Right(mockCategories);

      // 注释掉真实API调用
      /*
      final response = await _apiClient.get(
        ApiConstants.categoryList,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      final apiResponse = ApiResponse.fromJson(
        response,
        (data) =>
            (data['list'] as List)
                .map((item) => CategoryModel.fromJson(item))
                .toList(),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Right(apiResponse.data!);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message ?? 'Failed to get categories',
          ),
        );
      }
      */
    } on ApiException catch (e) {
      print('获取分类失败: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print('获取分类意外错误: $e');
      return Left(ServerFailure(message: 'Failed to get categories'));
    }
  }

  @override
  Future<Either<Failure, List<GameModel>>> getGamesByCategory({
    required String categoryId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      print('开始获取分类 $categoryId 的游戏数据...');

      // 使用MockService获取模拟数据
      final List<GameModel> mockGames = _mockService.getGamesByCategory(
        categoryId,
        page: page,
        pageSize: pageSize,
      );
      print('使用模拟数据: ${mockGames.length} 个游戏');
      return Right(mockGames);

      // 注释掉真实API调用
      /*
      final response = await _apiClient.get(
        ApiConstants.gameList,
        queryParameters: {
          'categoryId': categoryId,
          'page': page,
          'pageSize': pageSize,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response,
        (data) =>
            (data['list'] as List)
                .map((item) => GameModel.fromJson(item))
                .toList(),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Right(apiResponse.data!);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message ?? 'Failed to get games by category',
          ),
        );
      }
      */
    } on ApiException catch (e) {
      print('获取分类游戏失败: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print('获取分类游戏意外错误: $e');
      return Left(ServerFailure(message: 'Failed to get games by category'));
    }
  }

  @override
  Future<Either<Failure, List<GameModel>>> getHotGames({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      print('开始获取热门游戏数据...');

      // 使用MockService获取模拟数据
      final List<GameModel> mockGames = _mockService.getHotGames(
        page: page,
        pageSize: pageSize,
      );
      print('使用模拟数据: ${mockGames.length} 个热门游戏');
      return Right(mockGames);

      // 注释掉真实API调用
      /*
      final response = await _apiClient.get(
        ApiConstants.hotGameList,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      final apiResponse = ApiResponse.fromJson(
        response,
        (data) =>
            (data['list'] as List)
                .map((item) => GameModel.fromJson(item))
                .toList(),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Right(apiResponse.data!);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message ?? 'Failed to get hot games',
          ),
        );
      }
      */
    } on ApiException catch (e) {
      print('获取热门游戏失败: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print('获取热门游戏意外错误: $e');
      return Left(ServerFailure(message: 'Failed to get hot games'));
    }
  }

  @override
  Future<Either<Failure, List<GameModel>>> getNewGames({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      print('开始获取新游戏数据...');

      // 使用MockService获取模拟数据
      final List<GameModel> mockGames = _mockService.getNewGames(
        page: page,
        pageSize: pageSize,
      );
      print('使用模拟数据: ${mockGames.length} 个新游戏');
      return Right(mockGames);

      // 注释掉真实API调用
      /*
      final response = await _apiClient.get(
        ApiConstants.newGameList,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      final apiResponse = ApiResponse.fromJson(
        response,
        (data) =>
            (data['list'] as List)
                .map((item) => GameModel.fromJson(item))
                .toList(),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Right(apiResponse.data!);
      } else {
        return Left(
          ServerFailure(
            message: apiResponse.message ?? 'Failed to get new games',
          ),
        );
      }
      */
    } on ApiException catch (e) {
      print('获取新游戏失败: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print('获取新游戏意外错误: $e');
      return Left(ServerFailure(message: 'Failed to get new games'));
    }
  }

  @override
  Future<Either<Failure, List<GameModel>>> searchGames({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      print('开始优化搜索游戏，关键词: $query...');

      if (query.isEmpty) {
        print('搜索关键词为空，返回空结果');
        return const Right([]);
      }

      // 获取所有游戏数据
      final hotGamesResult = await getHotGames(page: 1, pageSize: 100);
      final newGamesResult = await getNewGames(page: 1, pageSize: 100);

      // 获取所有分类
      final categoriesResult = await getCategories();

      // 从结果中提取游戏列表
      List<GameModel> allGames = [];
      hotGamesResult.fold(
        (failure) => print('获取热门游戏失败: ${failure.message}'),
        (games) => allGames.addAll(games),
      );

      newGamesResult.fold(
        (failure) => print('获取新游戏失败: ${failure.message}'),
        (games) => allGames.addAll(games),
      );

      // 将分类ID映射到分类名称
      Map<String, String> categoryMap = {};
      categoriesResult.fold((failure) => print('获取分类失败: ${failure.message}'), (
        categories,
      ) {
        for (var category in categories) {
          categoryMap[category.id.toString()] = category.name;
        }
      });

      // 去重
      final Map<String, GameModel> uniqueGames = {};
      for (final game in allGames) {
        uniqueGames[game.id.toString()] = game;
      }

      // 优化的搜索算法
      final searchQuery = query.toLowerCase();

      // 计算每个游戏的搜索相关性分数
      final Map<GameModel, double> gameScores = {};

      for (final game in uniqueGames.values) {
        double score = 0;

        // 名称匹配有最高权重
        if (game.name.toLowerCase() == searchQuery) {
          score += 100; // 完全匹配
        } else if (game.name.toLowerCase().contains(searchQuery)) {
          score += 50; // 部分匹配
        }

        // 描述匹配
        if (game.description.toLowerCase().contains(searchQuery)) {
          score += 30;
        }

        // 玩法说明匹配
        if (game.playDesc.toLowerCase().contains(searchQuery)) {
          score += 20;
        }

        // 分类名称匹配
        final categoryName = categoryMap[game.categoryId]?.toLowerCase() ?? '';
        if (categoryName.contains(searchQuery)) {
          score += 40;
        }

        // 热门和新游戏有额外权重
        if (game.isPopular) {
          score += 10;
        }

        if (game.isNewGame) {
          score += 5;
        }

        // 只有拥有分数的游戏才被视为匹配
        if (score > 0) {
          gameScores[game] = score;
        }
      }

      // 按分数降序排序
      final List<GameModel> searchResults =
          gameScores.keys.toList()
            ..sort((a, b) => gameScores[b]!.compareTo(gameScores[a]!));

      print('搜索结果: ${searchResults.length} 个游戏');

      // 分页返回数据
      final int startIndex = (page - 1) * pageSize;
      final int endIndex = startIndex + pageSize;

      if (startIndex >= searchResults.length) {
        return const Right([]);
      }

      return Right(
        searchResults.sublist(
          startIndex,
          endIndex > searchResults.length ? searchResults.length : endIndex,
        ),
      );
    } on ApiException catch (e) {
      print('搜索游戏失败: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print('搜索游戏意外错误: $e');
      return Left(ServerFailure(message: 'Failed to search games'));
    }
  }
}
