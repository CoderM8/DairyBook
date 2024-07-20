import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/color.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/themes/apptheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ThemeChange extends StatefulWidget {
  const ThemeChange({Key? key}) : super(key: key);

  @override
  ThemeChangeState createState() => ThemeChangeState();
}

class ThemeChangeState extends State<ThemeChange> {
  ThemeMode? selectedThemeMode;

  void changeTheme(ThemeMode mode, ThemeNotifier themeModeNotifier) async {
    themeModeNotifier.setThemeMode(mode);
    await Storages.write('themeMode', mode.index);
    themeMode = mode.index;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: const Back(),
        title: TextModel("theme", textStyle: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
              tileColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              title: TextModel("Device_appearance", fontSize: 16.sp, fontFamily: "M"),
              trailing: CupertinoSwitch(
                  value: themeMode == 0,
                  activeColor: Theme.of(context).hintColor,
                  thumbColor: Colors.white,
                  onChanged: (val) async {
                    setState(() {
                      if (val == true) {
                        changeTheme(ThemeMode.system, notifier);
                      } else {
                        changeTheme(ThemeMode.dark, notifier);
                      }
                    });
                  }),
            ),
            TextModel(
              "Device_appearance_text",
              fontSize: 14.sp,
              padding: EdgeInsets.symmetric(vertical: 15.h),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
              tileColor: Theme.of(context).primaryColor,
              onTap: themeMode != 0
                  ? () {
                      changeTheme(ThemeMode.light, notifier);
                    }
                  : null,
              title: TextModel("Light", fontSize: 16.sp, fontFamily: "M"),
              trailing: themeMode == 1
                  ? CircleAvatar(
                      radius: 11.r,
                      backgroundColor: Theme.of(context).hintColor,
                      child: CircleAvatar(radius: 4.r, backgroundColor: Colors.white),
                    )
                  : CircleAvatar(
                      radius: 10.r,
                      backgroundColor: dot,
                      child: CircleAvatar(radius: 9.r, backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor),
                    ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
              tileColor: Theme.of(context).primaryColor,
              onTap: themeMode != 0
                  ? () {
                      changeTheme(ThemeMode.dark, notifier);
                    }
                  : null,
              title: TextModel("Dark", fontSize: 16.sp, fontFamily: "M"),
              trailing: themeMode == 2
                  ? CircleAvatar(
                      radius: 11.r,
                      backgroundColor: Theme.of(context).hintColor,
                      child: CircleAvatar(radius: 4.r, backgroundColor: Colors.white),
                    )
                  : CircleAvatar(
                      radius: 10.r,
                      backgroundColor: dot,
                      child: CircleAvatar(radius: 9.r, backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
