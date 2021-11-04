import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';
import 'package:hukaborimemo/pages/memo_page/memo_viewmodel.dart';
import 'package:hukaborimemo/route/route.dart';

Widget memoAppBar({
  required BuildContext context,
  required double safeAreaPaddingTop,
  required bool isFirstPage,
  required String? prePageTitle
}) {
  return Column(
    children: [
      Container(
        height: safeAreaPaddingTop,
        color: Theme.of(context).cardTheme.color,
      ),
      Container(
        height: 60,
        width: double.infinity,
        color: Theme.of(context).cardTheme.color,
        child: Row(
          children: [
            Material(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              clipBehavior: Clip.antiAlias,
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    CupertinoIcons.chevron_back,
                    color: Color(0xFF868E96),
                    size: 25,
                  ),
                ),
              ),
            ),
            //todo: スクロール量が60以上になったらTextをセンターに表示してこのページのタイトルを濃い色で表示する。
            Expanded(
              child: !isFirstPage && prePageTitle != null? Text(
                '$prePageTitle',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline5!.color
                ),
              ) : Container(),
            ),
            SizedBox(width: 7,),
            Material(
              borderRadius: BorderRadius.circular(5),
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  //todo: この深堀りのまとめをできるページorなにかを表示する
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    CupertinoIcons.checkmark_alt,
                    size: 25,
                    color: Color(0xFF5AC4CB),
                    //todo: テーマで管理できるように色をメソッドで管理する
                  ),
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(5),
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  //todo: メモページのオプションを表示する
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    CupertinoIcons.ellipsis,
                    size: 25,
                    color: Color(0xFF5AC4CB),
                    //todo: テーマで管理できるように色をメソッドで管理する
                  ),
                ),
              ),
            ),
            isFirstPage? Material(
              borderRadius: BorderRadius.circular(5),
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  //todo: 深堀りのヒントを表示する
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    CupertinoIcons.question,
                    // color: Colors.transparent,
                    size: 23,
                    color: Color(0xFFF7DC84),
                  ),
                ),
              ),
            ) : Container(),
            SizedBox(width: 5,),
          ],
        ),
      ),
    ],
  );
}

Widget memoTitleArea({
  required BuildContext context,
  required int memoId,
  required int parentId,
  required StateController<String> titleState,
  required int? tagId,
  required bool isFirstPage,
  required bool isNewOne,
  required TextEditingController textEditingController
}) {

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 0),
        )
      ]
    ),
    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isFirstPage? Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Container(
                padding: Platform.isIOS
                    ? const EdgeInsets.only(left: 13, right: 13, top: 2, bottom: 2)
                    : const EdgeInsets.only(left: 13, right: 13, top: 3, bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).bottomAppBarColor
                ),
                child: Text(
                  'タイトル',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5,),
          ],
        ) : Container(),
        //todo: タグがあった場合にはタグを表示する
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10, bottom: 10),
              isDense: true,
            ),
            autofocus: isNewOne? true :false,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
            ),
            maxLines: null,
            textInputAction: TextInputAction.done,
            onChanged: (text){
              titleState.state = text;
              updateTitle(
                context: context,
                memoId: memoId,
                title: text);
            },
          ),
        ),
      ],
    ),
  );
}

Widget memoListSpaceFirst(BuildContext context) {
  return Container(
    height: 5,
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: Center(
              child: Container(
                width: 2,
                height: double.infinity,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: Container(),
        )
      ],
    ),
  );
}

Widget memoListSpace(BuildContext context) {
  return Container(
    height: 20,
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: Center(
              child: Container(
                width: 2,
                height: double.infinity,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: Container(),
        )
      ],
    ),
  );
}

Widget memoListContent({
  required BuildContext context,
  required bool isLastItem,
  required Map<String, dynamic> content,
  required StateController<String> titleState,
  required List<TextEditingController> textEditingControllerList,
  required List<int> memoIdList,
  required StateController<int> newMemoIdState,
  required List<FocusNode> focusNodeList,
  required int listIndex
}) {
  return Container(
    child: Column(
      children: [
        memoListSpace(context),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isLastItem? Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            Container(
                              width: 2,
                              color: Theme.of(context).dividerColor,
                            ),
                            Expanded(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 2,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ) : Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        width: 2,
                        color: Theme.of(context).dividerColor,
                      ),
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Container(
                              height: 2,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Dismissible(
                  key: Key('${content[MemoTable.memoId]}'),
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.only(
                      right: 10,
                    ),
                    alignment: AlignmentDirectional.centerEnd,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    await deleteMemoFunc(
                        context: context,
                        memoId: content[MemoTable.memoId],
                        parentId: content[MemoTable.memoParentId],
                        textEditingControllerList: textEditingControllerList,
                        memoIdList: memoIdList,
                        focusNodeList: focusNodeList,
                        memoText: textEditingControllerList[listIndex].text
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 11, right: 5, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 0),
                        )
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Row(
                        children: [
                          Expanded(
                            //todo: 最大サイズを決めて文字数が多く、それ以上大きくなる場合には「もっと見る」を設ける
                            child: TextField(
                              focusNode: focusNodeList[listIndex],
                              controller: textEditingControllerList[listIndex],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                                isDense: true,
                              ),
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1.3
                              ),
                              maxLines: null,
                              textInputAction: TextInputAction.done,
                              onChanged: (text) {
                                updateTitle(
                                    context: context,
                                    memoId: content[MemoTable.memoId],
                                    title: text
                                );
                              },
                            ),
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(5),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                toMemoScreen(
                                    context: context,
                                    memoId: content[MemoTable.memoId],
                                    parentId: content[MemoTable.memoParentId],
                                    title: textEditingControllerList[listIndex].text,
                                    tagId: content[MemoTable.memoTagId],
                                    isFirstPage: false,
                                    prePageTitle: titleState.state,
                                    isNewOne: false,
                                    textEditingController: textEditingControllerList[listIndex]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  CupertinoIcons.chat_bubble_2,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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

Widget addItemButton({
  required BuildContext context,
  required int memoId,
  required StateController<int> newMemoIdState,
  required List<TextEditingController> textEditingControllerList,
  required List<int> memoIdList,
  required List<FocusNode> focusNodeList
}) {
  return GestureDetector(
    onTap: () async {
      FocusScope.of(context).unfocus();
      await addNewMemo(
          context: context,
          memoId: memoId,
          newMemoIdState: newMemoIdState,
          textEditingControllerList: textEditingControllerList,
          memoIdList: memoIdList,
          focusNodeList: focusNodeList);
      focusNodeList.last.requestFocus();
    },
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
            colors: [Color(0xFF5EBADD), Color(0xFF50D6A9)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF5EBADD).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 0),
          )
        ]
      ),
      child: Icon(
        CupertinoIcons.add,
        color: Colors.white,
        size: 23,
      ),
    ),
  );
}


Widget alertForDeleteMemoDialogWidget(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context, false);
    },
    child: Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardTheme.color,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Text(
                    //todo: ここの文章をもう少し考える
                    'この項目に依存しているメモはすべて削除されます。よろしいですか？',
                    style: TextStyle(
                      fontSize: 16
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20,),
                Material(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7 - 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Center(
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7 - 60,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Center(
                        child: Text(
                          'キャンセル',
                          style: TextStyle(
                              color: Colors.red
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
