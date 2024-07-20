import 'dart:ui';

import 'package:daily_diary/allwidgets/color.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  ThemeMode get getThemeMode => _themeMode;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    if (mode == ThemeMode.system) {
      isDark = PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    } else {
      isDark = mode == ThemeMode.dark;
    }
    notifyListeners();
  }
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightPink,
      primaryColor: Colors.white,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      useMaterial3: false,
      unselectedWidgetColor: const Color(0xffBEBEBE),
      hintColor: pink,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actionsIconTheme: const IconThemeData(color: lightBlack),
        titleTextStyle: TextStyle(fontSize: 20.sp, color: lightBlack, fontFamily: 'B'),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
        ),
      ),
      colorScheme: const ColorScheme.light(primary: Colors.black),
      dialogTheme: DialogTheme(titleTextStyle: TextStyle(color: lightBlack, fontSize: 18.sp, fontFamily: 'B'), backgroundColor: Colors.white),
      textTheme: TextTheme(displayLarge: h1StyleLight, displayMedium: h2StyleLight, displaySmall: h3StyleLight, headlineMedium: h4StyleLight, headlineSmall: h5StyleLight),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: pink),
        unselectedIconTheme: const IconThemeData(color: grey),
        selectedItemColor: pink,
        unselectedItemColor: grey,
        selectedLabelStyle: TextStyle(fontFamily: 'B', fontSize: 11.sp, color: pink),
        unselectedLabelStyle: TextStyle(fontFamily: 'R', fontSize: 11.sp, color: grey),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        dialBackgroundColor: lightPink,
        // color for AM/PM
        dayPeriodColor: pink,
        dialHandColor: pink,
        dayPeriodBorderSide: const BorderSide(color: pink),
        hourMinuteTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
        hourMinuteColor: lightPink,
        dialTextColor: Colors.black,
        dialTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
        dayPeriodTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
        dayPeriodTextColor: Colors.black,
        helpTextStyle: TextStyle(fontFamily: 'M', fontSize: 18.sp),
      ),
      datePickerTheme: DatePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          backgroundColor: Colors.white,
          todayBackgroundColor: WidgetStateProperty.all(pink),
          todayBorder: BorderSide.none,
          yearStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: darkBlue),
          weekdayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: grey),
          todayForegroundColor: WidgetStateProperty.all(darkBlue),
          dayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp)),
      tabBarTheme: TabBarTheme(
        labelColor: pink,
        indicatorColor: lightPink,
        unselectedLabelColor: grey,
        labelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
        unselectedLabelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
      ));

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBlue,
    primaryColor: lightBlue,
    hintColor: clay,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    useMaterial3: false,
    unselectedWidgetColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actionsIconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(fontSize: 20.sp, color: Colors.white, fontFamily: 'B'),
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
      ),
    ),
    colorScheme: const ColorScheme.dark(primary: Colors.white),
    dialogTheme: DialogTheme(titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.sp, fontFamily: 'B'), backgroundColor: lightBlue),
    textTheme: TextTheme(displayLarge: h1StyleDark, displayMedium: h2StyleDark, displaySmall: h3StyleDark, headlineMedium: h4StyleDark, headlineSmall: h5StyleDark),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightBlue,
      selectedIconTheme: const IconThemeData(color: Colors.white),
      unselectedIconTheme: const IconThemeData(color: grey),
      selectedItemColor: Colors.white,
      unselectedItemColor: grey,
      selectedLabelStyle: TextStyle(fontFamily: 'B', fontSize: 11.sp, color: Colors.white),
      unselectedLabelStyle: TextStyle(fontFamily: 'R', fontSize: 11.sp, color: grey),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      dialBackgroundColor: darkBlue,
      dayPeriodColor: clay,
      // color for AM/PM
      dialHandColor: clay,
      dayPeriodBorderSide: const BorderSide(color: clay),
      hourMinuteTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
      hourMinuteColor: darkBlue,
      dialTextColor: Colors.white,
      dialTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
      dayPeriodTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
      dayPeriodTextColor: Colors.white,
      helpTextStyle: TextStyle(fontFamily: 'M', fontSize: 18.sp),
    ),
    datePickerTheme: DatePickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: lightBlue,
        todayBackgroundColor: WidgetStateProperty.all(clay),
        todayBorder: BorderSide.none,
        yearStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: Colors.white),
        weekdayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: grey),
        todayForegroundColor: WidgetStateProperty.all(Colors.white),
        dayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp)),
    tabBarTheme: TabBarTheme(
      labelColor: clay,
      indicatorColor: Colors.white,
      unselectedLabelColor: grey,
      labelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
      unselectedLabelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
    ),
  );

  static setSystemUIOverlayStyle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        if (PlatformDispatcher.instance.platformBrightness == Brightness.dark) {
          isDark = true;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: Colors.black,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
            ),
          );
        } else {
          isDark = false;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
            ),
          );
        }
        break;
      case ThemeMode.light:
        isDark = false;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
          ),
        );
        break;
      case ThemeMode.dark:
        isDark = true;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
          ),
        );
        break;
    }
  }

  /// Light Mode
  static final TextStyle h1StyleLight = TextStyle(fontSize: 17.5.sp, color: const Color(0xff101010), fontFamily: 'R');
  static final TextStyle h2StyleLight = TextStyle(fontSize: 16.sp, fontFamily: "R", color: const Color(0xff9A9A9A));

  static final TextStyle h3StyleLight = TextStyle(color: const Color(0xffcacaca), fontFamily: "R", fontSize: 20.sp);
  static final TextStyle h4StyleLight = TextStyle(fontSize: 15.sp, color: const Color(0xff2d2d2d), fontFamily: "R");

  static final TextStyle h5StyleLight = TextStyle(fontSize: 40.sp, color: pink, fontFamily: "B");

  /// Dark Mode
  static final TextStyle h1StyleDark = TextStyle(fontSize: 17.5.sp, color: const Color(0xfff0f0f0), fontFamily: 'R');
  static final TextStyle h2StyleDark = TextStyle(fontSize: 16.sp, color: const Color(0xffC6C6C6), fontFamily: "R");

  static final TextStyle h3StyleDark = TextStyle(color: const Color(0xffabacac), fontFamily: "R", fontSize: 20.sp);
  static final TextStyle h4StyleDark = TextStyle(fontSize: 15.sp, color: const Color(0xff949494), fontFamily: "R");

  static final TextStyle h5StyleDark = TextStyle(fontSize: 40.sp, color: Colors.white, fontFamily: "B");
}
