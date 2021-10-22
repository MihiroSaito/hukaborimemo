import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return MaterialApp(
      title: '深堀りメモ',
      theme: ThemeClass.light(),
      darkTheme: ThemeClass.dark(),
      themeMode: ThemeMode.system,
      home: InitializeApp(),
    );
  }
}

class InitializeApp extends StatefulWidget {
  const InitializeApp({Key? key}) : super(key: key);

  @override
  _InitializeAppState createState() => _InitializeAppState();
}

class _InitializeAppState extends State<InitializeApp> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      ThemeClass.systemModeHandle(context);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
