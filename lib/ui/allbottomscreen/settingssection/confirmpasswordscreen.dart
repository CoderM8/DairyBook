import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/passcode.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/getcontroller/passwordcontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConfirmPassword extends GetView {
  ConfirmPassword({super.key});

  final PasswordController ic = Get.find<PasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const Back()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              Obx(() {
                if (ic.isWrong.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgImage(I.password, height: 25.w, width: 25.w, color: Colors.red, fit: BoxFit.cover),
                      SizedBox(height: 15.h),
                      TextModel('incorrect_password', fontSize: 17.sp, fontFamily: "B", color: Colors.red),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgImage(I.password, height: 25.w, width: 25.w, color: Theme.of(context).hintColor, fit: BoxFit.cover),
                    SizedBox(height: 15.h),
                    TextModel('confirm_password', fontSize: 17.sp, fontFamily: "B"),
                  ],
                );
              }),
              SizedBox(height: 30.h),
              PasscodeScreen(
                oldPassword: ic.confirm.value,
                onSuccess: (String value) async {
                  print('Hello confirm onSuccess $value');
                  if (value == ic.password.value) {
                    ic.confirm.value = value;
                    showDialog(
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
                                TextModel('Save_Password', textStyle: Theme.of(context).dialogTheme.titleTextStyle),
                                SizedBox(height: 12.h),
                                TextModel("Save_Password_text", textStyle: Theme.of(context).dialogTheme.titleTextStyle!.copyWith(fontSize: 16.sp, fontFamily: 'M'), textAlign: TextAlign.center),
                                SizedBox(height: 32.h),
                                Button(
                                  title: 'save',
                                  onTap: () async {
                                    ic.isEnable.value = true;
                                    appPassword = ic.confirm.value;
                                    await Storages.write("password", ic.confirm.value);
                                    Get.back();
                                    Get.back();
                                    Get.back();
                                  },
                                ),
                                SizedBox(height: 10.h),
                                Button(
                                    title: 'reset',
                                    buttonColor: Colors.transparent,
                                    titleColor: Theme.of(context).colorScheme.primary,
                                    onTap: () {
                                      Get.back();
                                      Get.back();
                                      ic.confirm.value = "";
                                      ic.password.value = "";
                                    }),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    if (value.length > 3) {
                      ic.isWrong.value = true;
                      ic.confirm.value = "";
                      await HapticFeedback.vibrate();
                      Future.delayed(Duration(seconds: 1), () {
                        ic.isWrong.value = false;
                      });
                    }
                  }
                },
                onEntered: (String value) {
                  ic.confirm.value = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
