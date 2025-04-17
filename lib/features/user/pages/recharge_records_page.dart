import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/features/auth/data/models/user_model.dart';
import 'package:fkgame/core/widgets/app_bar_with_logout.dart';
import 'package:fkgame/core/services/mock_service.dart';
import 'package:intl/intl.dart';

class RechargeRecordsPage extends StatefulWidget {
  const RechargeRecordsPage({Key? key}) : super(key: key);

  @override
  State<RechargeRecordsPage> createState() => _RechargeRecordsPageState();
}

class _RechargeRecordsPageState extends State<RechargeRecordsPage> {
  final MockService _mockService = MockService();
  List<Map<String, dynamic>> _rechargeHistory = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRechargeHistory();
  }

  void _loadRechargeHistory() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authState = context.read<AuthCubit>().state;
      if (authState.user != null) {
        final userId = authState.user!.id;
        // Load more history records than shown in the wallet preview
        _rechargeHistory = _mockService.getUserRechargeHistory(userId);

        // Add extra mock records for demonstration
        _addExtraMockRecords();
      } else {
        _errorMessage = '无法获取用户信息';
      }
    } catch (e) {
      _errorMessage = '加载失败: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addExtraMockRecords() {
    // Add some additional mock records with different statuses and dates
    final now = DateTime.now();

    final additionalRecords = [
      {
        'id': 'rec_${DateTime.now().millisecondsSinceEpoch}',
        'amount': 5000,
        'price': 500.0,
        'paymentMethod': 'wechat',
        'status': 'success',
        'createdAt': DateTime(now.year, now.month - 1, 15),
        'bonus': 500,
      },
      {
        'id': 'rec_${DateTime.now().millisecondsSinceEpoch + 1}',
        'amount': 2000,
        'price': 200.0,
        'paymentMethod': 'alipay',
        'status': 'success',
        'createdAt': DateTime(now.year, now.month - 2, 5),
        'bonus': 0,
      },
      {
        'id': 'rec_${DateTime.now().millisecondsSinceEpoch + 2}',
        'amount': 10000,
        'price': 1000.0,
        'paymentMethod': 'bank',
        'status': 'failed',
        'createdAt': DateTime(now.year, now.month - 3, 20),
        'bonus': 2000,
        'failReason': '银行卡余额不足',
      },
      {
        'id': 'rec_${DateTime.now().millisecondsSinceEpoch + 3}',
        'amount': 1000,
        'price': 100.0,
        'paymentMethod': 'alipay',
        'status': 'refunded',
        'createdAt': DateTime(now.year, now.month - 2, 28),
        'bonus': 100,
        'refundReason': '系统错误',
      },
    ];

    _rechargeHistory = [...additionalRecords, ..._rechargeHistory];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLogout(
        title: '充值记录',
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
              onPressed: _loadRechargeHistory,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_rechargeHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '暂无充值记录',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to previous page
              },
              child: const Text('去充值'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadRechargeHistory();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 16),
          _buildRecordsList(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    // Calculate total spent and points gained
    double totalSpent = 0;
    int totalPoints = 0;
    int totalBonus = 0;
    int successfulTransactions = 0;

    for (final record in _rechargeHistory) {
      if (record['status'] == 'success') {
        totalSpent += record['price'] as double;
        totalPoints += record['amount'] as int;
        totalBonus += (record['bonus'] as int? ?? 0);
        successfulTransactions++;
      }
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '充值统计',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('总充值金额', '¥${totalSpent.toStringAsFixed(2)}'),
                _buildStatItem('充值次数', '$successfulTransactions'),
                _buildStatItem('获得游戏点', '$totalPoints'),
              ],
            ),
            if (totalBonus > 0) ...[
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.card_giftcard,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '累计赠送: $totalBonus 点',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildRecordsList() {
    // Group records by month
    Map<String, List<Map<String, dynamic>>> recordsByMonth = {};

    for (final record in _rechargeHistory) {
      final date = record['createdAt'] as DateTime;
      final monthKey = '${date.year}年${date.month}月';

      if (!recordsByMonth.containsKey(monthKey)) {
        recordsByMonth[monthKey] = [];
      }

      recordsByMonth[monthKey]!.add(record);
    }

    // Sort the months in descending order
    final sortedMonths =
        recordsByMonth.keys.toList()..sort((a, b) {
          final partsA = a.split('年');
          final partsB = b.split('年');
          final yearA = int.parse(partsA[0]);
          final yearB = int.parse(partsB[0]);

          if (yearA != yearB) {
            return yearB.compareTo(yearA);
          }

          final monthA = int.parse(partsA[1].replaceAll('月', ''));
          final monthB = int.parse(partsB[1].replaceAll('月', ''));
          return monthB.compareTo(monthA);
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '交易记录',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        for (final month in sortedMonths) ...[
          _buildMonthHeader(month),
          ...recordsByMonth[month]!
              .map((record) => _buildRecordItem(record))
              .toList(),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        month,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> record) {
    final DateTime date = record['createdAt'] as DateTime;
    final DateFormat formatter = DateFormat('MM-dd HH:mm');
    final String formattedDate = formatter.format(date);

    // Determine status color and icon
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (record['status']) {
      case 'success':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = '成功';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = '处理中';
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = '失败';
        break;
      case 'refunded':
        statusColor = Colors.blue;
        statusIcon = Icons.replay;
        statusText = '已退款';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = '未知';
    }

    // Get payment method info
    String paymentMethodName = '';
    IconData paymentIcon = Icons.payment;

    switch (record['paymentMethod']) {
      case 'alipay':
        paymentMethodName = '支付宝';
        paymentIcon = Icons.account_balance_wallet;
        break;
      case 'wechat':
        paymentMethodName = '微信支付';
        paymentIcon = Icons.message;
        break;
      case 'bank':
        paymentMethodName = '银行卡';
        paymentIcon = Icons.credit_card;
        break;
      case 'apple':
        paymentMethodName = 'Apple Pay';
        paymentIcon = Icons.apple;
        break;
      case 'paypal':
        paymentMethodName = 'PayPal';
        paymentIcon = Icons.paypal;
        break;
    }

    final bool hasBonus = (record['bonus'] as int? ?? 0) > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showRecordDetails(context, record),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.monetization_on,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '充值 ${record['amount']} 游戏点',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (hasBonus) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '+${record['bonus']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              paymentIcon,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              paymentMethodName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥${record['price']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(statusIcon, size: 12, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (record['status'] == 'failed' &&
                  record['failReason'] != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '失败原因: ${record['failReason']}',
                    style: TextStyle(fontSize: 12, color: Colors.red[800]),
                  ),
                ),
              ],
              if (record['status'] == 'refunded' &&
                  record['refundReason'] != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '退款原因: ${record['refundReason']}',
                    style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showRecordDetails(BuildContext context, Map<String, dynamic> record) {
    final DateTime date = record['createdAt'] as DateTime;
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formattedDate = formatter.format(date);

    // Determine status
    String statusText;
    switch (record['status']) {
      case 'success':
        statusText = '交易成功';
        break;
      case 'pending':
        statusText = '处理中';
        break;
      case 'failed':
        statusText = '交易失败';
        break;
      case 'refunded':
        statusText = '已退款';
        break;
      default:
        statusText = '未知状态';
    }

    // Get payment method info
    String paymentMethodName = '';
    switch (record['paymentMethod']) {
      case 'alipay':
        paymentMethodName = '支付宝';
        break;
      case 'wechat':
        paymentMethodName = '微信支付';
        break;
      case 'bank':
        paymentMethodName = '银行卡';
        break;
      case 'apple':
        paymentMethodName = 'Apple Pay';
        break;
      case 'paypal':
        paymentMethodName = 'PayPal';
        break;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('交易详情'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('交易编号', record['id']),
                _buildDetailItem('交易状态', statusText),
                _buildDetailItem('交易时间', formattedDate),
                _buildDetailItem('充值金额', '¥${record['price']}'),
                _buildDetailItem('获得游戏点', '${record['amount']}'),
                if ((record['bonus'] as int? ?? 0) > 0)
                  _buildDetailItem('赠送游戏点', '${record['bonus']}'),
                _buildDetailItem('支付方式', paymentMethodName),
                if (record['status'] == 'failed' &&
                    record['failReason'] != null)
                  _buildDetailItem('失败原因', record['failReason']),
                if (record['status'] == 'refunded' &&
                    record['refundReason'] != null)
                  _buildDetailItem('退款原因', record['refundReason']),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
              if (record['status'] == 'failed')
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: 实现重新尝试支付功能
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('重新支付功能将在后续版本推出')),
                    );
                  },
                  child: const Text('重新支付'),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                ),
              if (record['status'] == 'success')
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: 实现查看发票功能
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('查看发票功能将在后续版本推出')),
                    );
                  },
                  child: const Text('查看发票'),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                ),
            ],
          ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
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
                      '筛选交易记录',
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
                  // TODO: 实现筛选功能
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('筛选功能将在后续版本推出')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('充值成功'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 实现筛选功能
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('筛选功能将在后续版本推出')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('充值失败'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 实现筛选功能
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('筛选功能将在后续版本推出')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.replay),
                title: const Text('已退款'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 实现筛选功能
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
