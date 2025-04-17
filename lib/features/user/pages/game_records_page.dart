import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/features/auth/data/models/user_model.dart';
import 'package:fkgame/core/widgets/app_bar_with_logout.dart';
import 'package:fkgame/core/services/mock_service.dart';
import 'package:intl/intl.dart';
import 'package:fkgame/core/models/game_model.dart';

class GameRecordsPage extends StatefulWidget {
  const GameRecordsPage({Key? key}) : super(key: key);

  @override
  State<GameRecordsPage> createState() => _GameRecordsPageState();
}

class _GameRecordsPageState extends State<GameRecordsPage> {
  final MockService _mockService = MockService();
  List<Map<String, dynamic>> _gameHistory = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = '全部';

  @override
  void initState() {
    super.initState();
    _loadGameHistory();
  }

  void _loadGameHistory() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authState = context.read<AuthCubit>().state;
      if (authState.user != null) {
        // In a real app, this would fetch from an API or database
        // For now, we'll generate mock data
        try {
          _generateMockGameHistory();

          if (_gameHistory.isEmpty) {
            // If we still don't have data, set a specific error message
            _errorMessage = '无法加载游戏记录，请稍后再试';
          }
        } catch (e) {
          print('Error generating mock game history: $e');
          _errorMessage = '生成游戏记录时出错: $e';
        }
      } else {
        _errorMessage = '无法获取用户信息';
      }
    } catch (e) {
      print('Error in _loadGameHistory: $e');
      _errorMessage = '加载失败: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _generateMockGameHistory() {
    // Get some games from mock service to use in history
    // Since getGameList() doesn't exist, use getHotGames() instead
    final games = _mockService.getHotGames();

    final List<GameModel> gamesList =
        games.isEmpty
            ? _createFallbackGames() // Create fallback games if no games are returned
            : games;

    if (gamesList.isEmpty) {
      _gameHistory = [];
      return;
    }

    final now = DateTime.now();

    final List<Map<String, dynamic>> history = [];

    // Generate 20 mock game records
    for (int i = 0; i < 20; i++) {
      final game = gamesList[i % gamesList.length];
      final isWin = i % 3 != 0; // 2/3 chance of winning
      final points = (i + 1) * 50;
      final pointsBefore = 1000 + (i * 20);
      final pointsAfter = isWin ? pointsBefore + points : pointsBefore - points;
      // Generate a random difficulty level from 1-5
      final gameDifficulty = (i % 5) + 1;

      history.add({
        'id': 'game_${now.millisecondsSinceEpoch - i * 10000000}',
        'game': game,
        'playedAt': DateTime(
          now.year,
          now.month,
          now.day - (i ~/ 3),
          now.hour - (i % 24),
          now.minute - (i % 60),
        ),
        'duration': (i % 5 + 1) * 15, // Duration in minutes
        'isWin': isWin,
        'points': points,
        'pointsBefore': pointsBefore,
        'pointsAfter': pointsAfter,
        'pointsDelta': isWin ? points : -points,
        'difficulty': gameDifficulty,
        'opponent':
            i % 2 == 0
                ? null
                : {
                  'name': '玩家${i + 100}',
                  'avatar':
                      'https://randomuser.me/api/portraits/men/${i % 50}.jpg',
                  'level': (i % 10) + 1,
                },
      });
    }

    _gameHistory = history;
  }

  /// Creates fallback game data when the mock service doesn't return any games
  List<GameModel> _createFallbackGames() {
    final List<GameModel> fallbackGames = [];
    final now = DateTime.now();

    // Game names
    final gameNames = [
      '三消娱乐',
      '飞机大战',
      '赛车竞速',
      '俄罗斯方块',
      '象棋对战',
      '斗地主',
      '麻将',
      '跑得快',
      '台球挑战',
      '水果连连看',
    ];

    // Game descriptions
    final descriptions = [
      '经典三消游戏，简单易上手',
      '控制飞机击落敌人，躲避障碍物',
      '紧张刺激的赛车游戏',
      '经典俄罗斯方块，挑战自我',
      '中国象棋对战，考验战略思维',
      '经典的扑克牌游戏',
      '传统麻将游戏',
      '快节奏的纸牌游戏',
      '模拟台球游戏',
      '连接相同的水果，获取高分',
    ];

    // Create 10 mock games
    for (int i = 0; i < 10; i++) {
      fallbackGames.add(
        GameModel(
          id: 1000 + i,
          createdAt: now.subtract(Duration(days: i * 7)),
          updatedAt: now.subtract(Duration(days: i * 7 - 1)),
          name: gameNames[i],
          description: descriptions[i],
          playDesc: '点击开始游戏',
          likes: 1000 * (10 - i),
          playTimes: 5000 * (10 - i),
          categoryId: '${(i % 5) + 1}',
          sort: i + 1,
          isHot: i < 3 ? 1 : 0,
          isNew: i > 7 ? 1 : 0,
          bigImage: 'https://picsum.photos/800/400?random=${1000 + i}',
          smallImage: 'https://picsum.photos/400/200?random=${1000 + i}',
          link: 'https://example.com/game/${1000 + i}',
          showType: 1,
        ),
      );
    }

    return fallbackGames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLogout(
        title: '游戏记录',
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGameHistory,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_gameHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_esports, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '暂无游戏记录',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to previous page
              },
              child: const Text('去游戏'),
            ),
          ],
        ),
      );
    }

    // Apply filter if needed
    List<Map<String, dynamic>> filteredHistory = _gameHistory;
    if (_selectedFilter == '胜利') {
      filteredHistory =
          _gameHistory.where((game) => game['isWin'] == true).toList();
    } else if (_selectedFilter == '失败') {
      filteredHistory =
          _gameHistory.where((game) => game['isWin'] == false).toList();
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadGameHistory();
      },
      child: Column(
        children: [
          _buildStatisticsCard(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildFilterChips(),
                const SizedBox(height: 16),
                _buildGamesList(filteredHistory),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    // Calculate statistics
    int totalGames = _gameHistory.length;
    int winGames = _gameHistory.where((game) => game['isWin'] == true).length;
    int lossGames = totalGames - winGames;
    double winRate = totalGames > 0 ? (winGames / totalGames) * 100 : 0;

    int totalPointsGained = _gameHistory
        .where((game) => game['pointsDelta'] > 0)
        .fold(0, (sum, game) => sum + (game['pointsDelta'] as int));

    int totalPointsLost = _gameHistory
        .where((game) => game['pointsDelta'] < 0)
        .fold(0, (sum, game) => sum + (game['pointsDelta'] as int).abs());

    int netPoints = totalPointsGained - totalPointsLost;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '游戏战绩',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('总场次', '$totalGames', Colors.blue),
                _buildStatColumn('胜利', '$winGames', Colors.green),
                _buildStatColumn('失败', '$lossGames', Colors.red),
                _buildStatColumn(
                  '胜率',
                  '${winRate.toStringAsFixed(1)}%',
                  winRate >= 50 ? Colors.green : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPointsStatItem('累计获得', totalPointsGained, Colors.green),
                const SizedBox(width: 8),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                const SizedBox(width: 8),
                _buildPointsStatItem('累计损失', totalPointsLost, Colors.red),
                const SizedBox(width: 8),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                const SizedBox(width: 8),
                _buildPointsStatItem(
                  '净收益',
                  netPoints,
                  netPoints >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPointsStatItem(String label, int points, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Row(
          children: [
            Icon(
              points >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '${points.abs()}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('全部'),
          const SizedBox(width: 8),
          _buildFilterChip('胜利'),
          const SizedBox(width: 8),
          _buildFilterChip('失败'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? label : '全部';
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildGamesList(List<Map<String, dynamic>> games) {
    // Group games by day
    Map<String, List<Map<String, dynamic>>> gamesByDay = {};

    for (final game in games) {
      final date = game['playedAt'] as DateTime;
      final dayKey = DateFormat('yyyy-MM-dd').format(date);

      if (!gamesByDay.containsKey(dayKey)) {
        gamesByDay[dayKey] = [];
      }

      gamesByDay[dayKey]!.add(game);
    }

    // Sort days in descending order
    final sortedDays = gamesByDay.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final day in sortedDays) ...[
          _buildDayHeader(day),
          ...gamesByDay[day]!.map((game) => _buildGameItem(game)).toList(),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildDayHeader(String day) {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday = DateFormat(
      'yyyy-MM-dd',
    ).format(now.subtract(const Duration(days: 1)));

    String displayText;
    if (day == today) {
      displayText = '今天';
    } else if (day == yesterday) {
      displayText = '昨天';
    } else {
      final date = DateTime.parse(day);
      displayText = DateFormat('MM月dd日').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        displayText,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildGameItem(Map<String, dynamic> game) {
    final GameModel gameModel = game['game'] as GameModel;
    final bool isWin = game['isWin'] as bool;
    final DateTime playedAt = game['playedAt'] as DateTime;
    final int duration = game['duration'] as int;
    final int pointsBefore = game['pointsBefore'] as int;
    final int pointsAfter = game['pointsAfter'] as int;
    final int pointsDelta = game['pointsDelta'] as int;
    final int difficulty = game['difficulty'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showGameDetails(context, game),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      gameModel.smallImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gameModel.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('HH:mm').format(playedAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.timer,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$duration 分钟',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(difficulty),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getDifficultyText(difficulty),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            if (game['opponent'] != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 10,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '对战',
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isWin ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          isWin ? '胜利' : '失败',
                          style: TextStyle(
                            color: isWin ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pointsDelta >= 0 ? '+$pointsDelta' : '$pointsDelta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: pointsDelta >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '游戏点变化',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$pointsBefore',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$pointsAfter',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: pointsDelta >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return '简单';
      case 2:
        return '普通';
      case 3:
        return '困难';
      case 4:
        return '专家';
      case 5:
        return '大师';
      default:
        return '未知';
    }
  }

  void _showGameDetails(BuildContext context, Map<String, dynamic> game) {
    final GameModel gameModel = game['game'] as GameModel;
    final bool isWin = game['isWin'] as bool;
    final DateTime playedAt = game['playedAt'] as DateTime;
    final int duration = game['duration'] as int;
    final int pointsBefore = game['pointsBefore'] as int;
    final int pointsAfter = game['pointsAfter'] as int;
    final int pointsDelta = game['pointsDelta'] as int;
    final int difficulty = game['difficulty'] as int;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('游戏详情'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      gameModel.smallImage,
                      width: 120,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('游戏名称', gameModel.name),
                _buildDetailRow(
                  '游戏结果',
                  isWin ? '胜利' : '失败',
                  textColor: isWin ? Colors.green : Colors.red,
                ),
                _buildDetailRow(
                  '游戏时间',
                  DateFormat('yyyy-MM-dd HH:mm').format(playedAt),
                ),
                _buildDetailRow('游戏时长', '$duration 分钟'),
                _buildDetailRow('难度级别', _getDifficultyText(difficulty)),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                _buildDetailRow('游戏点变化', ''),
                _buildPointsChangeRow(pointsBefore, pointsAfter, pointsDelta),
                if (game['opponent'] != null) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildDetailRow('对手信息', ''),
                  _buildOpponentInfo(game['opponent']),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // 假设实现共享战绩的功能
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('分享战绩功能将在后续版本推出')));
              },
              child: const Text('分享战绩'),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsChangeRow(int before, int after, int delta) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 80),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$before', style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Icon(
                  delta >= 0 ? Icons.arrow_forward : Icons.arrow_forward,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  '$after',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: delta >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: delta >= 0 ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    delta >= 0 ? '+$delta' : '$delta',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: delta >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpponentInfo(Map<String, dynamic> opponent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 80),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(opponent['avatar']),
                onBackgroundImageError:
                    (exception, stackTrace) => const Icon(Icons.person),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opponent['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'LV.${opponent['level']}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '筛选游戏记录',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('全部时间'),
                onTap: () {
                  Navigator.pop(context);
                  // 筛选逻辑
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('筛选功能将在后续版本推出')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.videogame_asset),
                title: const Text('按游戏类型'),
                onTap: () {
                  Navigator.pop(context);
                  // 筛选逻辑
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('筛选功能将在后续版本推出')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('只看对战'),
                onTap: () {
                  Navigator.pop(context);
                  // 筛选逻辑
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('筛选功能将在后续版本推出')));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
