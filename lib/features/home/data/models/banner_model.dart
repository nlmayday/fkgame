import 'package:equatable/equatable.dart';
import 'package:fkgame/core/models/game_model.dart';

/// 轮播图模型
class BannerModel extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String img;
  final String bgImg;
  final int sort;
  final String link;
  final int gameId;
  final GameModel? game;

  const BannerModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.img,
    required this.bgImg,
    required this.sort,
    required this.link,
    required this.gameId,
    this.game,
  });

  /// 从JSON创建轮播图模型
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      img: json['img'],
      bgImg: json['bgImg'],
      sort: json['sort'],
      link: json['link'] ?? '',
      gameId: json['gameId'],
      game: json['game'] != null ? GameModel.fromJson(json['game']) : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    img,
    bgImg,
    sort,
    link,
    gameId,
    game,
  ];
}
