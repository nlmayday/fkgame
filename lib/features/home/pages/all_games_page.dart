import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/core/models/game_model.dart';
import 'package:fkgame/features/home/logic/home_bloc.dart';
import 'package:fkgame/features/home/widgets/game_card.dart';
import 'package:fkgame/l10n/app_localizations.dart';

enum GameListType { recommended, popular, newGames, category }

enum SortOption { newest, popular, highestRated }

class AllGamesPage extends StatefulWidget {
  final GameListType type;
  final String? categoryId;
  final String? categoryName;

  const AllGamesPage({
    Key? key,
    required this.type,
    this.categoryId,
    this.categoryName,
  }) : super(key: key);

  @override
  State<AllGamesPage> createState() => _AllGamesPageState();
}

class _AllGamesPageState extends State<AllGamesPage> {
  late List<GameModel> _games = [];
  late List<GameModel> _filteredGames = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _isListView = false; // Toggle between list and grid view
  bool _isFilterShown = false;
  SortOption _currentSortOption = SortOption.popular;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);

    // 在初始化时加载数据
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterGames();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreGames();
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (widget.type == GameListType.category && widget.categoryId != null) {
      context.read<HomeBloc>().add(
        LoadCategoryGames(
          categoryId: widget.categoryId!,
          page: 1,
          pageSize: 20,
        ),
      );
    } else {
      // Reset games based on type for this demo
      _resetGamesBasedOnType();
    }

    setState(() {
      _isLoading = false;
      _filterGames();
    });

    return;
  }

  // Demo method - in real app, you'd fetch from API
  void _resetGamesBasedOnType() {
    _games = List.from(_games);
    _filterGames();
  }

  void _toggleViewMode() {
    setState(() {
      _isListView = !_isListView;
    });
  }

  void _toggleFilterPanel() {
    setState(() {
      _isFilterShown = !_isFilterShown;
    });
  }

  void _setSortOption(SortOption option) {
    if (_currentSortOption != option) {
      setState(() {
        _currentSortOption = option;
        _sortGames();
      });
    }
  }

  void _sortGames() {
    switch (_currentSortOption) {
      case SortOption.newest:
        _filteredGames.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.popular:
        _filteredGames.sort((a, b) => b.playTimes.compareTo(a.playTimes));
        break;
      case SortOption.highestRated:
        _filteredGames.sort((a, b) => b.likes.compareTo(a.likes));
        break;
    }
  }

  void _filterGames() {
    if (_searchQuery.isEmpty) {
      _filteredGames = List.from(_games);
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredGames =
          _games.where((game) {
            return game.name.toLowerCase().contains(query) ||
                game.description.toLowerCase().contains(query);
          }).toList();
    }

    _sortGames();
  }

  void _loadMoreGames() {
    if (!_isLoading && !_hasError) {
      setState(() {
        _isLoading = true;
      });

      final nextPage = _currentPage + 1;

      if (widget.type == GameListType.category && widget.categoryId != null) {
        context.read<HomeBloc>().add(
          LoadCategoryGames(
            categoryId: widget.categoryId!,
            page: nextPage,
            pageSize: 20,
          ),
        );
      } else {
        String type;
        switch (widget.type) {
          case GameListType.recommended:
          case GameListType.popular:
            type = 'popular';
            break;
          case GameListType.newGames:
            type = 'new';
            break;
          default:
            type = 'popular';
        }

        context.read<HomeBloc>().add(
          LoadAllGames(type: type, page: nextPage, pageSize: 20),
        );
      }

      // For demo purposes, we're simulating loading more games
      // In a real app, you would listen to BLoC state changes
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
          _currentPage = nextPage;

          // Simulate random error for demo purposes (occurs ~20% of the time)
          if (nextPage > 2 && nextPage % 5 == 0) {
            _hasError = true;
            _errorMessage = '加载更多游戏失败，请重试';
            return;
          }

          // For demo purposes only - in real app the BLoC would provide new games
          if (_games.length < 50) {
            // Limit to 50 items for demo
            // Add more games (duplicating existing ones for demo)
            final baseGames = _games.isEmpty ? _games : _games;
            if (baseGames.isNotEmpty) {
              final moreGames =
                  baseGames.take(4).map((game) {
                    return GameModel(
                      id: game.id + 100 * nextPage,
                      createdAt: DateTime.now().subtract(
                        Duration(days: nextPage),
                      ),
                      updatedAt: DateTime.now(),
                      name: '${game.name} (P$nextPage)',
                      description: game.description,
                      playDesc: game.playDesc,
                      likes: game.likes - (nextPage * 100),
                      playTimes: game.playTimes - (nextPage * 500),
                      categoryId: game.categoryId,
                      sort: game.sort,
                      isHot: nextPage > 3 ? 0 : game.isHot,
                      isNew: nextPage < 3 ? 1 : 0,
                      bigImage: game.bigImage,
                      smallImage: game.smallImage,
                      link: game.link,
                      showType: game.showType,
                    );
                  }).toList();

              _games.addAll(moreGames);
              _filterGames();
            }
          }
        });
      });
    }
  }

  void _loadInitialData() {
    if (widget.type == GameListType.category && widget.categoryId != null) {
      context.read<HomeBloc>().add(
        LoadCategoryGames(
          categoryId: widget.categoryId!,
          page: 1,
          pageSize: 20,
        ),
      );
    } else {
      // 根据类型加载不同的游戏
      String type;
      switch (widget.type) {
        case GameListType.recommended:
        case GameListType.popular:
          type = 'popular';
          break;
        case GameListType.newGames:
          type = 'new';
          break;
        default:
          type = 'popular';
      }

      context.read<HomeBloc>().add(
        LoadAllGames(type: type, page: 1, pageSize: 20),
      );
    }
  }

  Widget _buildListTile(GameModel game) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            game.smallImage,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
          ),
        ),
        title: Text(
          game.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              game.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up, size: 16, color: Colors.blue[400]),
                const SizedBox(width: 4),
                Text('${game.likes}'),
                const SizedBox(width: 12),
                Icon(Icons.play_arrow, size: 16, color: Colors.green[400]),
                const SizedBox(width: 4),
                Text('${game.playTimes}'),
                if (game.isNew == 1) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill, color: Colors.blue),
          onPressed: () {
            // Play game action
          },
        ),
        onTap: () {
          // Game details action
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    String title;
    switch (widget.type) {
      case GameListType.recommended:
        title = localizations.recommended;
        break;
      case GameListType.popular:
        title = localizations.popular;
        break;
      case GameListType.newGames:
        title = localizations.newGames;
        break;
      case GameListType.category:
        title = widget.categoryName ?? localizations.games;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(_isListView ? Icons.grid_view : Icons.list),
            onPressed: _toggleViewMode,
            tooltip: _isListView ? 'Grid View' : 'List View',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _toggleFilterPanel,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter panel
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isFilterShown ? 155 : 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search field
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '搜索游戏...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sort options
                    Text(
                      '排序方式:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildSortChip(SortOption.newest, '最新'),
                        const SizedBox(width: 8),
                        _buildSortChip(SortOption.popular, '热门'),
                        const SizedBox(width: 8),
                        _buildSortChip(SortOption.highestRated, '高分'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Game listing
          Expanded(
            child:
                widget.type == GameListType.category &&
                        widget.categoryId != null
                    ? BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoaded) {
                          final categoryGames = state.categoryGames;

                          if (_games.isEmpty && categoryGames.isNotEmpty) {
                            // Initialize games list if we have games from Bloc
                            _games = List.from(categoryGames);
                            _filterGames();
                          }

                          return _buildGamesList(context);
                        }

                        if (state is HomeLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return _buildGamesList(context);
                      },
                    )
                    : _buildGamesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(SortOption option, String label) {
    final isSelected = _currentSortOption == option;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _setSortOption(option);
        }
      },
    );
  }

  Widget _buildGamesList(BuildContext context) {
    if (_filteredGames.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videogame_asset_off,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? '没有可用的游戏' : '没有找到符合条件的游戏',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).disabledColor,
              ),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                },
                child: const Text('清除搜索'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(
        children: [
          Expanded(
            child:
                _isListView
                    ? ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          _filteredGames.length +
                          (_isLoading || _hasError ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _filteredGames.length) {
                          return _buildLoadingOrErrorWidget();
                        }
                        return _buildListTile(_filteredGames[index]);
                      },
                    )
                    : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount:
                          _filteredGames.length +
                          (_isLoading || _hasError ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _filteredGames.length) {
                          return _buildLoadingOrErrorWidget();
                        }
                        return GameCard(game: _filteredGames[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOrErrorWidget() {
    if (_hasError) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _loadMoreGames();
                });
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
