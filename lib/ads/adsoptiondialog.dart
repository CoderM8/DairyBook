import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/subscription/subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'ads.dart';

Future showAdsOption(context) {
  Storages.writeIfNull('Attempt', {"date": DateTime.now().microsecondsSinceEpoch, 'count': 0});
  final attempt = Storages.read('Attempt');
  final RxString string = "".obs;
  if (attempt['count'] as int >= adLimit.value) {
    string.value = "Ad_limit".tr.replaceAll('xxx', '$adLimit/$adLimit');
  }
  return Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgImage(
                I.close,
                width: 22.w,
                height: 22.w,
                fit: BoxFit.cover,
                color: Theme.of(context).colorScheme.primary.withOpacity(.7),
                onTap: () {
                  Get.back();
                },
              ),
            ),
            SizedBox(height: 10.h),
            TextModel('Choose_an_option', fontFamily: 'B', fontSize: 18.sp),
            SizedBox(height: 15.h),
            TextModel('Subscribe_text', fontFamily: 'M', fontSize: 14.sp, textAlign: TextAlign.center),
            SizedBox(height: 10.h),
            Obx(() {
              string.value;
              return TextModel(string.value, fontFamily: 'M', fontSize: 13.sp, color: Colors.red);
            }),
            SizedBox(height: 10.h),
            Button(
              height: 45.h,
              borderRadius: 10.r,
              border: true,
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgImage(I.ads, width: 18.w, height: 18.w, fit: BoxFit.scaleDown, color: Theme.of(context).colorScheme.primary),
                  SizedBox(width: 5.w),
                  TextModel('Watch_ad', fontSize: 14.sp, fontFamily: "B", color: Theme.of(context).colorScheme.primary, textAlign: TextAlign.start),
                ],
              ),
              onTap: () async {
                final DateTime date = DateTime.fromMicrosecondsSinceEpoch(attempt['date']);
                final DateTime initDate = DateTime(date.year, date.month, date.day);
                final DateTime now = DateTime.now();
                final bool isPast = initDate.isBefore(DateTime(now.year, now.month, now.day));
                print('attempt date after isPast $isPast ** $attempt');
                if (isPast) {
                  // date is past add today date
                  Storages.write('Attempt', {"date": DateTime.now().microsecondsSinceEpoch, 'count': 0});
                  await ApplovinAds.showRewardAds();
                } else {
                  // date is Today date and check user show add 3 time after not show
                  if (attempt['count'] as int < adLimit.value) {
                    attempt['count'] += 1;
                    Storages.write('Attempt', attempt);
                    await ApplovinAds.showRewardAds();
                  } else {
                    string.value = "Ad_limit".tr.replaceAll('xxx', '$adLimit/$adLimit');
                    print('Reached to limit $adLimit/$adLimit ad per day');
                  }
                }
                print('attempt data before $attempt');
                if (string.isEmpty) {
                  Get.back();
                } else {
                  Future.delayed(Duration(seconds: 2), () {
                    Get.back();
                  });
                }
              },
            ),
            SizedBox(height: 10.h),
            Button(
              height: 45.h,
              borderRadius: 10.r,
              buttonColor: Theme.of(context).hintColor,
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgImage(I.premium, width: 18.w, height: 18.w, fit: BoxFit.scaleDown, color: Colors.white),
                  SizedBox(width: 5.w),
                  TextModel('Subscribe_now', fontSize: 14.sp, fontFamily: "B", color: Colors.white, textAlign: TextAlign.start),
                ],
              ),
              onTap: () {
                Get.back();
                Get.back();
                Get.to(() => SubscriptionPlan());
              },
            ),
          ],
        ),
      ),
    ),
  );
}
