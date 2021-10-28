import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hukaborimemo/setting/theme.dart';
import 'package:hukaborimemo/pages/home_page/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'common/model/database/db_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.db.database;
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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('ja','JP'),
        ],
      ),
    );
  }
}
