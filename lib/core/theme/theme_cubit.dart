import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/storage.dart';

/// 主题状态类
class ThemeState extends Equatable {
  final ThemeMode mode;

  const ThemeState({required this.mode});

  /// 初始状态工厂方法
  factory ThemeState.initial() => const ThemeState(mode: ThemeMode.system);

  /// 复制方法
  ThemeState copyWith({ThemeMode? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }

  @override
  List<Object> get props => [mode];
}

/// 主题状态管理Cubit
class ThemeCubit extends Cubit<ThemeState> {
  final StorageService _storage;

  ThemeCubit(this._storage) : super(_initState(_storage));

  /// 初始化状态
  static ThemeState _initState(StorageService storage) {
    final storedThemeMode = storage.getThemeMode();
    if (storedThemeMode != null && storedThemeMode < ThemeMode.values.length) {
      return ThemeState(mode: ThemeMode.values[storedThemeMode]);
    }
    return ThemeState.initial();
  }

  /// 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    await _storage.setThemeMode(mode.index);
    emit(state.copyWith(mode: mode));
  }

  /// 切换到亮色主题
  Future<void> setLightTheme() => setThemeMode(ThemeMode.light);

  /// 切换到暗色主题
  Future<void> setDarkTheme() => setThemeMode(ThemeMode.dark);

  /// 切换到系统主题
  Future<void> setSystemTheme() => setThemeMode(ThemeMode.system);

  /// 切换主题（循环切换）
  Future<void> toggleTheme() async {
    switch (state.mode) {
      case ThemeMode.system:
        await setLightTheme();
        break;
      case ThemeMode.light:
        await setDarkTheme();
        break;
      case ThemeMode.dark:
        await setSystemTheme();
        break;
    }
  }
}
