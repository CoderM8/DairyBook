import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/getcontroller/passwordcontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/ui/allbottomscreen/settingssection/inputpasswordscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SetPassword extends GetView {
  SetPassword({super.key});

  final PasswordController ic = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextModel('password', textStyle: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: false,
        leading: const Back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
                tileColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                title: TextModel('enable_lock', fontSize: 13.sp),
                trailing: Obx(() {
                  ic.isEnable.value;
                  return CupertinoSwitch(
                    activeColor: Theme.of(context).hintColor,
                    thumbColor: Colors.white,
                    onChanged: (bool mood) {
                      ic.isEnable.value = mood;
                      if (!mood) {
                        appPassword = null;
                        Storages.remove('password');
                      }
                    },
                    value: ic.isEnable.value,
                  );
                }),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                ic.isEnable.value;
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
                  tileColor: ic.isEnable.value ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  title: TextModel(appPassword == null ? "set_password" : 'change_password', fontSize: 13.sp),
                  trailing: SvgImage(I.arrowRight, color: Theme.of(context).hintColor, width: 18.w, height: 18.w, fit: BoxFit.cover),
                  onTap: ic.isEnable.value
                      ? () {
                          Get.to(() => InputPassword());
                        }
                      : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
