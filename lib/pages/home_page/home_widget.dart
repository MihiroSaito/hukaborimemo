import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Widget homeAppBar({
  required BuildContext context,
  required double safeAreaPaddingTop,
  required StateController<bool> isDisplayedAppbar
}) {
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
    child: ClipRect(
      child: BackdropFilter(
        filter: isDisplayedAppbar.state
            ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Column(
          children: [
            Container(
              height: 60 + safeAreaPaddingTop,
              width: double.infinity,
              padding: EdgeInsets.only(left: 15, right: 15, top: safeAreaPaddingTop),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    clipBehavior: Clip.antiAlias,
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
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
                        ),
                      ),
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    clipBehavior: Clip.antiAlias,
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
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
            AnimatedOpacity(
              opacity: isDisplayedAppbar.state? 1.0 : 0.0,
              duration: Duration(milliseconds: 100),
              child: Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).indicatorColor,
              ),
            )
          ],
        ),
      ),
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
        color: Theme.of(context).dialogBackgroundColor
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

Widget gridContent(context) {
  return Padding(
    padding: const EdgeInsets.all(3),
    child: Container(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).cardTheme.color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ]
              ),
              child: Text(
                'ありがとうございました、こんにちは！',
                //todo: メモのタイトルを表示する
                style: TextStyle(
                  fontSize: 15
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(right: 5, left: 5, top: 7),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container()
                ),
                Expanded(
                  flex: 7,
                  child: FittedBox(
                    child: Text(
                      '2020/10/16',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6!.color,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
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
                    color: Theme.of(context).textTheme.headline5!.color
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

