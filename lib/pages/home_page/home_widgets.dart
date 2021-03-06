import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';
import 'package:hukaborimemo/common/viewmodel/search/search_notifier.dart';
import 'package:hukaborimemo/pages/home_page/home_viewmodel.dart';
import 'package:hukaborimemo/route/route.dart';

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
                        toSettingScreen(context: context);
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
                        showHomeOptionDialog(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          CupertinoIcons.ellipsis,
                          size: 26,
                          color: Color(0xFF5AC4CB),
                          //todo: ?????????????????????????????????????????????????????????????????????
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
    behavior: HitTestBehavior.opaque,
    onTap: () {
      showSearchPage(context);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).dialogBackgroundColor
      ),
      child: Center(
        child: Padding(
          padding: Platform.isIOS
            ? const EdgeInsets.all(8.0)
            : const EdgeInsets.all(10.0),
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
                '??????',
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

Widget contentsArea({
  required BuildContext context,
  required AsyncValue<List<Map<String, dynamic>>> memoDataProvider,
}) {
  return memoDataProvider.when(
      loading: () => SliverToBoxAdapter(),
      error: (e, s) => SliverToBoxAdapter(),
      data: (data) {
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              childAspectRatio: 1.3
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index){
              return gridContent(
                  context: context,
                  memoId: data[index][MemoTable.memoId],
                  parentId: data[index][MemoTable.memoParentId],
                  memoTitle: data[index][MemoTable.memoText],
                  tagId: data[index][MemoTable.memoTagId],
                  //todo: ?????????????????????createdAt???????????????updatedAt????????????????????????
                  dateTime: data[index][MemoTable.memoUpdatedAt]);
            },
            childCount: data.length,
          ),
        );
      }
  );
}

Widget gridContent({
  required BuildContext context,
  required int memoId,
  required int parentId,
  required String memoTitle,
  required int? tagId,
  required String dateTime
}) {
  return Padding(
    padding: const EdgeInsets.all(3),
    child: Container(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.8,
            child: GestureDetector(
              onTap: (){
                toMemoScreen(
                    context: context,
                    memoId: memoId,
                    parentId: parentId,
                    title: memoTitle,
                    tagId: tagId,
                    isFirstPage: true,
                    prePageTitle: null,
                    isNewOne: false,
                    textEditingController: null);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
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
                child: Center(
                  child: Text(
                    '$memoTitle',
                    style: TextStyle(
                      fontSize: 14
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
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
                  flex: 4,
                  child: FittedBox(
                    child: Text(
                      '${getCreatedDate(dateTime)}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6!.color,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Container()
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
  required AsyncValue<List<Map<String, dynamic>>> memoDataProvider,
  required StateController<bool> tapEffect
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
                child: memoDataProvider.when(
                  loading: () {
                    return Text(
                      '???',
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.headline5!.color
                      ),
                    );
                  },
                  error: (e, s) {
                    return Text(
                      '???',
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.headline5!.color
                      ),
                    );
                  },
                  data: (data) {
                    return Text(
                      '${data.length}???',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.headline5!.color
                      ),
                    );
                  }
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
              onTapDown: (detail) {
                tapEffect.state = true;
              },
              onTap: () async {
                await createNewMemo(context);
              },
              onTapCancel: () => tapEffect.state = false,
              onTapUp: (details) => tapEffect.state = false,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: windowSize.width * 0.5,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF5EBADD), Color(0xFF50D6A9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                        ),
                        //todo: ????????????????????????????????????????????????????????????????????????????????????????????????
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
                  tapEffect.state?
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: windowSize.width * 0.5,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.15),
                          //todo: ????????????????????????????????????????????????????????????????????????????????????????????????
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ) : Container(),
                ],
              ),
            ),
          ),
        )
      )
    ],
  );
}

Widget homeOptionDialogWidget(BuildContext context) {
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
              //todo: ??????????????????????????????????????????
              width: MediaQuery.of(context).size.width * 0.6,
              height: 100,
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
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      clipBehavior: Clip.antiAlias,
                      color: Theme.of(context).cardTheme.color,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          //todo: ?????????????????????????????????
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 1),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt_circle,
                                size: 21,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                '??????'
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Theme.of(context).indicatorColor,
                  ),
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      clipBehavior: Clip.antiAlias,
                      color: Theme.of(context).cardTheme.color,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          //todo: ????????????????????????????????????????????????????????????????????????
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 1),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.arrow_up_arrow_down,
                                size: 20,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                  '????????????',
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

Widget widgetWhenThereIsNoMemo({
  required BuildContext context,
  required Size windowSize,
  required AsyncValue<List<Map<String, dynamic>>> memoDataProvider
}) {
  return memoDataProvider.when(
      loading: () => Container(),
      error: (e, s) => Container(),
      data: (data) {
        if (data.length == 0) {
          return Align(
            child: Container(
              width: windowSize.width * 0.7,
              child: Text(
                '????????????????????????????????????\n????????????????????????????????????????????????????????????',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.headline6!.color,
                    height: 1.7
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return Container();
        }
      }
  );
}

Widget searchPageWidget({
  required BuildContext context
}) {
  return Material(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).dialogBackgroundColor
                      ),
                      child: Center(
                        child: Padding(
                          padding: Platform.isIOS
                              ? const EdgeInsets.all(8.0)
                              : const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                  CupertinoIcons.search,
                                  size: 20,
                                  color: Color(0xFF868E96)
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                                    isDense: true,
                                    hintText: '??????',
                                    hintStyle: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xFF868E96)
                                    )
                                  ),
                                  autofocus: true,
                                  style: TextStyle(
                                    fontSize: 16
                                  ),
                                  maxLines: 1,
                                  textInputAction: TextInputAction.search,
                                  onChanged: (text) {
                                    context.read(searchNotifierProvider.notifier).updateKeyword(text);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '???????????????',
                        style: TextStyle(
                          color: Color(0xFF5AC4CB)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: HookBuilder(
                builder: (hookContext) {

                  final keyword = useProvider(searchNotifierProvider).keyword;
                  final searchedMemoData = useProvider(querySearchedMemoDataProvider(keyword));

                  return searchedMemoData.when(
                    loading: () => Container(),
                    error: (e, s) => Container(),
                    data: (data) {

                      if (data.length != 0) {
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              crossAxisCount: 2,
                              childAspectRatio: 1.3
                          ),
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
                          itemBuilder: (BuildContext gridContext, int index) {
                            return gridContent(
                                context: context,
                                memoId: data[index][MemoTable.memoId],
                                parentId: data[index][MemoTable.memoParentId],
                                memoTitle: data[index][MemoTable.memoText],
                                tagId: data[index][MemoTable.memoTagId],
                                //todo: ?????????????????????createdAt???????????????updatedAt????????????????????????
                                dateTime: data[index][MemoTable.memoUpdatedAt]);
                          },
                          itemCount: data.length,
                        );
                      } else if (data.length == 0 && keyword != '') {
                        return Container(
                          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                          child: Text(
                            '???????????????????????????????????????\n????????????????????????',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).textTheme.headline6!.color
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  );
                }
              )
            )
          ],
        ),
      ),
    ),
  );
}
