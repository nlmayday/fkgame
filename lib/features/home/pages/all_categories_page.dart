import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/features/home/data/models/game_model.dart';
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

  // 类别分组
  final Map<String, List<String>> _categoryGroups = {
    '动作游戏': ['动作', '射击', '格斗', '冒险'],
    '益智游戏': ['益智', '解谜', '卡牌', '策略'],
    '休闲游戏': ['休闲', '模拟', '音乐'],
    '体育游戏': ['体育', '赛车', '竞技'],
    '角色扮演': ['RPG', '角色', '剧情'],
  };

  // 当前选中的组
  String? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _filteredCategories = List.from(widget.categories);
    _searchController.addListener(_onSearchChanged);
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
                hintText: '搜索游戏类别...',
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
                _buildGroupChip(null, '全部'),
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
                            '没有找到相关游戏类别',
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
                              child: const Text('清除筛选'),
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
                              SwitchCategory(
                                categoryId: _filteredCategories[index].id,
                              ),
                            );

                            // Navigate to the games page for this category
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AllGamesPage(
                                      games: [],
                                      type: GameListType.category,
                                      categoryId: _filteredCategories[index].id,
                                      categoryName:
                                          _filteredCategories[index].name,
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
