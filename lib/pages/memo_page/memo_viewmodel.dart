import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/model/database/db_provider.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';

Future<void> updateTitle({
  required int memoId,
  required String title,
  required int parentId,
  required int? tagId
}) async {
  //todo: titleが空だった時のバリデーションを追加する
  final now = DateTime.now().toString();
  final MemoTable memoTable = MemoTable(
      id: memoId,
      parentId: parentId,
      text: title,
      tagId: tagId,
      createdAt: null,
      updateAt: now);
  final int id = await DBProvider.db.updateMemoData(memoTable);
  //todo: home画面をrefreshして新しいmemoを反映させ、今作成したmemoへ移動する
}

final queryMemoDataMemoProvider =
  FutureProvider.autoDispose.family<List<Map<String, dynamic>>, int>((ref, memoId) async {
    return await DBProvider.db
        .queryMemoData(memoId);
  }
);

