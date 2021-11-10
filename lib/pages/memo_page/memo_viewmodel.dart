import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/common_viewmodel.dart';
import 'package:hukaborimemo/common/model/database/db_provider.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';
import 'package:hukaborimemo/pages/memo_page/memo_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


final queryMemoDataMemoProvider =
  FutureProvider.autoDispose.family<List<Map<String, dynamic>>, int>((ref, memoId) async {
    return await DBProvider.db
        .queryMemoData(memoId);
  }
);

final queryOneTagDataProvider =
  FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, tagId) async {
    return await DBProvider.db.queryOneTagData(tagId);
  }
);

final queryTagDataProvider =
  FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
    var result = await DBProvider.db.queryTagData();
    final List<Map<String, dynamic>> allTag = List.of(result);
    allTag.sort((a, b){
      return b[TagTable.tagUsedAt].toString().compareTo(a[TagTable.tagUsedAt].toString());
    });
    final Map<String, dynamic> createTagTag = {};
    allTag.add(createTagTag);
    return allTag;
  }
);

final choiceRecommendedTagProvider =
  FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, title) async {
    return await choiceRecommendedQuestionTag(title);
  }
);


Future<void> updateTitle({
  required BuildContext context,
  required int memoId,
  required String title
}) async {

  final latestMemoData = await DBProvider.db.queryOneMemoData(memoId);

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

Future<void> showSelectTagBottomSheet({
  required BuildContext context,
  required int memoId,
  required StateController<int> tagIdState
}) async {

  showModalBottomSheet<void>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.1),
    isScrollControlled: true,
    enableDrag: false,
    builder: (BuildContext context) {
      return HookBuilder(
        builder: (hookContext) {

          final tagDataProvider = useProvider(queryTagDataProvider);

          return selectTagBottomSheetWidget(
            context: context,
            tagDataProvider: tagDataProvider,
            memoId: memoId,
            tagIdState: tagIdState
          );
        }
      );
    },
  );
}

void showCreateTagPage(BuildContext context) {

  final TextEditingController textEditingController = TextEditingController();
  final errorMessageProvider = StateProvider((ref) => '');

  showCupertinoDialog(
      context: context,
      builder: (buildContext){
        return HookBuilder(
          builder: (hookContext) {

            final errorMessageState = useProvider(errorMessageProvider);

            return createTagPageWidget(
                context: buildContext,
                textEditingController: textEditingController,
                errorMessageState: errorMessageState);
          }
        );
      }
  );
}

Future<void> createdNewTag({
  required BuildContext context,
  required String tagName,
  required StateController<String> errorMessageState
}) async {
  if (RegExp(r"\s+").hasMatch(tagName)) {
    alertVibration();
    errorMessageState.state = 'タグに空白は含められません。';
  } else if (tagName.length > 10) {
    alertVibration();
    errorMessageState.state = 'タグは10文字以内にしてください。';
  } else if (tagName.length == 0) {
    debugPrint('空白');
  } else {
    final now = DateTime.now().toString();
    final TagTable tagTable = TagTable(
        id: null,
        name: tagName,
        usedAt: now,
        createdAt: now,
        updatedAt: now);
    await DBProvider.db.insertTagData(tagTable);
    context.refresh(queryTagDataProvider);
    Navigator.pop(context);
  }

}

Future<void> setTag({
  required int tagId,
  required int memoId,
  required BuildContext context,
  required StateController<int> tagIdState
}) async {

  final memoData = await DBProvider.db.queryOneMemoData(memoId);

  tagIdState.state = tagId;

  final MemoTable memoTable = MemoTable(
      id: memoId,
      parentId: memoData[MemoTable.memoParentId],
      idTree: memoData[MemoTable.memoIdTree],
      text: memoData[MemoTable.memoText],
      tagId: tagId,
      createdAt: null,
      updateAt:  memoData[MemoTable.memoUpdatedAt]);
  await DBProvider.db.updateMemoData(memoTable);
  context.refresh(queryMemoDataMemoProvider(memoData[MemoTable.memoParentId]));

}

Future<List<Map<String, dynamic>>> choiceRecommendedQuestionTag(String title) async {
  final tags = await DBProvider.db.queryTagData();
  List<Map<String, dynamic>> recommendedQuestionTagList = [];

  for (int i = 0; i < tags.length; i++) {

    final tagName = tags[i][TagTable.tagName].replaceAll("？", "");

    /// titleが10文字未満だった場合
    if (title.length < 10) {
      if (title.contains(tagName)) {

        recommendedQuestionTagList.add({
          '${TagTable.tagId}': tags[i][TagTable.tagId],
          '${TagTable.tagName}': tags[i][TagTable.tagName],
        });

      }
    } else {

      /// メモのタイトルの先頭から10文字取得する
      final String firstTenChar = title.substring(0, 10);

      if (firstTenChar.contains(tagName)) {
        recommendedQuestionTagList.add({
          '${TagTable.tagId}': tags[i][TagTable.tagId],
          '${TagTable.tagName}': tags[i][TagTable.tagName],
        });

      } else {
        /// メモのタイトルの最後から10文字を取得する。
        final String lastTenChar = title.substring(title.length - 10, title.length);
        if (lastTenChar.contains(tagName)) {
          recommendedQuestionTagList.add({
              '${TagTable.tagId}': tags[i][TagTable.tagId],
              '${TagTable.tagName}': tags[i][TagTable.tagName],
          });
        }
      }

    }

  }

  if (recommendedQuestionTagList.isEmpty) {
    return [{'${TagTable.tagId}': 1, '${TagTable.tagName}': 'なぜ？'}];
  } else {
    return recommendedQuestionTagList;
  }
}

Future<void> showSummaryOfMemoSheet({
  required BuildContext context,
  required String memoTitle
}) async {

  //todo: 結論をDBから取得し、Controllerのtextに入れる

  final TextEditingController textEditingController = TextEditingController();

  showCupertinoModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return summaryOfMemoSheetWidget(
            context: context,
            memoTitle: memoTitle,
            textEditingController: textEditingController);
      }
  );
}


