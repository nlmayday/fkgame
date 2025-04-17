import 'package:flutter/material.dart';
import 'package:fkgame/features/home/data/models/game_model.dart';

class GameCategoryCard extends StatelessWidget {
  final GameCategoryModel category;
  final VoidCallback? onTap;

  const GameCategoryCard({Key? key, required this.category, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 类别图标
            Icon(
              _getCategoryIcon(category.icon),
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            // 类别名称
            Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // 游戏数量
            Text(
              '${category.games.length} games',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String icon) {
    // 根据类别图标字符串返回对应的图标
    switch (icon) {
      case 'action':
        return Icons.sports_martial_arts;
      case 'adventure':
        return Icons.explore;
      case 'strategy':
        return Icons.psychology;
      case 'puzzle':
        return Icons.extension;
      case 'sports':
        return Icons.sports_soccer;
      case 'racing':
        return Icons.directions_car;
      case 'shooter':
        return Icons.sports_esports;
      case 'arcade':
        return Icons.videogame_asset;
      default:
        return Icons.games;
    }
  }
}
