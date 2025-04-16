import 'package:equatable/equatable.dart';

/// 游戏模型类
class GameModel extends Equatable {
  final int id;
  final String name;
  final String coverImage;
  final String description;
  final double rating;
  final int playerCount;
  final bool isNew;
  final bool isPopular;
  final List<String> tags;
  final DateTime releasedAt;

  const GameModel({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.description,
    required this.rating,
    required this.playerCount,
    required this.isNew,
    required this.isPopular,
    required this.tags,
    required this.releasedAt,
  });

  /// 从JSON创建游戏模型
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      name: json['name'],
      coverImage: json['cover_image'],
      description: json['description'],
      rating: json['rating'].toDouble(),
      playerCount: json['player_count'],
      isNew: json['is_new'],
      isPopular: json['is_popular'],
      tags: List<String>.from(json['tags']),
      releasedAt: DateTime.parse(json['released_at']),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cover_image': coverImage,
      'description': description,
      'rating': rating,
      'player_count': playerCount,
      'is_new': isNew,
      'is_popular': isPopular,
      'tags': tags,
      'released_at': releasedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    coverImage,
    description,
    rating,
    playerCount,
    isNew,
    isPopular,
    tags,
    releasedAt,
  ];
}

/// 游戏类别模型
class GameCategoryModel extends Equatable {
  final int id;
  final String name;
  final String icon;
  final String description;
  final List<GameModel> games;

  const GameCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.games,
  });

  /// 从JSON创建类别模型
  factory GameCategoryModel.fromJson(Map<String, dynamic> json) {
    return GameCategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
      games:
          (json['games'] as List)
              .map((game) => GameModel.fromJson(game))
              .toList(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'games': games.map((game) => game.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name, icon, description, games];
}
