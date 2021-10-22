import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/common/theme/system_theme_notifier.dart';
import 'package:hukaborimemo/pages/home_page/home_widget.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final safeAreaPadding = MediaQuery.of(context).padding;
    final windowSize = MediaQuery.of(context).size;
    final pageState = useProvider(systemThemeNotifierProvider);

    return Scaffold(
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
                  child: searchBar(context),
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
            child: homeAppBar(
                context: context,
                safeAreaPaddingTop: safeAreaPadding.top),
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
