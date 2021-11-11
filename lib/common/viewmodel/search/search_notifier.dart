import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'search_state.dart';

final searchNotifierProvider =
  StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  void updateKeyword(String keyword) {
    state = state.copyWith(keyword: keyword);
  }
}
