import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClass {

  static ThemeData light() {
    return ThemeData(
      primarySwatch: ThemeClass.hukaborimemoColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Color(0xFFF1F3F5),
      cardTheme: CardTheme(
          color: Colors.white
      ),
      dialogBackgroundColor: Color(0xFFDEE2E6),
      indicatorColor: Colors.grey[200],
      textTheme: lightTextTheme,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
        },
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      primarySwatch: ThemeClass.hukaborimemoColor,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color(0xFF1A1A1A),
      cardTheme: CardTheme(
       color: Color(0xFF2A2A2A)
      ),
      dialogBackgroundColor: Color(0xFF2A2A2A),
      indicatorColor: Colors.grey[900],
      textTheme: darkTextTheme,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
        },
      ),
    );
  }





  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFF868E96),
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF868E96),
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline5: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFF868E96),
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFFADB5BD),
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.notoSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.notoSans(
      fontSize: 14.0,
      color: Colors.white,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline5: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFF868E96),
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFF495057),
    ),
  );

  static const MaterialColor hukaborimemoColor = MaterialColor(_hukaborimemoColorPrimaryValue, <int, Color>{
    50: Color(0xFFEBF8F9),
    100: Color(0xFFCEEDEF),
    200: Color(0xFFADE2E5),
    300: Color(0xFF8CD6DB),
    400: Color(0xFF73CDD3),
    500: Color(_hukaborimemoColorPrimaryValue),
    600: Color(0xFF52BEC6),
    700: Color(0xFF48B6BE),
    800: Color(0xFF3FAFB8),
    900: Color(0xFF2EA2AC),
  });
  static const int _hukaborimemoColorPrimaryValue = 0xFF5AC4CB;

  static const MaterialColor hukaborimemoColorAccent = MaterialColor(_hukaborimemoColorAccentValue, <int, Color>{
    100: Color(0xFFF0FEFF),
    200: Color(_hukaborimemoColorAccentValue),
    400: Color(0xFF8AF5FF),
    700: Color(0xFF70F3FF),
  });
  static const int _hukaborimemoColorAccentValue = 0xFFBDF9FF;

}
