import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/model/database/tables.dart';
import 'package:hukaborimemo/pages/memo_page/memo_viewmodel.dart';

import 'memo_widgets.dart';

//todo: 本物のデータに変える
const List<Map<String, dynamic>> sampleTags = [
  {'id': 1, 'name': 'なぜ', 'usedAt': ''},
  {'id': 2, 'name': 'なんのために', 'usedAt': ''},
  {'id': 3, 'name': 'いつ', 'usedAt': ''},
  {'id': 4, 'name': '何を', 'usedAt': ''},
  {'id': 5, 'name': 'どこで', 'usedAt': ''},
  {'id': 6, 'name': 'どのように', 'usedAt': ''},
];

class MemoScreen extends HookWidget {
  MemoScreen({
    Key? key,
    required this.memoId,
    required this.parentId,
    required this.title,
    required this.tagId,
    required this.isFirstPage,
    required this.prePageTitle,
    required this.isNewOne,
    required this.textEditingControllerForTitle}) : super(key: key);
  final int memoId;
  final int parentId;
  final String title;
  final int? tagId;
  final bool isFirstPage;
  final String? prePageTitle;
  final bool isNewOne;
  final TextEditingController? textEditingControllerForTitle;

  final isDisplayedAppbarProvider = StateProvider((ref) => false);
  final titleStateProvider = StateProvider((ref) => '');
  final newMemoIdStateProvider = StateProvider((ref) => 0);
  final List<TextEditingController> textEditingControllerList = [];
  final List<int> memoIdList = [];
  final List<int> counter = [];

  @override
  Widget build(BuildContext context) {

    final safeAreaPadding = MediaQuery.of(context).padding;
    final windowSize = MediaQuery.of(context).size;
    final ScrollController controller = useScrollController();
    final isDisplayedAppbar = useProvider(isDisplayedAppbarProvider);
    final TextEditingController textEditingController = textEditingControllerForTitle != null
        ? textEditingControllerForTitle!
        : useTextEditingController(text: title);
    final memoDataProvider = useProvider(queryMemoDataMemoProvider(memoId));
    final titleState = useProvider(titleStateProvider);
    final newMemoIdState = useProvider(newMemoIdStateProvider);

    useEffect(() {
      controller.addListener(() {
        double scrollOffset = controller.offset;
        if (scrollOffset > 60) {
          isDisplayedAppbar.state = true;
        } else if (scrollOffset < 60) {
          isDisplayedAppbar.state = false;
        }
      });
      WidgetsBinding.instance!.addPostFrameCallback((_){
        titleState.state = title;
      });

      return (){
        for (TextEditingController c in textEditingControllerList) {
          c.dispose();
        }
      };
    }, const []);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: controller,
              // physics: scrollPhysics.state,
              physics: ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: safeAreaPadding.top + 60,
                  ),
                ),
                SliverToBoxAdapter(
                  child: memoTitleArea(
                      context: context,
                      memoId: memoId,
                      parentId: parentId,
                      titleState: titleState,
                      tagId: tagId,
                      isFirstPage: isFirstPage,
                      isNewOne: isNewOne,
                      textEditingController: textEditingController)
                ),
                memoDataProvider.when(
                  loading: () => SliverToBoxAdapter(),
                  error: (e, s) => SliverToBoxAdapter(),
                  data: (data) {
                    return SliverPadding(
                      padding: const EdgeInsets.only(left: 10, right: 15),
                      sliver: SliverToBoxAdapter(
                          child: data.length != 0
                              ? memoListSpaceFirst(context)
                              : Container()
                      ),
                    );
                  }
                ),
                memoDataProvider.when(
                  loading: () => SliverToBoxAdapter(),
                  error: (e, s) => SliverToBoxAdapter(),
                  data: (data) {
                    return SliverPadding(
                      padding: EdgeInsets.only(left: 10, right: 15),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (!memoIdList.contains(data[index][MemoTable.memoId])) {
                              textEditingControllerList.add(TextEditingController(text: data[index][MemoTable.memoText]));
                              memoIdList.add(data[index][MemoTable.memoId]);
                            }
                            if(index == data.length - 1){
                              return memoListContent(
                                  context: context,
                                  isLastItem: true,
                                  content: data[index],
                                  titleState: titleState,
                                  textEditingControllerForMemo: textEditingControllerList[index],
                                  newMemoIdState: newMemoIdState);
                            } else {
                              return memoListContent(
                                  context: context,
                                  isLastItem: false,
                                  content: data[index],
                                  titleState: titleState,
                                  textEditingControllerForMemo: textEditingControllerList[index],
                                  newMemoIdState: newMemoIdState);
                            }
                          },
                          childCount: data.length
                        ),
                      ),
                    );
                  }
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 25),
                  sliver: SliverToBoxAdapter(
                      child: addItemButton(
                        context: context,
                        memoId: memoId,
                        newMemoIdState: newMemoIdState,
                        textEditingControllerList: textEditingControllerList
                      )
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: memoAppBar(
                  context: context,
                  safeAreaPaddingTop: safeAreaPadding.top,
                  isDisplayedAppbar: isDisplayedAppbar,
                  isFirstPage: isFirstPage,
                  prePageTitle: prePageTitle),
            ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: Container(
            //     height: 50,
            //     color: Colors.red,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
