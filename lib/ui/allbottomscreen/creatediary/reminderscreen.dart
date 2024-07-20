import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/getcontroller/creatediarycontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatelessWidget {
  ReminderScreen({super.key});

  final CreateController cc = Get.find<CreateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: const Back(),
        title: TextModel("Daily_Reminder", textStyle: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            TextModel(
              'Reminder_note',
              fontSize: 13.sp,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              padding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
              tileColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              title: TextModel('Open_notification', fontSize: 13.sp),
              trailing: Obx(() {
                return CupertinoSwitch(
                  activeColor: Theme.of(context).hintColor,
                  thumbColor: Colors.white,
                  onChanged: (mood) {
                    cc.notification.value = mood;
                  },
                  value: cc.notification.value,
                );
              }),
            ),
            SizedBox(height: 8.h),
            Obx(() {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
                tileColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                title: TextModel('Choose_Time', fontSize: 13.sp, fontFamily: "B"),
                subtitle: TextModel(DateFormat(dateFormat.value + " EE hh:mm a", Storages.read('languageCode')).format(cc.dateTime.value), fontSize: 13.sp),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextModel(DateFormat("hh:mm a").format(cc.reminder.value), fontSize: 13.sp, fontFamily: "M", color: Theme.of(context).hintColor),
                    SizedBox(width: 3.w),
                    SvgImage(I.arrowRight, color: Theme.of(context).colorScheme.primary, width: 18.w, height: 18.w, fit: BoxFit.cover),
                  ],
                ),
                onTap: cc.notification.value
                    ? () {
                        showTimePicker(
                          context: context,
                          confirmText: 'save'.tr,
                          cancelText: 'cancel'.tr,
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                          initialTime: TimeOfDay.fromDateTime(cc.dateTime.value),
                        ).then((value) {
                          if (value != null) {
                            cc.reminder.value = DateTime(cc.dateTime.value.year, cc.dateTime.value.month, cc.dateTime.value.day, value.hour, value.minute);
                          }
                        });
                      }
                    : null,
              );
            }),
            const Spacer(),
            Obx(() {
              return Button(
                title: 'save',
                height: 40.h,
                enable: cc.notification.value,
                onTap: () {
                  Get.back();
                },
              );
            }),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
