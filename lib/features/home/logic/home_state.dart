part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// 初始状态
class HomeInitial extends HomeState {}

/// 加载中状态
class HomeLoading extends HomeState {}

/// 刷新中状态
class HomeRefreshing extends HomeState {
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<GameModel> hotGames;
  final List<GameModel> newGames;
  final List<GameModel> categoryGames;
  final String currentCategoryId;

  HomeRefreshing({
    required this.banners,
    required this.categories,
    required this.hotGames,
    required this.newGames,
    required this.categoryGames,
    required this.currentCategoryId,
  });

  @override
  List<Object?> get props => [
    banners,
    categories,
    hotGames,
    newGames,
    categoryGames,
    currentCategoryId,
  ];
}

/// 加载完成状态
class HomeLoaded extends HomeState {
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<GameModel> hotGames;
  final List<GameModel> newGames;
  final List<GameModel> categoryGames;
  final String currentCategoryId;

  HomeLoaded({
    required this.banners,
    required this.categories,
    required this.hotGames,
    required this.newGames,
    required this.categoryGames,
    required this.currentCategoryId,
  });

  @override
  List<Object?> get props => [
    banners,
    categories,
    hotGames,
    newGames,
    categoryGames,
    currentCategoryId,
  ];
}

/// 搜索状态
class SearchState extends HomeState {
  final List<GameModel> searchResults;
  final String query;
  final bool isLoading;

  SearchState({
    required this.searchResults,
    required this.query,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [searchResults, query, isLoading];
}

/// 错误状态
class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
