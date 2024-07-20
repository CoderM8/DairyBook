import 'package:daily_diary/allwidgets/color.dart';
import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/i.dart';
import 'package:flutter/material.dart';

class StaticsItem {
  static final List<String> emojiList = <String>[
    "assets/gif/haha.gif",
    "assets/gif/happy.gif",
    "assets/gif/love.gif",
    "assets/gif/shocked.gif",
    "assets/gif/angel.gif",
    "assets/gif/dejected.gif",
    "assets/gif/shout.gif",
    "assets/gif/crying.gif"
  ];
  static final List<Map> category = [
    {"title": "Draft", "index": 0, "icon": I.draft, "color": Color(0xff785E34)},
    {"title": "Idea", "index": 1, "icon": I.idea, "color": Color(0xffF1C40F)},
    {"title": "Shopping", "index": 2, "icon": I.shopping, "color": Color(0xffDC7633)},
    {"title": "Sport", "index": 3, "icon": I.sport, "color": Color(0xff8D36BF)},
    {"title": "Music", "index": 4, "icon": I.music, "color": Color(0xff5F56F0)},
    {"title": "Work", "index": 5, "icon": I.work, "color": Color(0xff52BE80)},
    {"title": "Cooking", "index": 6, "icon": I.cooking, "color": Color(0xffEC7063)},
    {"title": "Finance", "index": 7, "icon": I.finance, "color": Color(0xffD35400)},
    {"title": "Health", "index": 8, "icon": I.health, "color": Color(0xffF51A0C)},
    {"title": "Goals", "index": 9, "icon": I.goals, "color": Color(0xff21618C)},
    {"title": "Game", "index": 10, "icon": I.game, "color": Color(0xff0A7D66)},
    {"title": "Travel", "index": 11, "icon": I.travel, "color": Color(0xff46B8BF)},
  ];
  static final List<Map<String, String>> bgImageList = <Map<String, String>>[
    {"Type": "PAID", "Img": "assets/bg/1.jpg"},
    {"Type": "FREE", "Img": "assets/bg/2.jpg"},
    {"Type": "PAID", "Img": "assets/bg/3.jpg"},
    {"Type": "PAID", "Img": "assets/bg/4.jpg"},
    {"Type": "PAID", "Img": "assets/bg/5.jpg"},
    {"Type": "FREE", "Img": "assets/bg/6.jpg"},
    {"Type": "PAID", "Img": "assets/bg/7.jpg"},
    {"Type": "PAID", "Img": "assets/bg/8.jpg"},
    {"Type": "PAID", "Img": "assets/bg/9.jpg"},
    {"Type": "PAID", "Img": "assets/bg/10.jpg"},
    {"Type": "FREE", "Img": "assets/bg/11.jpg"},
  ];

  static final List<Map<String, dynamic>> colorList = <Map<String, dynamic>>[
    {"Type": "FREE", "Color": const Color(0xFFFF8D8D)},
    {"Type": "PAID", "Color": const Color(0xFFFFAF8D)},
    {"Type": "FREE", "Color": const Color(0xFF8DBBFF)},
    {"Type": "PAID", "Color": const Color(0xFFA48DFF)},
    {"Type": "PAID", "Color": const Color(0xFFFF8DD2)},
    {"Type": "FREE", "Color": const Color(0xFF91D052)},
    {"Type": "PAID", "Color": const Color(0xFF52D085)},
    {"Type": "FREE", "Color": const Color(0xFFC5466C)},
    {"Type": "PAID", "Color": const Color(0xFFDE4444)},
    {"Type": "FREE", "Color": const Color(0xFF6344DE)},
    {"Type": "PAID", "Color": const Color(0xFF995C42)},
    {"Type": "FREE", "Color": const Color(0xFF429999)},
    {"Type": "PAID", "Color": const Color(0xFF819FB0)},
    {"Type": "FREE", "Color": const Color(0xFF81B0A5)},
    {"Type": "PAID", "Color": const Color(0xFFD08C25)},
  ];

  static final List<Color> fontColorList = [Colors.white, Colors.black, pink, clay, darkBlue, ...Colors.primaries];

  static final List<FontWeight> fontWeightList = [FontWeight.w400, FontWeight.w500, FontWeight.w700];

  static final List<Common> alignList = <Common>[
    Common(index: 0, value: Icons.format_align_left, align: TextAlign.start),
    Common(index: 1, value: Icons.format_align_center, align: TextAlign.center),
    Common(index: 2, value: Icons.format_align_right, align: TextAlign.end)
  ];

  static final List<Map<String, String>> fontFamilyList = <Map<String, String>>[
    {"Type": "FREE", "Name": "Default"},
    {"Type": "PAID", "Name": "Inter"},
    {"Type": "PAID", "Name": "Satisfy"},
    {"Type": "FREE", "Name": "Roboto"},
    {"Type": "PAID", "Name": "Alice"},
    {"Type": "FREE", "Name": "Martel"},
    {"Type": "PAID", "Name": "Praise"},
    {"Type": "PAID", "Name": "Carter"},
    {"Type": "PAID", "Name": "Bayon"},
    {"Type": "PAID", "Name": "PtSans"},
    {"Type": "PAID", "Name": "Jost"},
    {"Type": "PAID", "Name": "Lobster"},
  ];
}
