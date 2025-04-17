import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:fkgame/core/models/game_model.dart';
import 'package:fkgame/core/repositories/game_repository.dart';

class GameCategoryCard extends StatefulWidget {
  final GameCategoryModel category;
  final VoidCallback? onTap;

  const GameCategoryCard({Key? key, required this.category, this.onTap})
    : super(key: key);

  @override
  State<GameCategoryCard> createState() => _GameCategoryCardState();
}

class _GameCategoryCardState extends State<GameCategoryCard> {
  final GameRepository _gameRepository = GetIt.instance<GameRepository>();
  int? _gameCount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGameCount();
  }

  Future<void> _loadGameCount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final count = await _gameRepository.getCategoryGameCount(
        widget.category.id,
      );
      if (mounted) {
        setState(() {
          _gameCount = count;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _gameCount = null;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
              _getCategoryIcon(widget.category.icon),
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            // 类别名称
            Text(
              widget.category.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // 游戏数量
            _isLoading
                ? const SizedBox(
                  height: 12,
                  width: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Text(
                  _gameCount != null
                      ? '$_gameCount 个游戏'
                      : '${widget.category.games.length} 个游戏',
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
