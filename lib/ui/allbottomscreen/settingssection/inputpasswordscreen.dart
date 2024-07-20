import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/passcode.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/getcontroller/passwordcontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/ui/allbottomscreen/settingssection/confirmpasswordscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InputPassword extends GetView {
  InputPassword({super.key});

  final PasswordController ic = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const Back()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              SvgImage(I.password, height: 25.w, width: 25.w, color: Theme.of(context).hintColor, fit: BoxFit.cover),
              SizedBox(height: 15.h),
              if (appPassword == null) TextModel('enter_password', fontSize: 17.sp, fontFamily: "B") else TextModel('change_password', fontSize: 17.sp, fontFamily: "B"),
              SizedBox(height: 30.h),
              PasscodeScreen(
                onSuccess: (String value) {
                  print('Hello input onSuccess $value');
                  if (value.length == 4) {
                    ic.password.value = value;
                    Get.to(() => ConfirmPassword());
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
