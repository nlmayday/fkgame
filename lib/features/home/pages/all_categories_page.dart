import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:fkgame/core/models/game_model.dart';
import 'package:fkgame/core/repositories/game_repository.dart';
import 'package:fkgame/features/home/logic/home_bloc.dart';
import 'package:fkgame/features/home/widgets/game_category_card.dart';
import 'package:fkgame/l10n/app_localizations.dart';
import 'package:fkgame/features/home/pages/all_games_page.dart';

class AllCategoriesPage extends StatefulWidget {
  final List<GameCategoryModel> categories;

  const AllCategoriesPage({Key? key, required this.categories})
    : super(key: key);

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  late List<GameCategoryModel> _filteredCategories;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // 类别分组 - 从仓库获取
  late Map<String, List<String>> _categoryGroups;

  // 当前选中的组
  String? _selectedGroup;

  // 游戏仓库
  final GameRepository _gameRepository = GetIt.instance<GameRepository>();

  @override
  void initState() {
    super.initState();
    _filteredCategories = List.from(widget.categories);
    _searchController.addListener(_onSearchChanged);

    // 从仓库获取分类分组
    _categoryGroups = _gameRepository.getCategoryGroups();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterCategories(_searchController.text);
  }

  void _filterCategories(String query) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty && _selectedGroup == null) {
        _filteredCategories = List.from(widget.categories);
      } else {
        _filteredCategories =
            widget.categories.where((category) {
              bool matchesSearch =
                  query.isEmpty ||
                  category.name.toLowerCase().contains(query.toLowerCase());

              bool matchesGroup =
                  _selectedGroup == null ||
                  _categoryGroups[_selectedGroup!]?.any(
                        (keyword) => category.name.toLowerCase().contains(
                          keyword.toLowerCase(),
                        ),
                      ) ==
                      true;

              return matchesSearch && matchesGroup;
            }).toList();
      }
    });
  }

  void _selectGroup(String? group) {
    setState(() {
      _selectedGroup = _selectedGroup == group ? null : group;
      _filterCategories(_searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.games)),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations.searchGameCategories,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                        : null,
              ),
            ),
          ),

          // 分组筛选
          SizedBox(
            height: 50,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _buildGroupChip(null, localizations.allCategories),
                ..._categoryGroups.keys.map(
                  (group) => _buildGroupChip(group, group),
                ),
              ],
            ),
          ),

          const Divider(),

          // 类别列表
          Expanded(
            child:
                _filteredCategories.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 64,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.noGameCategoriesFound,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty ||
                              _selectedGroup != null) ...[
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _selectedGroup = null;
                                  _filteredCategories = List.from(
                                    widget.categories,
                                  );
                                });
                              },
                              child: Text(localizations.clearFilters),
                            ),
                          ],
                        ],
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.9,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        return GameCategoryCard(
                          category: _filteredCategories[index],
                          onTap: () {
                            // Load games for this category
                            context.read<HomeBloc>().add(
                              LoadCategoryGames(
                                categoryId:
                                    _filteredCategories[index].id.toString(),
                              ),
                            );

                            // Navigate to the games page for this category
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider.value(
                                      value: context.read<HomeBloc>(),
                                      child: AllGamesPage(
                                        type: GameListType.category,
                                        categoryId:
                                            _filteredCategories[index].id
                                                .toString(),
                                        categoryName:
                                            _filteredCategories[index].name,
                                      ),
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupChip(String? group, String label) {
    final isSelected = _selectedGroup == group;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => _selectGroup(group),
        backgroundColor: Colors.grey[200],
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
