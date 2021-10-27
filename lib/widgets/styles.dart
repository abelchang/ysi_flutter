import 'package:flutter/material.dart';

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;

// const Color backGroundBlack = Color(0xFF222229);
// const Color backGroundBlack = Color(0xFF292C31);

//origanel
const Color backGroundBlack = Color(0xFF1C1C1E);

const Color blueGrey = Color(0xff7a94b1);
const Color darkBlueGrey = Color(0xFF576474);
const Color darkBlueGrey3 = Color(0xFF343B43);
const Color lightBrown = Color(0xFFA77979);
const Color pinkLite = Color(0xfffc5185);
const Color navItemBlue = Color(0xFF828A94);
const Color cardBlack = Color(0xFF94ADDB);
// const Color cardBlack = Color(0xFF9DBAE0);
const Color cardLight = Color(0xFF9FAED4);
const Color cardLight2 = Color(0xFFAEB0B6);
// const Color lightBlue = Color(0xFF1877F2);
const Color lightBlue = Color(0xFF194F96);
const Color whiteSmoke = Color(0xFFF5F5F5);
// const Color whiteSmoke = Color(0xFFDDDDDD);

ButtonStyle navElevatedButtonTheme() {
  return ElevatedButton.styleFrom(
    primary: blueGrey.withOpacity(0.3),
    // primary: navItemBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
  );
}

BottomNavigationBarThemeData bottomAppBarTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: backGroundBlack,
  );
}

IconThemeData customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrineBrown900);
}

TextTheme buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        caption: base.caption?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        button: base.button?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: shrineBrown900,
        bodyColor: shrineBrown900,
      );
}

const ColorScheme shrineColorScheme = ColorScheme(
  primary: shrinePink400,
  primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  secondaryVariant: shrineBrown900,
  surface: shrineSurfaceWhite,
  background: backGroundBlack,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.dark,
);
