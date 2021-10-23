import 'package:flutter/material.dart';
import 'package:hukaborimemo/pages/memo_page/memo_screen.dart';

Future<void> toMemoScreen({
  required BuildContext context,
}) async {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MemoScreen())
  );
}
