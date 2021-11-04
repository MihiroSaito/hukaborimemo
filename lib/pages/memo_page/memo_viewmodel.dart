import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/model/database/db_provider.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';
import 'package:hukaborimemo/pages/memo_page/memo_widgets.dart';

Future<void> updateTitle({
  required BuildContext context,
  required int memoId,
  required String title
}) async {

  final latestMemoData = await DBProvider.db.queryOneMemoData(memoId);

  if(title == ''){
    title = '無題メモ';
  }
  final now = DateTime.now().toString();
  final MemoTable memoTable = MemoTable(
      id: latestMemoData[MemoTable.memoId],
      parentId: latestMemoData[MemoTable.memoParentId],
      idTree: latestMemoData[MemoTable.memoIdTree],
      text: title,
      tagId: latestMemoData[MemoTable.memoTagId],
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
  required int memoId,
  required StateController<int> newMemoIdState,
  required List<TextEditingController> textEditingControllerList,
  required List<int> memoIdList,
  required List<FocusNode> focusNodeList
}) async {

  final latestCurrentMemoData = await DBProvider.db.queryOneMemoData(memoId);

  final now = DateTime.now().toString();
  final MemoTable newMemoTable = MemoTable(
      id: null,
      parentId: memoId,
      idTree: '[]',
      text: '',
      tagId: null,
      createdAt: now,
      updateAt: now);
  final newMemoId = await DBProvider.db.insertMemoData(newMemoTable);

  final List idTree = json.decode(latestCurrentMemoData[MemoTable.memoIdTree]);
  idTree.add(newMemoId);

  final MemoTable currentMemoTable = MemoTable(
      id: newMemoId,
      parentId: latestCurrentMemoData[MemoTable.memoId],
      idTree: idTree.toString(),
      text: '',
      tagId: null,
      createdAt: null,
      updateAt: latestCurrentMemoData[MemoTable.memoUpdatedAt]);
  await DBProvider.db.updateMemoData(currentMemoTable);


  textEditingControllerList.add(TextEditingController(text: ''));
  memoIdList.add(newMemoId);
  focusNodeList.add(FocusNode());
  newMemoIdState.state = newMemoId;
  context.refresh(queryMemoDataMemoProvider(memoId));
}

Future<bool> deleteMemoFunc({
  required BuildContext context,
  required int memoId,
  required int parentId,
  required List<TextEditingController> textEditingControllerList,
  required List<int> memoIdList,
  required List<FocusNode> focusNodeList,
  required String memoText,
}) async {

  final childMemos = await DBProvider.db.queryMemoData(memoId);
  if(childMemos.length != 0 || memoText != ''){

    var result = await showAlertForDeleteMemoDialog(context);

    if (result) {
      await DBProvider.db.deleteRelatedMemoData(memoId);
      removeControllersFromList(
          textEditingControllerList: textEditingControllerList,
          memoIdList: memoIdList,
          focusNodeList: focusNodeList,
          deleteItemId: memoId);
      context.refresh(queryMemoDataMemoProvider(parentId));
      return true;
    } else {
      return false;
    }

  } else {

    await DBProvider.db.deleteMemoData(memoId);
    removeControllersFromList(
        textEditingControllerList: textEditingControllerList,
        memoIdList: memoIdList,
        focusNodeList: focusNodeList,
        deleteItemId: memoId);
    context.refresh(queryMemoDataMemoProvider(parentId));
    return true;

  }

}

Future<bool> showAlertForDeleteMemoDialog(BuildContext context) async {
  var result = await showCupertinoDialog(
      context: context,
      builder: (buildContext){
        return alertForDeleteMemoDialogWidget(buildContext);
      }
  );
  return result;
}

void removeControllersFromList({
  required List<TextEditingController> textEditingControllerList,
  required List<int> memoIdList,
  required List<FocusNode> focusNodeList,
  required int deleteItemId
}) {

  final index = memoIdList.indexOf(deleteItemId);
  textEditingControllerList.removeAt(index);
  memoIdList.removeAt(index);
  focusNodeList.removeAt(index);

}
