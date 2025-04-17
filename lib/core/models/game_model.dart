import 'package:equatable/equatable.dart';

/// 游戏模型类
class GameModel extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final String playDesc;
  final int likes;
  final int playTimes;
  final String categoryId;
  final int sort;
  final int isHot;
  final int isNew;
  final String bigImage;
  final String smallImage;
  final String link;
  final int showType;

  const GameModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.playDesc,
    required this.likes,
    required this.playTimes,
    required this.categoryId,
    required this.sort,
    required this.isHot,
    required this.isNew,
    required this.bigImage,
    required this.smallImage,
    required this.link,
    required this.showType,
  });

  /// 从JSON创建游戏模型
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      name: json['name'],
      description: json['desc'] ?? '',
      playDesc: json['playDesc'] ?? '',
      likes: json['likes'] ?? 0,
      playTimes: json['playTimes'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      sort: json['sort'] ?? 0,
      isHot: json['isHot'] ?? 0,
      isNew: json['is'] ?? 0,
      bigImage: json['bigImage'] ?? '',
      smallImage: json['smallImage'] ?? '',
      link: json['link'] ?? '',
      showType: json['showType'] ?? 0,
    );
  }

  /// 获取封面图
  String get coverImage =>
      bigImage.startsWith('http')
          ? bigImage
          : 'https://static.madlygame.com/$bigImage';

  /// 是否热门
  bool get isPopular => isHot == 1;

  /// 是否为新游戏
  bool get isNewGame => isNew == 1;

  /// 获取评分（根据喜欢数转换）
  double get rating {
    if (likes < 1000) return 3.0;
    if (likes < 5000) return 3.5;
    if (likes < 10000) return 4.0;
    if (likes < 20000) return 4.5;
    return 5.0;
  }

  /// 获取游戏分类ID列表
  List<String> get categories {
    if (categoryId.isEmpty) return [];
    return categoryId
        .replaceAll(',', ' ')
        .trim()
        .split(' ')
        .where((id) => id.isNotEmpty)
        .toList();
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    name,
    description,
    playDesc,
    likes,
    playTimes,
    categoryId,
    sort,
    isHot,
    isNew,
    bigImage,
    smallImage,
    link,
    showType,
  ];
}

/// 游戏类别模型
class GameCategoryModel extends Equatable {
  final String id;
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
      id: json['id'].toString(),
      name: json['name'],
      icon: json['icon'],
      description: json['description'] ?? '',
      games:
          (json['games'] as List?)
              ?.map((game) => GameModel.fromJson(game))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [id, name, icon, description, games];
}
