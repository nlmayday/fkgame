import 'package:flutter/material.dart';

/// 金币交易类型枚举
enum TransactionType {
  // 游戏胜利收益
  gameWin,
  // 游戏失败扣除
  gameLose,
  // 充值
  recharge,
  // 每日奖励
  dailyReward,
  // 成就奖励
  achievement,
  // 系统赠送
  gift,
  // 购买道具
  purchase,
}

/// 交易类型扩展类，提供交易类型的相关属性
extension TransactionTypeExt on TransactionType {
  /// 获取交易类型的本地化键名
  String get localizationKey {
    switch (this) {
      case TransactionType.gameWin:
        return 'transactionTypeGameWin';
      case TransactionType.gameLose:
        return 'transactionTypeGameLose';
      case TransactionType.recharge:
        return 'transactionTypeRecharge';
      case TransactionType.dailyReward:
        return 'transactionTypeDailyReward';
      case TransactionType.achievement:
        return 'transactionTypeAchievement';
      case TransactionType.gift:
        return 'transactionTypeGift';
      case TransactionType.purchase:
        return 'transactionTypePurchase';
    }
  }

  /// 获取交易类型的图标
  IconData get icon {
    switch (this) {
      case TransactionType.gameWin:
        return Icons.emoji_events;
      case TransactionType.gameLose:
        return Icons.sports_esports;
      case TransactionType.recharge:
        return Icons.account_balance_wallet;
      case TransactionType.dailyReward:
        return Icons.calendar_today;
      case TransactionType.achievement:
        return Icons.military_tech;
      case TransactionType.gift:
        return Icons.card_giftcard;
      case TransactionType.purchase:
        return Icons.shopping_cart;
    }
  }

  /// 获取交易类型的颜色
  Color get color {
    switch (this) {
      case TransactionType.gameWin:
        return Colors.green;
      case TransactionType.gameLose:
        return Colors.red;
      case TransactionType.recharge:
        return Colors.blue;
      case TransactionType.dailyReward:
        return Colors.orange;
      case TransactionType.achievement:
        return Colors.purple;
      case TransactionType.gift:
        return Colors.pink;
      case TransactionType.purchase:
        return Colors.deepOrange;
    }
  }

  /// 获取交易类型的ID
  String get id {
    switch (this) {
      case TransactionType.gameWin:
        return 'game_win';
      case TransactionType.gameLose:
        return 'game_lose';
      case TransactionType.recharge:
        return 'recharge';
      case TransactionType.dailyReward:
        return 'daily_reward';
      case TransactionType.achievement:
        return 'achievement';
      case TransactionType.gift:
        return 'gift';
      case TransactionType.purchase:
        return 'purchase';
    }
  }

  /// 根据ID获取交易类型
  static TransactionType fromId(String id) {
    switch (id) {
      case 'game_win':
        return TransactionType.gameWin;
      case 'game_lose':
        return TransactionType.gameLose;
      case 'recharge':
        return TransactionType.recharge;
      case 'daily_reward':
        return TransactionType.dailyReward;
      case 'achievement':
        return TransactionType.achievement;
      case 'gift':
        return TransactionType.gift;
      case 'purchase':
        return TransactionType.purchase;
      default:
        throw ArgumentError('Unknown transaction type id: $id');
    }
  }
}
