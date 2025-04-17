import 'package:equatable/equatable.dart';

/// 游戏分类模型
class CategoryModel extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String icon;
  final int sort;

  const CategoryModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.icon,
    required this.sort,
  });

  /// 从JSON创建分类模型
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      name: json['name'],
      icon: json['icon'],
      sort: json['sort'],
    );
  }

  @override
  List<Object?> get props => [id, createdAt, updatedAt, name, icon, sort];
}
