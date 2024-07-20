import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/passcode.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/ui/allbottomscreen/mainbottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EnterPassword extends GetView {
  EnterPassword({super.key});

  final RxString password = "".obs;
  final RxBool isWrong = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              Obx(() {
                if (isWrong.value) {
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
                    TextModel('enter_password', fontSize: 17.sp, fontFamily: "B"),
                  ],
                );
              }),
              SizedBox(height: 30.h),
              PasscodeScreen(
                oldPassword: appPassword,
                onSuccess: (String value) async {
                  print('Hello onSuccess value: $value -- appPassword:$appPassword');
                  if (value == appPassword) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Get.offAll(() => MainBottom());
                    });
                  } else {
                    if (value.length > 3) {
                      isWrong.value = true;
                      password.value = "";
                      await HapticFeedback.vibrate();
                      Future.delayed(Duration(seconds: 1), () {
                        isWrong.value = false;
                      });
                    }
                  }
                },
                onEntered: (String value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
