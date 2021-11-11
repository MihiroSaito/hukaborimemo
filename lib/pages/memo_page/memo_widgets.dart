import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/model/database/db_provider.dart';
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
                  //todo: memoTitleを取得する(現在仮データ使用中)
                  showSummaryOfMemoSheet(
                      context: context,
                      memoTitle: 'なぜお金がたまらないのか');
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
                  showMemoOptionDialog(context);
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
  required bool isFirstPage,
  required bool isNewOne,
  required TextEditingController textEditingController,
  required StateController<int> tagIdState,
  required String initTitle
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
        TitleTagWidget(
            isFirstPage: isFirstPage,
            tagIdState: tagIdState,
            memoId: memoId,
            title: initTitle
        ),
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

class TitleTagWidget extends HookWidget {
  const TitleTagWidget({
    Key? key,
    required this.isFirstPage,
    required this.tagIdState,
    required this.memoId,
    required this.title
  }) : super(key: key);

  final bool isFirstPage;
  final StateController<int> tagIdState;
  final int memoId;
  final String title;

  @override
  Widget build(BuildContext context) {

    if (isFirstPage) {
      return Column(  /// メモのファーストページであった場合
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
      );  /// メモのファーストページであった場合
    } else if (tagIdState.state == 0) {
      return Column(  /// 「タグを選択」を表示する
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                showSelectTagBottomSheet(
                    context: context,
                    memoId: memoId,
                    tagIdState: tagIdState);
              },
              child: Container(
                padding: Platform.isIOS
                    ? const EdgeInsets.only(left: 13, right: 13, top: 2, bottom: 2)
                    : const EdgeInsets.only(left: 13, right: 13, top: 3, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Color(0xFF5AC4CB),
                        //todo: テーマカラーにする
                        width: 1
                    )
                ),
                child: Text(
                  'タグを選択',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5AC4CB)
                    //todo: テーマカラーにする
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
        ],
      ); /// 「タグを選択」を表示する
    } else if (tagIdState.state == -1) {
      return Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '推奨質問タグ:',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline5!.color,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HookBuilder(
                            builder: (hookContext) {

                              final choiceRecommendedTagData = useProvider(choiceRecommendedTagProvider(title));

                              return choiceRecommendedTagData.when(
                                  loading: () => Container(),
                                  error: (e, s) => Container(),
                                  data: (data) {
                                    return Row(
                                      children: List<Widget>.generate(
                                          data.length, (index) {
                                        return Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              setTag(
                                                  tagId: data[index][TagTable.tagId],
                                                  memoId: memoId,
                                                  context: context,
                                                  tagIdState: tagIdState);
                                            },
                                            child: Container(
                                              padding: Platform.isIOS
                                                  ? const EdgeInsets.only(left: 13, right: 13, top: 2, bottom: 2)
                                                  : const EdgeInsets.only(left: 13, right: 13, top: 3, bottom: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(
                                                    //todo: テーマ色に合わせる
                                                      color: Color(0xFF5AC4CB),
                                                      width: 1
                                                  )
                                              ),
                                              child: Text(
                                                '${data[index][TagTable.tagName]}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF5AC4CB)
                                                  //todo: テーマ色に合わせる
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      ),
                                    );
                                  }
                              );
                            }
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            showSelectTagBottomSheet(
                                context: context,
                                memoId: memoId,
                                tagIdState: tagIdState);
                          },
                          child: Container(
                            padding: Platform.isIOS
                                ? const EdgeInsets.only(left: 13, right: 13, top: 2, bottom: 2)
                                : const EdgeInsets.only(left: 13, right: 13, top: 3, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Theme.of(context).bottomAppBarColor,
                                    width: 1
                                )
                            ),
                            child: Text(
                              '他のタグを使用',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade400
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
          ],
        ),
      ); /// 推奨タグを表示する
    } else {

      final tagIdProvider = useProvider(queryOneTagDataProvider(tagIdState.state));

      return tagIdProvider.when( /// タグが設定されていた場合
          loading: () {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: Platform.isIOS
                        ? const EdgeInsets.only(left: 13, right: 13, top: 2, bottom: 2)
                        : const EdgeInsets.only(left: 13, right: 13, top: 3, bottom: 4),
                    child: Text(
                      '',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.transparent
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
              ],
            );
          },
          error: (e, s) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: Platform.isIOS
                        ? const EdgeInsets.only(left: 13, right: 13, top: 2, bottom: 2)
                        : const EdgeInsets.only(left: 13, right: 13, top: 3, bottom: 4),
                    child: Text(
                      '',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.transparent
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
              ],
            );
          },
          data: (data) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      showSelectTagBottomSheet(
                          context: context,
                          memoId: memoId,
                          tagIdState: tagIdState);
                    },
                    child: Container(
                      padding: Platform.isIOS
                          ? const EdgeInsets.only(left: 13, right: 13, top: 2, bottom: 2)
                          : const EdgeInsets.only(left: 13, right: 13, top: 3, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF5AC4CB)
                        //todo: テーマ色に合わせる
                      ),
                      child: Text(
                        '${data[TagTable.tagName]}',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
              ],
            );
          }
      );
    }
  }
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
    behavior: HitTestBehavior.opaque,
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
                    'この項目に依存している質問や回答はすべて削除されます。よろしいですか？',
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


Widget selectTagBottomSheetWidget({
  required BuildContext context,
  required AsyncValue<List<Map<String, dynamic>>> tagDataProvider,
  required int memoId,
  required StateController<int> tagIdState
}) {
  return ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.6
    ),
    child: Container(
      color: Theme.of(context).cardTheme.color,
      padding: const EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'タグを選択',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.headline5!.color,
                ),
              ),
              Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    CupertinoIcons.xmark,
                    color: Theme.of(context).textTheme.headline5!.color,
                    size: 22,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 5,),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20),
                child: tagDataProvider.when(
                  loading: () => Container(),
                  error: (e, s) => Container(),
                  data: (data) {
                    return Wrap(
                      children: List<Widget>.generate(
                        data.length, (index) {
                          if (data[index][TagTable.tagName] != null) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                await setTag(
                                    tagId: data[index][TagTable.tagId],
                                    memoId: memoId,
                                    context: context,
                                    tagIdState: tagIdState);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: Platform.isIOS
                                    ? const EdgeInsets.only(left: 13, right: 13, top: 4, bottom: 4)
                                    : const EdgeInsets.only(left: 13, right: 13, top: 6, bottom: 8),
                                margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).bottomAppBarColor,
                                    borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                    '${data[index][TagTable.tagName]}'
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                showCreateTagPage(context);
                              },
                              child: Container(
                                padding: Platform.isIOS
                                    ? const EdgeInsets.only(left: 13, right: 13, top: 4, bottom: 4)
                                    : const EdgeInsets.only(left: 13, right: 13, top: 6, bottom: 8),
                                margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      //todo: テーマ色に合わせる
                                        color: Color(0xFF5AC4CB),
                                        width: 1
                                    )
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      CupertinoIcons.add,
                                      size: 15,
                                      //todo: テーマ色に合わせる
                                      color: Color(0xFF5AC4CB),
                                    ),
                                    Text(
                                        'タグを作成',
                                      style: TextStyle(
                                        //todo: テーマ色に合わせる
                                        color: Color(0xFF5AC4CB),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                      ),
                    );
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget createTagPageWidget({
  required BuildContext context,
  required TextEditingController textEditingController,
  required StateController<String> errorMessageState
}) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Material(
      color: Theme.of(context).cardTheme.color!.withOpacity(0.8),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AnimatedPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'キャンセル',
                            style: TextStyle(
                              fontSize: 16,
                              //todo: テーマ色に合わせる
                              color: Color(0xFF5AC4CB)
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          await createdNewTag(
                            context: context,
                            tagName: textEditingController.text,
                            errorMessageState: errorMessageState
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            '完了',
                            style: TextStyle(
                                fontSize: 16,
                                //todo: テーマ色に合わせる
                                color: Color(0xFF5AC4CB),
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Center(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '新しいタグを作成',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              height: 45,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              constraints: BoxConstraints(
                                minWidth: 100,
                                maxWidth: 200
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Theme.of(context).dialogBackgroundColor,
                              ),
                              child: TextField(
                                textAlign: TextAlign.center,
                                autofocus: true,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 10, bottom: 15),
                                  // isDense: true,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05 + 50,
                  child: Center(
                    child: Text(
                      '${errorMessageState.state}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget summaryOfMemoSheetWidget({
  required BuildContext context,
  required String memoTitle,
  required TextEditingController textEditingController
}) {

  return Material(
    child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        '$memoTitle',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Theme.of(context).indicatorColor,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              CupertinoIcons.xmark,
                              size: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).indicatorColor,
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 20, left: 15, right: 15),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                  isDense: true,
                  hintText: '結論を入力',
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.headline6!.color,
                    fontSize: 16,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.newline,
                autofocus: true, // todo: 結論が既にある場合には、falseにする？
                style: TextStyle(
                    fontSize: 16,
                    height: 1.3
                ),
                onChanged: (text) {
                  //todo: DBにtextを保存する
                },
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget memoOptionDialogWidget(BuildContext context) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      Navigator.pop(context);
    },
    child: Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 60,),
            Container(
              //todo: タブレットサイズの対応をする
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 10,
                      blurRadius: 20,
                      offset: Offset(0, 0),
                    )
                  ]
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      clipBehavior: Clip.antiAlias,
                      color: Theme.of(context).cardTheme.color,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          //todo: この項目を削除する

                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 1),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.trash,
                                size: 21,
                                color: Colors.red,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                'この項目を削除する',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
