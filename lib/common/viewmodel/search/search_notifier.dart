import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'search_state.dart';

final searchNotifierProvider =
  StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});

// 〇〇Notifierにはこのファイル内のstateNotifierを継承したクラス名を、
// 〇〇Stateにはfreezedを使用する際に作成したクラス名を使用する。（大文字から）

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  void updateKeyword(String keyword) {
    state = state.copyWith(keyword: keyword);
  }
}
