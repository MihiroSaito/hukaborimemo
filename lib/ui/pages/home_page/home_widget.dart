import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget homeAppBar() {
  return Container(
    height: 70,
    width: double.infinity,
    child: Row(
      children: [
        Icon(
          CupertinoIcons.gear,
          size: 26,
          //todo: ダークモード&ライトモードで管理できるように色をメソッドで管理する
        ),
        Icon(
          CupertinoIcons.ellipsis,
          size: 26,
          //todo: テーマで管理できるように色をメソッドで管理する
        )
      ],
    ),
  );
}
