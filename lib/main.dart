import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/setting/theme.dart';
import 'package:hukaborimemo/pages/home_page/home_screen.dart';

void main() {
  runApp(
      ProviderScope(
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(2 / 5),
      child: MaterialApp(
        title: '深堀りメモ',
        theme: ThemeClass.light(),
        darkTheme: ThemeClass.dark(),
        themeMode: ThemeMode.system,
        home: HomeScreen(),
      ),
    );
  }
}
