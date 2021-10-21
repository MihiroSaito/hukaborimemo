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
      body: Column(
        children: [
          SizedBox(height: safeAreaPadding.top,),
          homeAppBar(),
          Expanded(
            child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      searchBar(),
                    ],
                  )
                )
            ),
          ),
          homeBottomBar(
              safeAreaPaddingBottom: safeAreaPadding.bottom,
              windowSize: windowSize)
        ],
      ),
    );
  }
}
