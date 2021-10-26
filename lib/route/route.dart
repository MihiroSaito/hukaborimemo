import 'package:flutter/material.dart';
import 'package:hukaborimemo/pages/memo_page/memo_screen.dart';

Future<void> toMemoScreen({
  required BuildContext context,
  required String title,
  required bool isFirstPage,
  required String? prePageTitle
}) async {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MemoScreen(
        title: title,
        isFirstPage: isFirstPage,
        prePageTitle: prePageTitle,
      ))
  );
}
