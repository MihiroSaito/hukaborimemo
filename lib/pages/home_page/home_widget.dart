import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget homeAppBar({
  required BuildContext context,
  required double safeAreaPaddingTop
}) {
  //todo: 色や背景をスクロールに応じて変える
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Column(
      children: [
        SizedBox(height: safeAreaPaddingTop,),
        Container(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () {
                    //todo: 設定ページへ
                    debugPrint('設定ページへ');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      CupertinoIcons.gear_alt_fill,
                      size: 26,
                      color: Color(0xFF868E96),
                      //todo: ダークモード&ライトモードで管理できるように色をメソッドで管理する
                    ),
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () {
                    //todo: オプションを表示する
                    debugPrint('オプション表示');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      CupertinoIcons.ellipsis,
                      size: 26,
                      color: Color(0xFF5AC4CB),
                      //todo: テーマで管理できるように色をメソッドで管理する
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget searchBar(BuildContext context) {
  return GestureDetector(
    onTap: () {
      //todo: 検索画面を表示する
      debugPrint('検索画面表示');
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).cardTheme.color
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.search,
                size: 20,
                color: Color(0xFF868E96)
              ),
              SizedBox(width: 5,),
              Text(
                '検索',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF868E96)
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget homeBottomBar({
  required BuildContext context,
  required double safeAreaPaddingBottom,
  required Size windowSize,
}) {
  return Stack(
    children: [
      Container(
        height: 70 + safeAreaPaddingBottom,
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 50 + safeAreaPaddingBottom,
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: Offset(0, 0),
                )
              ]
          ),
          child: Row(
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: safeAreaPaddingBottom),
                child: Text(
                  '30件',
                  //todo: メモの数を表示する
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyText2!.color
                    //todo: ダークモード&ライトモードで管理できるように色をメソッドで管理する
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        left: 0,
        child: Container(
          child: Center(
            child: GestureDetector(
              onTap: () {
                //todo: メモページへ移動する
                //todo: ボタンを押した時のへフェクトを追加する。（グラデーションのためInkWellは使えないと思われる）
                debugPrint('メモを新規作成し、移動');
              },
              child: Container(
                width: windowSize.width * 0.5,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5EBADD), Color(0xFF50D6A9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                  //todo: （グラデーション）テーマで管理できるように色をメソッドで管理する
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                    child: Icon(
                      CupertinoIcons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      )
    ],
  );
}

