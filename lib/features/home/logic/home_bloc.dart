import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:fkgame/features/home/data/models/game_model.dart';
import 'package:fkgame/features/home/data/repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc(this._homeRepository) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      // 获取推荐游戏
      final recommendedGamesResult =
          await _homeRepository.getRecommendedGames();

      // 获取热门游戏
      final popularGamesResult = await _homeRepository.getPopularGames();

      // 获取新游戏
      final newGamesResult = await _homeRepository.getNewGames();

      // 获取游戏类别
      final categoriesResult = await _homeRepository.getGameCategories();

      // 处理结果
      final recommendedGames = recommendedGamesResult.fold(
        (failure) => <GameModel>[],
        (games) => games,
      );

      final popularGames = popularGamesResult.fold(
        (failure) => <GameModel>[],
        (games) => games,
      );

      final newGames = newGamesResult.fold(
        (failure) => <GameModel>[],
        (games) => games,
      );

      final categories = categoriesResult.fold(
        (failure) => <GameCategoryModel>[],
        (categories) => categories,
      );

      // 检查是否所有请求都失败了
      final allFailed =
          recommendedGames.isEmpty &&
          popularGames.isEmpty &&
          newGames.isEmpty &&
          categories.isEmpty;

      if (allFailed) {
        emit(HomeError(message: 'Failed to load home data'));
      } else {
        emit(
          HomeLoaded(
            recommendedGames: recommendedGames,
            popularGames: popularGames,
            newGames: newGames,
            categories: categories,
          ),
        );
      }
    } catch (e) {
      emit(HomeError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    // 保存当前状态，以便在刷新失败时恢复
    final currentState = state;

    try {
      // 如果当前状态是已加载状态，发送刷新状态
      if (currentState is HomeLoaded) {
        emit(
          HomeRefreshing(
            recommendedGames: currentState.recommendedGames,
            popularGames: currentState.popularGames,
            newGames: currentState.newGames,
            categories: currentState.categories,
          ),
        );
      } else {
        emit(HomeLoading());
      }

      // 获取各类数据
      final recommendedGamesResult =
          await _homeRepository.getRecommendedGames();
      final popularGamesResult = await _homeRepository.getPopularGames();
      final newGamesResult = await _homeRepository.getNewGames();
      final categoriesResult = await _homeRepository.getGameCategories();

      // 处理结果
      final recommendedGames = recommendedGamesResult.fold(
        (failure) =>
            currentState is HomeLoaded
                ? currentState.recommendedGames
                : <GameModel>[],
        (games) => games,
      );

      final popularGames = popularGamesResult.fold(
        (failure) =>
            currentState is HomeLoaded
                ? currentState.popularGames
                : <GameModel>[],
        (games) => games,
      );

      final newGames = newGamesResult.fold(
        (failure) =>
            currentState is HomeLoaded ? currentState.newGames : <GameModel>[],
        (games) => games,
      );

      final categories = categoriesResult.fold(
        (failure) =>
            currentState is HomeLoaded
                ? currentState.categories
                : <GameCategoryModel>[],
        (categories) => categories,
      );

      emit(
        HomeLoaded(
          recommendedGames: recommendedGames,
          popularGames: popularGames,
          newGames: newGames,
          categories: categories,
        ),
      );
    } catch (e) {
      // 如果刷新失败，回到当前状态
      if (currentState is HomeLoaded) {
        emit(currentState);
      } else {
        emit(HomeError(message: 'Failed to refresh home data'));
      }
    }
  }
}
