import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/features/auth/data/models/user_model.dart';
import 'package:fkgame/core/widgets/app_bar_with_logout.dart';
import 'package:fkgame/l10n/app_localizations.dart';
import 'package:fkgame/core/constants/transaction_type.dart';
import 'package:intl/intl.dart';

class CoinHistoryPage extends StatefulWidget {
  const CoinHistoryPage({Key? key}) : super(key: key);

  @override
  State<CoinHistoryPage> createState() => _CoinHistoryPageState();
}

class _CoinHistoryPageState extends State<CoinHistoryPage> {
  List<Map<String, dynamic>> _coinHistory = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = '全部';

  @override
  void initState() {
    super.initState();
    _loadCoinHistory();
  }

  void _loadCoinHistory() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authState = context.read<AuthCubit>().state;
      if (authState.user != null) {
        // In a real app, this would fetch from an API or database
        // For now, we'll generate mock data
        _generateMockCoinHistory();
      } else {
        _errorMessage = '无法获取用户信息';
      }
    } catch (e) {
      print('Error in _loadCoinHistory: $e');
      _errorMessage = '加载失败: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _generateMockCoinHistory() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> history = [];

    // 所有交易类型
    final List<TransactionType> transactionTypes = TransactionType.values;

    // 用于记录模拟的当前金币数量
    int currentCoins = 2000;

    // 生成50条模拟交易记录
    for (int i = 0; i < 50; i++) {
      // 随机选择一个交易类型
      final typeIndex = i % transactionTypes.length;
      final transactionType = transactionTypes[typeIndex];

      // 根据交易类型确定金币变动
      int coinDelta;
      String details;

      switch (transactionType) {
        case TransactionType.gameWin:
          coinDelta = 50 + (i % 10) * 20; // 50-230
          details = '在${_getRandomGameName()}游戏中获胜';
          break;
        case TransactionType.gameLose:
          coinDelta = -40 - (i % 8) * 20; // -40 to -180
          details = '在${_getRandomGameName()}游戏中失败';
          break;
        case TransactionType.recharge:
          coinDelta = 100 * (1 + i % 10); // 100-1000
          details = '充值${coinDelta}金币';
          break;
        case TransactionType.dailyReward:
          coinDelta = 50 + (i % 5) * 10; // 50-100
          details = '领取每日奖励';
          break;
        case TransactionType.achievement:
          coinDelta = 200 + (i % 5) * 50; // 200-400
          details = '完成成就：${_getRandomAchievement()}';
          break;
        case TransactionType.gift:
          coinDelta = 100 + (i % 5) * 50; // 100-300
          details = '系统赠送：${_getRandomGiftReason()}';
          break;
        case TransactionType.purchase:
          coinDelta = -50 - (i % 10) * 50; // -50 to -500
          details = '购买道具：${_getRandomItem()}';
          break;
      }

      // 计算交易前后的金币数量
      final int coinsBefore = currentCoins;
      currentCoins += coinDelta;
      final int coinsAfter = currentCoins;

      // 创建交易记录
      history.add({
        'id': 'coin_txn_${now.millisecondsSinceEpoch - i * 3600000}',
        'timestamp': now.subtract(Duration(hours: i * 3 + (i % 12))),
        'type': transactionType,
        'amount': coinDelta,
        'coinsBefore': coinsBefore,
        'coinsAfter': coinsAfter,
        'details': details,
      });
    }

    // 按时间排序，最新的在前面
    history.sort(
      (a, b) =>
          (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime),
    );

    _coinHistory = history;
  }

  String _getRandomGameName() {
    final gameNames = [
      '三消娱乐',
      '飞机大战',
      '赛车竞速',
      '俄罗斯方块',
      '象棋对战',
      '斗地主',
      '麻将',
      '跑得快',
    ];
    return gameNames[DateTime.now().millisecondsSinceEpoch % gameNames.length];
  }

  String _getRandomAchievement() {
    final achievements = [
      '连胜达人',
      '金币富翁',
      '游戏大师',
      '收藏家',
      '常胜将军',
      '幸运之星',
      '战术高手',
      '全勤玩家',
    ];
    return achievements[DateTime.now().millisecondsSinceEpoch %
        achievements.length];
  }

  String _getRandomGiftReason() {
    final reasons = [
      '新手礼包',
      '登录奖励',
      '活动奖励',
      '邀请好友奖励',
      '周年庆礼包',
      '系统补偿',
      '等级提升奖励',
      '节日礼包',
    ];
    return reasons[DateTime.now().millisecondsSinceEpoch % reasons.length];
  }

  String _getRandomItem() {
    final items = [
      '双倍经验卡',
      '幸运符',
      '复活币',
      '金币加成卡',
      '特殊头像框',
      '限定皮肤',
      '游戏道具包',
      'VIP会员',
    ];
    return items[DateTime.now().millisecondsSinceEpoch % items.length];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBarWithLogout(
        title: localizations.coinHistory,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
              onPressed: _loadCoinHistory,
              child: Text(localizations.retry),
            ),
          ],
        ),
      );
    }

    if (_coinHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              localizations.noTransactionRecords,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // 应用过滤
    List<Map<String, dynamic>> filteredHistory = _coinHistory;
    if (_selectedFilter != localizations.all) {
      filteredHistory =
          _coinHistory.where((transaction) {
            final TransactionType type = transaction['type'] as TransactionType;
            final int amount = transaction['amount'] as int;

            if (_selectedFilter == localizations.income) {
              return amount > 0;
            } else if (_selectedFilter == localizations.expense) {
              return amount < 0;
            } else {
              // 按交易类型过滤
              if (_selectedFilter == localizations.game) {
                return type == TransactionType.gameWin ||
                    type == TransactionType.gameLose;
              } else if (_selectedFilter == localizations.recharge) {
                return type == TransactionType.recharge;
              } else if (_selectedFilter == localizations.reward) {
                return type == TransactionType.dailyReward ||
                    type == TransactionType.achievement ||
                    type == TransactionType.gift;
              } else if (_selectedFilter == localizations.purchase) {
                return type == TransactionType.purchase;
              }
              return false;
            }
          }).toList();
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadCoinHistory();
      },
      child: Column(
        children: [
          _buildStatisticsCard(context),
          _buildFilterChips(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [_buildTransactionList(context, filteredHistory)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // 计算统计数据
    int totalIncome = _coinHistory
        .where((txn) => txn['amount'] > 0)
        .fold(0, (sum, txn) => sum + (txn['amount'] as int));

    int totalExpense = _coinHistory
        .where((txn) => txn['amount'] < 0)
        .fold(0, (sum, txn) => sum + (txn['amount'] as int).abs());

    int netChange = totalIncome - totalExpense;

    // 计算各类型交易的统计
    Map<TransactionType, int> typeStats = {};
    for (var txn in _coinHistory) {
      final type = txn['type'] as TransactionType;
      final amount = txn['amount'] as int;
      typeStats[type] = (typeStats[type] ?? 0) + amount;
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.coinStatistics,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  localizations.totalIncome,
                  '+$totalIncome',
                  Colors.green,
                ),
                _buildStatItem(
                  localizations.totalExpense,
                  '-$totalExpense',
                  Colors.red,
                ),
                _buildStatItem(
                  localizations.netChange,
                  netChange >= 0 ? '+$netChange' : '$netChange',
                  netChange >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
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

  Widget _buildFilterChips(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // 使用本地化的筛选选项
    final filterOptions = [
      localizations.all,
      localizations.income,
      localizations.expense,
      localizations.game,
      localizations.recharge,
      localizations.reward,
      localizations.purchase,
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            filterOptions
                .map(
                  (filter) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(context, filter),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    final isSelected = _selectedFilter == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? label : AppLocalizations.of(context).all;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    List<Map<String, dynamic>> transactions,
  ) {
    final localizations = AppLocalizations.of(context);

    // 按日期分组
    Map<String, List<Map<String, dynamic>>> transactionsByDate = {};

    for (final transaction in transactions) {
      final date = transaction['timestamp'] as DateTime;
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      if (!transactionsByDate.containsKey(dateKey)) {
        transactionsByDate[dateKey] = [];
      }

      transactionsByDate[dateKey]!.add(transaction);
    }

    // 日期排序，最新的在前面
    final sortedDates =
        transactionsByDate.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final date in sortedDates) ...[
          _buildDateHeader(context, date),
          ...transactionsByDate[date]!
              .map((txn) => _buildTransactionItem(context, txn))
              .toList(),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildDateHeader(BuildContext context, String date) {
    final localizations = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday = DateFormat(
      'yyyy-MM-dd',
    ).format(now.subtract(const Duration(days: 1)));

    String displayText;
    if (date == today) {
      displayText = localizations.today;
    } else if (date == yesterday) {
      displayText = localizations.yesterday;
    } else {
      final parsedDate = DateTime.parse(date);
      displayText = DateFormat('MM月dd日').format(parsedDate);
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

  Widget _buildTransactionItem(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    final localizations = AppLocalizations.of(context);
    final int amount = transaction['amount'] as int;
    final DateTime timestamp = transaction['timestamp'] as DateTime;
    final TransactionType type = transaction['type'] as TransactionType;
    final String details = transaction['details'] as String;
    final int coinsBefore = transaction['coinsBefore'] as int;
    final int coinsAfter = transaction['coinsAfter'] as int;

    // 手动获取本地化的交易类型名称
    String typeName = '';
    switch (type) {
      case TransactionType.gameWin:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeGameWin',
        );
        break;
      case TransactionType.gameLose:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeGameLose',
        );
        break;
      case TransactionType.recharge:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeRecharge',
        );
        break;
      case TransactionType.dailyReward:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeDailyReward',
        );
        break;
      case TransactionType.achievement:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeAchievement',
        );
        break;
      case TransactionType.gift:
        typeName = localizations.getTransactionTypeName('transactionTypeGift');
        break;
      case TransactionType.purchase:
        typeName = localizations.getTransactionTypeName(
          'transactionTypePurchase',
        );
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showTransactionDetails(context, transaction),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: type.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(type.icon, color: type.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          details,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm').format(timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        amount > 0 ? '+$amount' : '$amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: amount > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$coinsBefore → $coinsAfter',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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

  void _showTransactionDetails(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    final localizations = AppLocalizations.of(context);
    final int amount = transaction['amount'] as int;
    final DateTime timestamp = transaction['timestamp'] as DateTime;
    final TransactionType type = transaction['type'] as TransactionType;
    final String details = transaction['details'] as String;
    final int coinsBefore = transaction['coinsBefore'] as int;
    final int coinsAfter = transaction['coinsAfter'] as int;

    // 手动获取本地化的交易类型名称
    String typeName = '';
    switch (type) {
      case TransactionType.gameWin:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeGameWin',
        );
        break;
      case TransactionType.gameLose:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeGameLose',
        );
        break;
      case TransactionType.recharge:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeRecharge',
        );
        break;
      case TransactionType.dailyReward:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeDailyReward',
        );
        break;
      case TransactionType.achievement:
        typeName = localizations.getTransactionTypeName(
          'transactionTypeAchievement',
        );
        break;
      case TransactionType.gift:
        typeName = localizations.getTransactionTypeName('transactionTypeGift');
        break;
      case TransactionType.purchase:
        typeName = localizations.getTransactionTypeName(
          'transactionTypePurchase',
        );
        break;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localizations.transactionDetails),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(localizations.transactionType, typeName),
                _buildDetailRow('详情', details),
                _buildDetailRow(
                  localizations.transactionAmount,
                  amount > 0 ? '+$amount' : '$amount',
                  textColor: amount > 0 ? Colors.green : Colors.red,
                ),
                _buildDetailRow(
                  localizations.transactionTime,
                  DateFormat('yyyy-MM-dd HH:mm').format(timestamp),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                _buildDetailRow(localizations.coinsBefore, '$coinsBefore'),
                _buildDetailRow(localizations.coinsAfter, '$coinsAfter'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('关闭'),
              ),
            ],
          ),
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

  void _showFilterOptions(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
                    Text(
                      localizations.filterCoinRecords,
                      style: const TextStyle(
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
                leading: const Icon(Icons.calendar_today),
                title: Text(localizations.filterByTime),
                onTap: () {
                  Navigator.pop(context);
                  // 实现时间筛选功能
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${localizations.filterByTime}功能将在后续版本推出'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort),
                title: Text(localizations.sortByAmount),
                onTap: () {
                  Navigator.pop(context);
                  // 实现金额排序功能
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${localizations.sortByAmount}功能将在后续版本推出'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: Text(localizations.advancedSearch),
                onTap: () {
                  Navigator.pop(context);
                  // 实现高级搜索功能
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${localizations.advancedSearch}功能将在后续版本推出',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
