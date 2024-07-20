import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/getcontroller/homecontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DeleteData extends StatelessWidget {
  DeleteData({super.key});

  final HomeController hc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const Back()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SvgImage(I.deleteData, width: 72.w, height: 72.w, color: Theme.of(context).hintColor),
          SizedBox(height: 24.h),
          TextModel('sure_delete', textStyle: Theme.of(context).dialogTheme.titleTextStyle),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.all(24.w),
            child: Row(
              children: [
                SvgImage(I.check_fill, width: 24.w, height: 24.w, color: Theme.of(context).hintColor),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextModel('Local_Data', fontSize: 13.sp, fontFamily: 'B', textAlign: TextAlign.start, color: Colors.black),
                      SizedBox(height: 8.h),
                      TextModel('deleteData_text', fontSize: 13.sp, fontFamily: 'M', textAlign: TextAlign.start, color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Spacer(),
          Button(
            title: 'delete',
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            onTap: () async {
              await DatabaseHelper.deleteDatabaseFile().then((delete) async {
                hc.isLoad.value = false;
                hc.items.clear();
                hc.nowDate.value = DateTime.now();
                if (delete) {
                  showToast('${"Local_Data".tr} ${"delete".tr}');
                }
              });
            },
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
