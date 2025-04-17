import 'package:flutter/material.dart';
import 'package:fkgame/features/home/data/models/game_model.dart';
import 'package:fkgame/features/gameplay/game/pages/game_details_page.dart';

class GameCard extends StatelessWidget {
  final GameModel game;
  final bool isLarge;

  const GameCard({Key? key, required this.game, this.isLarge = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = isLarge ? 280.0 : 160.0;
    final height = isLarge ? 200.0 : 160.0;
    final imageHeight = isLarge ? 140.0 : 100.0;

    return GestureDetector(
      onTap: () => _navigateToGameDetails(context),
      child: Container(
        width: width,
        height: height,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 游戏封面
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.network(
                game.coverImage,
                width: width,
                height: imageHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: width,
                    height: imageHeight,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),

            // 游戏信息
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 游戏名称
                    Text(
                      game.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // 游戏评分和玩家数
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber[600]),
                        const SizedBox(width: 2),
                        Text(
                          game.rating.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.people_outline,
                          size: 14,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _formatPlayerCount(game.playTimes),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPlayerCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }

  void _navigateToGameDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameDetailsPage(game: game)),
    );
  }
}
