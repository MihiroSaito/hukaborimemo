import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'memo_widgets.dart';

//todo: 本物のデータに変える
const List<Map<String, dynamic>> sampleItem = [
  {'id': 30, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': 1},
  {'id': 31, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 32, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 33, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 34, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 35, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 36, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 37, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 38, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 39, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 40, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},
  {'id': 41, 'parent_id': 1, 'text': '収入が少ないから（memo）', 'tag_id': null},];

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
    required this.title,
    required this.isFirstPage,
    required this.prePageTitle}) : super(key: key);
  final String title;
  final bool isFirstPage;
  final String? prePageTitle;

  final isDisplayedAppbarProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context) {

    final safeAreaPadding = MediaQuery.of(context).padding;
    final windowSize = MediaQuery.of(context).size;
    final ScrollController controller = useScrollController();
    final isDisplayedAppbar = useProvider(isDisplayedAppbarProvider);

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
                    title: title,
                    isFirstPage: isFirstPage)
              ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 10, right: 15),
                sliver: SliverToBoxAdapter(
                    child: sampleItem.length != 0
                        ? memoListSpaceFirst(context)
                        : Container()
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 10, right: 15),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if(index == sampleItem.length - 1){
                        return memoListContent(
                            context: context,
                            isLastItem: true,
                            content: sampleItem[index],
                            title: '$title');
                      } else {
                        return memoListContent(
                            context: context,
                            isLastItem: false,
                            content: sampleItem[index],
                            title: '$title');
                      }
                    },
                    childCount: sampleItem.length
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 25),
                sliver: SliverToBoxAdapter(
                    child: addItemButton()
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
