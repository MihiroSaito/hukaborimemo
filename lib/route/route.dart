import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/pages/home_page/home_viewmodel.dart';
import 'package:hukaborimemo/pages/memo_page/memo_screen.dart';
import 'package:hukaborimemo/pages/memo_page/memo_viewmodel.dart';
import 'package:hukaborimemo/pages/setting_page/setting_screen.dart';

Future<void> toMemoScreen({
  required BuildContext context,
  required int memoId,
  required int parentId,
  required String title,
  required int? tagId,
  required bool isFirstPage,
  required String? prePageTitle,
  required bool isNewOne,
  required TextEditingController? textEditingController
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
        textEditingControllerForTitle: textEditingController,
      ))
  ).then((_){
    context.refresh(queryMemoDataHomeProvider);
    context.refresh(queryMemoDataMemoProvider(parentId));
  });
}

void toSettingScreen({
  required BuildContext context
}) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingScreen())
  );
}
