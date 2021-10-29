import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/model/database/db_provider.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';

Future<void> updateTitle({
  required BuildContext context,
  required int memoId,
  required String title,
  required int parentId,
  required int? tagId
}) async {
  if(title == ''){
    title = '無題メモ';
  }
  final now = DateTime.now().toString();
  final MemoTable memoTable = MemoTable(
      id: memoId,
      parentId: parentId,
      text: title,
      tagId: tagId,
      createdAt: null,
      updateAt: now);
  final int id = await DBProvider.db.updateMemoData(memoTable);
}

final queryMemoDataMemoProvider =
  FutureProvider.autoDispose.family<List<Map<String, dynamic>>, int>((ref, memoId) async {
    return await DBProvider.db
        .queryMemoData(memoId);
  }
);

Future<void> addNewMemo({
  required BuildContext context,
  required int memoId
}) async {
  final now = DateTime.now().toString();
  final MemoTable memoTable = MemoTable(
      id: null,
      parentId: memoId,
      text: '無題メモ',
      tagId: null,
      createdAt: now,
      updateAt: now);
  await DBProvider.db.insertMemoData(memoTable);
  context.refresh(queryMemoDataMemoProvider(memoId));
}
