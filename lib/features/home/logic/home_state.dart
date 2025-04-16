part of 'home_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fkgame/features/home/data/models/game_model.dart';

@immutable
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeRefreshing extends HomeState {}

class HomeLoaded extends HomeState {
  final List<GameModel> recommendedGames;
  final List<GameModel> popularGames;
  final List<GameModel> newGames;
  final List<GameCategoryModel> categories;

  HomeLoaded({
    required this.recommendedGames,
    required this.popularGames,
    required this.newGames,
    required this.categories,
  });

  @override
  List<Object?> get props => [
    recommendedGames,
    popularGames,
    newGames,
    categories,
  ];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
