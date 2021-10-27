import 'package:hukaborimemo/common/model/database/db_provider.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';

Future<void> createNewMemo() async {
  final now = DateTime.now().toString();
  final MemoTable memoTable = MemoTable(
      id: null,
      parentId: 0,
      text: null,
      tagId: null,
      createdAt: now,
      updateAt: now);
  final int id = await DBProvider.db.insertMemoData(memoTable);
  //todo: home画面をrefreshして新しいmemoを反映させ、今作成したmemoへ移動する
}
