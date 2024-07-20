import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/getcontroller/bottomcontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/subscription/configPremium.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BackUpData extends StatelessWidget {
  const BackUpData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const Back()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Image.asset(isDark ? I.data_backup_dark : I.data_backup_light, width: MediaQuery.sizeOf(context).width, height: MediaQuery.sizeOf(context).width / 1.4),
          SizedBox(height: 24.h),
          TextModel("Backup_Your_Data", fontSize: 24.sp, fontFamily: 'B', textAlign: TextAlign.center),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                TextModel("Backup_text", fontSize: 13.sp, textAlign: TextAlign.center),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    SvgImage(I.check_fill, width: 20.w, height: 20.w, color: Theme.of(context).hintColor),
                    SizedBox(width: 15.w),
                    Expanded(child: TextModel("Backup_1", fontFamily: "M", textAlign: TextAlign.start, fontSize: 12.sp, maxLines: 2)),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SvgImage(I.check_fill, width: 20.w, height: 20.w, color: Theme.of(context).hintColor),
                    SizedBox(width: 15.w),
                    Expanded(child: TextModel("Backup_2", fontFamily: "M", textAlign: TextAlign.start, fontSize: 12.sp, maxLines: 2)),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Button(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isSubscribe.value) ...[
                    SvgImage(I.premium, width: 18.w, height: 18.w, fit: BoxFit.scaleDown, color: Colors.white),
                    SizedBox(width: 5.w),
                  ],
                  TextModel('Backup', fontSize: 14.sp, fontFamily: "B", color: Colors.white, textAlign: TextAlign.start),
                ],
              ),
              enable: isSubscribe.value,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              onTap: () async {
                await DatabaseHelper.exportDatabase().then((value) async {
                  if (value) {
                    final String? mb = await DatabaseHelper.sizeInMB();
                    showToast("Backup".tr + ' $mb');
                  } else {
                    showToast("No " + "Backup".tr, s: false);
                  }
                });
              }),
          SizedBox(height: 11.h),
          Button(
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isSubscribe.value) ...[
                  SvgImage(I.premium, width: 18.w, height: 18.w, fit: BoxFit.scaleDown, color: Colors.white),
                  SizedBox(width: 5.w),
                ],
                TextModel('Restore', fontSize: 14.sp, fontFamily: "B", color: Colors.white, textAlign: TextAlign.start),
              ],
            ),
            enable: isSubscribe.value,
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            onTap: () async {
              await DatabaseHelper.importDatabase().then((import) {
                if (import) {
                  RestartWidget.restartApp(context);
                  bottomIndex.value = 0;
                  showToast("Backup_success");
                } else {
                  showToast('No ${"Backup".tr}', s: import);
                }
              });
            },
          ),
          SizedBox(height: 5.h),
          TextModel("Restart_app", fontSize: 13.sp, color: Theme.of(context).hintColor, textAlign: TextAlign.center, padding: EdgeInsets.symmetric(horizontal: 24.w)),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
