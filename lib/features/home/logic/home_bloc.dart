import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:fkgame/core/models/game_model.dart';
import 'package:fkgame/features/home/data/models/banner_model.dart';
import 'package:fkgame/core/models/category_model.dart';
import 'package:fkgame/features/home/data/repository/home_repository.dart';
import 'package:fkgame/core/repositories/game_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final GameRepository _gameRepository;

  HomeBloc(this._homeRepository, this._gameRepository) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<LoadCategoryGames>(_onLoadCategoryGames);
    on<SwitchCategory>(_onSwitchCategory);
    on<SearchGames>(_onSearchGames);
    on<ClearSearch>(_onClearSearch);
    on<LoadAllGames>(_onLoadAllGames);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      // 获取轮播图
      final banners = await _gameRepository.getBanners();

      // 获取分类列表
      final categories = await _gameRepository.getCategories();

      // 获取热门游戏
      final hotGames = await _gameRepository.getHotGames(page: 1, pageSize: 10);

      // 获取新游戏
      final newGames = await _gameRepository.getNewGames(page: 1, pageSize: 10);

      // 获取默认分类的游戏
      String defaultCategoryId = '';
      if (categories.isNotEmpty) {
        defaultCategoryId = categories.first.id.toString();
      }

      List<GameModel> categoryGames = [];
      if (defaultCategoryId.isNotEmpty) {
        categoryGames = await _gameRepository.getGamesByCategory(
          defaultCategoryId,
          page: 1,
          pageSize: 10,
        );
      }

      // 检查是否所有请求都失败了
      final allFailed =
          banners.isEmpty &&
          categories.isEmpty &&
          hotGames.isEmpty &&
          newGames.isEmpty;

      if (allFailed) {
        emit(HomeError(message: 'Failed to load home data'));
      } else {
        emit(
          HomeLoaded(
            banners: banners,
            categories: categories,
            hotGames: hotGames,
            newGames: newGames,
            categoryGames: categoryGames,
            currentCategoryId: defaultCategoryId,
          ),
        );
      }
    } catch (e) {
      emit(HomeError(message: 'An unexpected error occurred: ${e.toString()}'));
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
            banners: currentState.banners,
            categories: currentState.categories,
            hotGames: currentState.hotGames,
            newGames: currentState.newGames,
            categoryGames: currentState.categoryGames,
            currentCategoryId: currentState.currentCategoryId,
          ),
        );
      } else {
        emit(HomeLoading());
      }

      // 获取各类数据，使用刷新参数
      final banners = await _gameRepository.getBanners(refresh: true);
      final categories = await _gameRepository.getCategories();
      final hotGames = await _gameRepository.getHotGames(
        refresh: true,
        page: 1,
        pageSize: 10,
      );
      final newGames = await _gameRepository.getNewGames(
        refresh: true,
        page: 1,
        pageSize: 10,
      );

      // 获取当前分类的游戏
      String currentCategoryId = '';
      if (currentState is HomeLoaded) {
        currentCategoryId = currentState.currentCategoryId;
      } else if (categories.isNotEmpty) {
        currentCategoryId = categories.first.id.toString();
      }

      List<GameModel> categoryGames = [];
      if (currentCategoryId.isNotEmpty) {
        categoryGames = await _gameRepository.getGamesByCategory(
          currentCategoryId,
          refresh: true,
          page: 1,
          pageSize: 10,
        );
      }

      emit(
        HomeLoaded(
          banners: banners,
          categories: categories,
          hotGames: hotGames,
          newGames: newGames,
          categoryGames: categoryGames,
          currentCategoryId: currentCategoryId,
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

  Future<void> _onLoadCategoryGames(
    LoadCategoryGames event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) {
      // If not already in HomeLoaded state, load initial data first
      await _onLoadHomeData(LoadHomeData(), emit);
      // Get the updated state after initial load
      if (state is! HomeLoaded) return;
    }

    final HomeLoaded loadedState = state as HomeLoaded;

    try {
      // Emit a loading state with the current data
      emit(
        HomeLoaded(
          banners: loadedState.banners,
          categories: loadedState.categories,
          hotGames: loadedState.hotGames,
          newGames: loadedState.newGames,
          categoryGames:
              loadedState.categoryGames, // Keep existing games while loading
          currentCategoryId: event.categoryId, // Update the current category
        ),
      );

      final categoryGames = await _gameRepository.getGamesByCategory(
        event.categoryId,
        refresh: true,
        page: event.page,
        pageSize: event.pageSize,
      );

      // Emit updated state with the new category games
      emit(
        HomeLoaded(
          banners: loadedState.banners,
          categories: loadedState.categories,
          hotGames: loadedState.hotGames,
          newGames: loadedState.newGames,
          categoryGames: categoryGames,
          currentCategoryId: event.categoryId,
        ),
      );
    } catch (e) {
      // If loading fails, keep the current state
      emit(loadedState);
    }
  }

  void _onSwitchCategory(SwitchCategory event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    // 切换分类后，立即加载该分类的游戏
    add(LoadCategoryGames(categoryId: event.categoryId));
  }

  Future<void> _onSearchGames(
    SearchGames event,
    Emitter<HomeState> emit,
  ) async {
    // 首先发出加载中状态
    emit(SearchState(searchResults: [], query: event.query, isLoading: true));

    try {
      // 调用仓库的搜索方法
      final searchResults = await _gameRepository.searchGames(
        event.query,
        page: 1,
        pageSize: 20,
      );

      // 更新状态为搜索结果
      emit(
        SearchState(
          searchResults: searchResults,
          query: event.query,
          isLoading: false,
        ),
      );
    } catch (e) {
      // 搜索失败，显示空结果
      emit(
        SearchState(searchResults: [], query: event.query, isLoading: false),
      );
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<HomeState> emit) {
    // 如果之前是HomeLoaded状态，则恢复该状态
    final previousState = state;
    if (previousState is HomeLoaded) {
      emit(previousState);
    } else if (previousState is SearchState) {
      // 否则重新加载首页数据
      add(LoadHomeData());
    }
  }

  Future<void> _onLoadAllGames(
    LoadAllGames event,
    Emitter<HomeState> emit,
  ) async {
    try {
      List<GameModel> games = [];

      switch (event.type) {
        case 'recommended':
        case 'popular':
          games = await _gameRepository.getHotGames(
            page: event.page,
            pageSize: event.pageSize,
          );
          break;
        case 'new':
          games = await _gameRepository.getNewGames(
            page: event.page,
            pageSize: event.pageSize,
          );
          break;
        default:
          break;
      }

      // 在实际应用中，会有专门的状态来处理这些数据
      // 这里简单起见，只是获取数据，实际显示逻辑在页面中实现
      print('加载更多游戏: ${event.type}, 页码: ${event.page}, 数量: ${games.length}');
    } catch (e) {
      print('加载更多游戏失败: $e');
    }
  }
}
