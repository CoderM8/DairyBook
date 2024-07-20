import 'dart:async';

import 'package:daily_diary/ads/ads.dart';
import 'package:daily_diary/allwidgets/color.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/ui/allbottomscreen/mainbottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'allbottomscreen/settingssection/enterpasswordscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RxDouble progressValue = 0.0.obs;
  late Timer _timer;
  final RxMap<String, dynamic> initialMessage = <String, dynamic>{}.obs;

  @override
  void initState() {
    _init();
    Future.delayed(const Duration(seconds: 3), () async {
      await initTracking();
      Storages.writeIfNull('Attempt', {"date": DateTime.now().microsecondsSinceEpoch, 'count': 0});
      final attempt = Storages.read('Attempt');
      final DateTime date = DateTime.fromMicrosecondsSinceEpoch(attempt['date']);
      final DateTime initDate = DateTime(date.year, date.month, date.day);
      final DateTime now = DateTime.now();
      final bool isPast = initDate.isBefore(DateTime(now.year, now.month, now.day));
      print('Attempt date isPast $isPast Attempt $attempt');
      if (isPast) {
        Storages.write('Attempt', {"date": DateTime.now().microsecondsSinceEpoch, 'count': 0});
      }
      if (appPassword != null) {
        Get.offAll(() => EnterPassword());
      } else {
        Get.offAll(() => MainBottom());
      }
    });
    super.initState();
  }

  Future<void> _init() async {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      progressValue.value += 0.1;
      if (progressValue >= 1.0) {
        _timer.cancel();
      }
    });

    /// APPLOVIN ADS STEP: 5
    // TODO: USE STATE-FULL WIDGET TO AVOID APPLOVIN LAZY LOAD
    await ApplovinAds.initAds();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            Center(
              child: TextModel('Daily Diary', textStyle: Theme.of(context).textTheme.headlineSmall),
            ),
            const Spacer(),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: SvgImage(isDark ? I.splashDark : I.splashLight, height: MediaQuery.sizeOf(context).width / 1.3, width: MediaQuery.sizeOf(context).width, fit: BoxFit.cover),
            ),
          ],
        ),
        Obx(() {
          return Positioned(
            bottom: 35.h,
            child: SizedBox(
              width: 180.w,
              child: LinearProgressIndicator(
                value: progressValue.value,
                minHeight: 4.h,
                borderRadius: BorderRadius.circular(5.r),
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(isDark ? darkBlue : pink),
              ),
            ),
          );
        }),
      ],
    ));
  }
}
