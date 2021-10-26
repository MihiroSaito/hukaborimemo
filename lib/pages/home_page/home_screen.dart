import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/pages/home_page/home_widgets.dart';

//todo: 本物のデータに変える
const List<Map<String, dynamic>> sampleItem = [
  {'id': 1, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 2, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 3, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 4, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 5, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 6, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 7, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 8, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 9, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 10, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 11, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},
  {'id': 12, 'parent_id': 0, 'text': 'なぜお金がたまらないのか', 'tag_id': null},];

class HomeScreen extends HookWidget {
  HomeScreen({Key? key}) : super(key: key);
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
        if (scrollOffset > 5) {
          isDisplayedAppbar.state = true;
        } else if (scrollOffset < 5) {
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
          Padding(
            padding: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: safeAreaPadding.bottom + 50),
            child: CustomScrollView(
              controller: controller,
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: safeAreaPadding.top + 60,
                  ),
                ),
                SliverToBoxAdapter(
                  child: searchBar(context),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 30,
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    crossAxisCount: 3,
                    childAspectRatio: 0.8
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index){
                      return gridContent(
                          context: context,
                          memoTitle: sampleItem[index]['text']);
                    },
                    childCount: sampleItem.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: homeAppBar(
                context: context,
                safeAreaPaddingTop: safeAreaPadding.top,
                isDisplayedAppbar: isDisplayedAppbar),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: homeBottomBar(
                context: context,
                safeAreaPaddingBottom: safeAreaPadding.bottom,
                windowSize: windowSize),
          )
        ],
      ),
    );
  }
}
