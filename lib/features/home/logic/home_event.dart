part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// 加载首页数据事件
class LoadHomeData extends HomeEvent {}

/// 刷新首页数据事件
class RefreshHomeData extends HomeEvent {}

/// 加载分类游戏事件
class LoadCategoryGames extends HomeEvent {
  final String categoryId;
  final int page;
  final int pageSize;

  LoadCategoryGames({
    required this.categoryId,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [categoryId, page, pageSize];
}

/// 切换分类事件
class SwitchCategory extends HomeEvent {
  final String categoryId;

  SwitchCategory({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

/// 搜索游戏事件
class SearchGames extends HomeEvent {
  final String query;

  SearchGames({required this.query});

  @override
  List<Object?> get props => [query];
}

/// 清除搜索结果事件
class ClearSearch extends HomeEvent {}

/// 加载所有游戏事件
class LoadAllGames extends HomeEvent {
  final String type; // "recommended", "popular", "new"
  final int page;
  final int pageSize;

  LoadAllGames({required this.type, this.page = 1, this.pageSize = 20});

  @override
  List<Object?> get props => [type, page, pageSize];
}
