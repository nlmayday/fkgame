import 'package:flutter/material.dart';
import 'package:fkgame/features/home/data/models/game_model.dart';
import 'package:fkgame/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetailsPage extends StatelessWidget {
  final GameModel game;

  const GameDetailsPage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Game cover image with back button
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Game cover image
                  Image.network(
                    game.coverImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                game.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Game details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game info card
                  _buildGameInfoCard(context),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    localizations.description,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.description.isNotEmpty
                        ? game.description
                        : localizations.noDescriptionAvailable,
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  // How to play
                  Text(
                    localizations.howToPlay,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.playDesc.isNotEmpty
                        ? game.playDesc
                        : localizations.noPlayInstructionsAvailable,
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 32),

                  // Play button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _launchGameUrl(context),
                      child: Text(
                        localizations.playNow,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Game icon
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              game.smallImage,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image_not_supported)),
                );
              },
            ),
          ),

          const SizedBox(width: 16),

          // Game stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Rating stars
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < game.rating.floor()
                            ? Icons.star
                            : (index < game.rating
                                ? Icons.star_half
                                : Icons.star_border),
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                    const SizedBox(width: 8),
                    Text(
                      game.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Game stats (likes & plays)
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red[400], size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${game.likes}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.gamepad, color: Colors.blue[400], size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${game.playTimes}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchGameUrl(BuildContext context) async {
    if (game.link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).gameUrlNotAvailable),
        ),
      );
      return;
    }

    final Uri uri = Uri.parse(game.link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).couldNotLaunchGameUrl),
          ),
        );
      }
    }
  }
}
