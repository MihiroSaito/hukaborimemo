import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/model/database/db_provider.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';
import 'package:hukaborimemo/route/route.dart';
import 'package:hukaborimemo/setting/prefs_keys.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'home_widgets.dart';

void showHomeOptionDialog(BuildContext context) {
  showCupertinoDialog(
      context: context,
      builder: (buildContext){
        return homeOptionDialogWidget(buildContext);
      }
  );
}

Future<void> createNewMemo(BuildContext context) async {
  final now = DateTime.now().toString();
  final MemoTable newMemoTable = MemoTable(
      id: null,
      parentId: 0,
      idTree: '[]',
      text: '無題メモ',
      tagId: null,
      createdAt: now,
      updateAt: now);
  final int memoId = await DBProvider.db.insertMemoData(newMemoTable);

  final MemoTable currentMemoTable = MemoTable(
      id: null,
      parentId: 0,
      idTree: '[$memoId]',
      text: '無題メモ',
      tagId: null,
      createdAt: now,
      updateAt: now);
  await DBProvider.db.updateMemoData(currentMemoTable);

  toMemoScreen(
      context: context,
      memoId: memoId,
      parentId: 0,
      title: '',
      tagId: null,
      isFirstPage: true,
      prePageTitle: null,
      isNewOne: true,
      textEditingController: null);
  context.refresh(queryMemoDataHomeProvider);
}

final queryMemoDataHomeProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {

      final List<Map<String, dynamic>> memoData = await DBProvider.db
          .queryMemoData(0);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String sortOrder = prefs.getString('${PrefsKeys.sortOrder}') ??
          'edit';

      switch(sortOrder){
        case 'newer': // 作成した日時が最近のものから取得
          memoData.sort((a, b){
            return b[MemoTable.memoCreatedAt]
                .toString()
                .compareTo(a[MemoTable.memoCreatedAt].toString());
          });
          break;
        case 'older': // 作成した日時が古いものから取得
          memoData.sort((a, b){
            return a[MemoTable.memoCreatedAt]
                .toString()
                .compareTo(b[MemoTable.memoCreatedAt].toString());
          });
          break;
        default: // 編集が加えられた
          memoData.sort((a, b){
            return b[MemoTable.memoCreatedAt]
                .toString()
                .compareTo(a[MemoTable.memoCreatedAt].toString());
          });
          break;
      }
      return memoData;
    }
);


String getCreatedDate(String dateTimeString) {
  initializeDateFormatting("ja_JP");

  DateTime datetime = DateTime.parse(dateTimeString); // StringからDate

  var formatter = DateFormat('yyyy/MM/dd', "ja_JP");
  var formatted = formatter.format(datetime); // DateからString
  return formatted;
}
