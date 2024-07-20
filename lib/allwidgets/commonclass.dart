import 'dart:async';

import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Common<T> {
  final int index;
  final T value;
  final TextAlign align;

  Common({required this.index, required this.value, required this.align});
}

class Task {
  late String title;
  late bool completed;

  Task({required this.title, required this.completed});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'completed': completed ? 1 : 0, 'title': title};
  }

  factory Task.fromMap(Map<dynamic, dynamic> map) {
    return Task(completed: map['completed'] == 1, title: map['title']);
  }
}

Future<void> showDeleteDialog(context, {VoidCallback? onTap}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        insetPadding: EdgeInsets.all(20.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.only(top: 32.h, bottom: 10.h, right: 24.w, left: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextModel('deleteTitle', textStyle: Theme.of(context).dialogTheme.titleTextStyle),
              SizedBox(height: 12.h),
              TextModel('deleteDes', textStyle: Theme.of(context).dialogTheme.titleTextStyle!.copyWith(fontSize: 16.sp, fontFamily: 'M'), textAlign: TextAlign.center),
              SizedBox(height: 32.h),
              Button(
                title: 'delete',
                onTap: onTap,
              ),
              SizedBox(height: 10.h),
              Button(
                title: 'cancel',
                buttonColor: Colors.transparent,
                titleColor: Theme.of(context).colorScheme.primary,
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
