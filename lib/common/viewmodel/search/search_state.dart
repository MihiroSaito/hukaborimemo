import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart'; /// ファイル名と合わせる

@freezed
class SearchState with _$SearchState {
  const factory SearchState({

  @Default('') String keyword,

  }) = _SearchState;
}
