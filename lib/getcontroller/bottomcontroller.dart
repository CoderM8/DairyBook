import 'package:daily_diary/ui/allbottomscreen/calendersection/calendarscreen.dart';
import 'package:daily_diary/ui/allbottomscreen/gallerysection/galleryscreen.dart';
import 'package:daily_diary/ui/allbottomscreen/homesection/homescreen.dart';
import 'package:daily_diary/ui/allbottomscreen/settingssection/settingsscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// FOR SOME TIME REDIRECT TO SPECIFIC INDEX OF BOTTOM NAVIGATION BAR
final RxInt bottomIndex = 0.obs;

class BottomController extends GetxController {
  final List<Widget> pages = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    const SizedBox.shrink(),
    GalleryScreen(),
    const SettingsScreen(),
  ];
}
