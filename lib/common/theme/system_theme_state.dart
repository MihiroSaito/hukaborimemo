import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'system_theme_state.freezed.dart';

@freezed
class SystemThemeState with _$SystemThemeState {
  const factory SystemThemeState({
    @Default(false) bool isDarkMode,
  }) = _SystemThemeState;
}
