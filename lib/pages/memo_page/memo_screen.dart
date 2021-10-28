import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    required this.isNewOne}) : super(key: key);
  final int memoId;
  final int parentId;
  final String title;
  final int? tagId;
  final bool isFirstPage;
  final String? prePageTitle;
  final bool isNewOne;

  final isDisplayedAppbarProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context) {

    final safeAreaPadding = MediaQuery.of(context).padding;
    final windowSize = MediaQuery.of(context).size;
    final ScrollController controller = useScrollController();
    final isDisplayedAppbar = useProvider(isDisplayedAppbarProvider);
    final TextEditingController textEditingController = useTextEditingController(text: title);
    final memoDataProvider = useProvider(queryMemoDataMemoProvider(memoId));

    useEffect(() {
      controller.addListener(() {
        double scrollOffset = controller.offset;
        if (scrollOffset > 60) {
          isDisplayedAppbar.state = true;
        } else if (scrollOffset < 60) {
          isDisplayedAppbar.state = false;
        }
      });
      return (){
        // controller.dispose();
      };
    }, const []);

    return Scaffold(
      body: Stack(
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
                    title: title,
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
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            if(index == data.length - 1){
                              return memoListContent(
                                  context: context,
                                  isLastItem: true,
                                  content: data[index],
                                  title: '$title');
                            } else {
                              return memoListContent(
                                  context: context,
                                  isLastItem: false,
                                  content: data[index],
                                  title: '$title');
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
                      memoId: memoId
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
        ],
      ),
    );
  }
}
