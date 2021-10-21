import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hukaborimemo/ui/pages/home_page/home_widget.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final safeAreaPadding = MediaQuery.of(context).padding;
    final windowSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF1F3F5),
      //todo: ダークモード&ライトモードで管理できるように色をメソッドで管理する
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: safeAreaPadding.top + 60,
                bottom: safeAreaPadding.bottom + 50),
            child: CustomScrollView(
              //todo: こんとローラーを追加する
              slivers: [
                SliverToBoxAdapter(
                  child: searchBar(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    crossAxisCount: 3,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index){
                      return Container(
                        color: Colors.white,
                      );
                      //todo: コンテンツを表示する
                    },
                    childCount: 30,
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
            child: homeAppBar(safeAreaPaddingTop: safeAreaPadding.top),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: homeBottomBar(
                safeAreaPaddingBottom: safeAreaPadding.bottom,
                windowSize: windowSize),
          )
        ],
      ),
    );
  }
}
