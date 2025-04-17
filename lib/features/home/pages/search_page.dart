import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/core/models/game_model.dart';
import 'package:fkgame/features/home/logic/home_bloc.dart';
import 'package:fkgame/features/home/widgets/game_card.dart';
import 'package:fkgame/l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) return;

    // 提交搜索事件
    context.read<HomeBloc>().add(SearchGames(query: query));
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<HomeBloc>().add(ClearSearch());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: localizations.searchHint,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 14,
            ),
            suffixIcon:
                _showClearButton
                    ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _clearSearch,
                    )
                    : null,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _onSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _onSearch(_searchController.text),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is SearchState) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.searchResults.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: theme.disabledColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.searchNoResults,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.disabledColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            return _buildSearchResults(state.searchResults);
          }

          // 初始状态下显示搜索提示
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: theme.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.searchInputPrompt,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(List<GameModel> games) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          child: GameCard(game: games[index]),
        );
      },
    );
  }
}
