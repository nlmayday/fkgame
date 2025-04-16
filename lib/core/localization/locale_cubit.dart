import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/storage.dart';

/// 本地化状态类
class LocaleState extends Equatable {
  final Locale locale;

  const LocaleState({required this.locale});

  /// 初始状态工厂方法
  factory LocaleState.initial() => const LocaleState(locale: Locale('zh'));

  /// 复制方法
  LocaleState copyWith({Locale? locale}) {
    return LocaleState(locale: locale ?? this.locale);
  }

  @override
  List<Object> get props => [locale];
}

/// 语言切换Cubit
class LocaleCubit extends Cubit<LocaleState> {
  final StorageService _storage;

  LocaleCubit(this._storage) : super(_initState(_storage));

  /// 初始化状态
  static LocaleState _initState(StorageService storage) {
    final languageCode = storage.getLanguageCode();
    if (languageCode != null && languageCode.isNotEmpty) {
      return LocaleState(locale: Locale(languageCode));
    }
    return LocaleState.initial();
  }

  /// 支持的语言列表
  List<Locale> get supportedLocales => const [
    Locale('zh'), // 中文
    Locale('en'), // 英文
  ];

  /// 切换语言
  Future<void> changeLocale(String languageCode) async {
    await _storage.setLanguageCode(languageCode);
    emit(state.copyWith(locale: Locale(languageCode)));
  }

  /// 切换到中文
  Future<void> changeToZhCN() => changeLocale('zh');

  /// 切换到英文
  Future<void> changeToEnUS() => changeLocale('en');

  /// 循环切换语言
  Future<void> toggleLocale() async {
    final currentLocale = state.locale.languageCode;
    if (currentLocale == 'zh') {
      await changeToEnUS();
    } else {
      await changeToZhCN();
    }
  }
}
