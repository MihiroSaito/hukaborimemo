import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'system_theme_state.dart';

final systemThemeNotifierProvider =
StateNotifierProvider.autoDispose<SystemThemeNotifier, SystemThemeState>((ref) {
  return SystemThemeNotifier();
});

class SystemThemeNotifier extends StateNotifier<SystemThemeState> {
  SystemThemeNotifier() : super(const SystemThemeState());

  void isRightMode() {
    debugPrint('ライトモード');
    state = state.copyWith(isDarkMode: false);
  }

  void isDarkMode() {
    debugPrint('ダークモード');
    state = state.copyWith(isDarkMode: true);
  }
}
