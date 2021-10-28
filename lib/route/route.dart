import 'package:flutter/material.dart';
import 'package:hukaborimemo/pages/memo_page/memo_screen.dart';
import 'package:hukaborimemo/pages/setting_page/setting_screen.dart';

Future<void> toMemoScreen({
  required BuildContext context,
  required int memoId,
  required int parentId,
  required String title,
  required int? tagId,
  required bool isFirstPage,
  required String? prePageTitle,
  required bool isNewOne
}) async {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MemoScreen(
        memoId: memoId,
        parentId: parentId,
        title: title,
        tagId: tagId,
        isFirstPage: isFirstPage,
        prePageTitle: prePageTitle,
        isNewOne: isNewOne,
      ))
  );
}

void toSettingScreen({
  required BuildContext context
}) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingScreen())
  );
}
