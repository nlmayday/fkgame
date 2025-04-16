import 'package:dartz/dartz.dart';

import 'package:fkgame/core/error/failures.dart';
import 'package:fkgame/core/network/api/client.dart';
import 'package:fkgame/features/home/data/models/game_model.dart';

/// 首页仓库接口
abstract class HomeRepository {
  /// 获取推荐游戏列表
  Future<Either<Failure, List<GameModel>>> getRecommendedGames();

  /// 获取热门游戏列表
  Future<Either<Failure, List<GameModel>>> getPopularGames();

  /// 获取新游戏列表
  Future<Either<Failure, List<GameModel>>> getNewGames();

  /// 获取游戏类别列表
  Future<Either<Failure, List<GameCategoryModel>>> getGameCategories();
}

/// 首页仓库实现
class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<GameModel>>> getRecommendedGames() async {
    try {
      final response = await _apiClient.get('/games/recommended');
      final games =
          (response as List).map((game) => GameModel.fromJson(game)).toList();
      return Right(games);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get recommended games'));
    }
  }

  @override
  Future<Either<Failure, List<GameModel>>> getPopularGames() async {
    try {
      final response = await _apiClient.get('/games/popular');
      final games =
          (response as List).map((game) => GameModel.fromJson(game)).toList();
      return Right(games);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get popular games'));
    }
  }

  @override
  Future<Either<Failure, List<GameModel>>> getNewGames() async {
    try {
      final response = await _apiClient.get('/games/new');
      final games =
          (response as List).map((game) => GameModel.fromJson(game)).toList();
      return Right(games);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get new games'));
    }
  }

  @override
  Future<Either<Failure, List<GameCategoryModel>>> getGameCategories() async {
    try {
      final response = await _apiClient.get('/games/categories');
      final categories =
          (response as List)
              .map((category) => GameCategoryModel.fromJson(category))
              .toList();
      return Right(categories);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get game categories'));
    }
  }
}
