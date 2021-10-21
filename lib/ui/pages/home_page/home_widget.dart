import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget homeAppBar() {
  return Container(
    height: 70,
    width: double.infinity,
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              //todo: 設定ページへ
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                CupertinoIcons.gear_alt_fill,
                size: 26,
                //todo: ダークモード&ライトモードで管理できるように色をメソッドで管理する
              ),
            ),
          ),
        ),
        Material(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              //todo: オプションを表示する
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                CupertinoIcons.ellipsis,
                size: 26,
                //todo: テーマで管理できるように色をメソッドで管理する
              ),
            ),
          ),
        )
      ],
    ),
  );
}
