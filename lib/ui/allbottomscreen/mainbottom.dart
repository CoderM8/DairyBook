import 'package:daily_diary/ads/ads.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/getcontroller/bottomcontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/ui/allbottomscreen/creatediary/creatediary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainBottom extends GetView {
  MainBottom({super.key});

  final BottomController bc = Get.put(BottomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(index: bottomIndex.value, children: bc.pages);
      }),
      floatingActionButton: Container(
        height: 56.w,
        width: 56.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
        child: SvgImage(I.add, color: Colors.white, width: 18.w, height: 18.w, fit: BoxFit.cover),
      ).onTap(() async {
        await ApplovinAds.showInterAds();
        Get.to(() => CreateDiary());
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() {
        bottomIndex.value;
        return BottomNavigationBar(
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          currentIndex: bottomIndex.value,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: (index) async {
            bottomIndex.value = index;
            if (index == 2) {
              await ApplovinAds.showInterAds();
              Get.to(() => CreateDiary());
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: SvgImage(I.myDiary_outline, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!, width: 18.w, height: 18.w, fit: BoxFit.cover),
                ),
                label: "myDiary".tr,
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: SvgImage(I.myDiary, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor!, width: 18.w, height: 18.w, fit: BoxFit.cover),
                )),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: SvgImage(I.calendar_outline, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!, width: 18.w, height: 18.w, fit: BoxFit.cover),
                ),
                label: 'calendar'.tr,
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: SvgImage(I.calendar, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor!, width: 18.w, height: 18.w, fit: BoxFit.cover),
                )),
            BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: SvgImage(I.gallery_outline, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!, width: 18.w, height: 18.w, fit: BoxFit.cover),
                ),
                label: 'gallery'.tr,
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: SvgImage(I.gallery, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor!, width: 18.w, height: 18.w, fit: BoxFit.cover),
                )),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: SvgImage(I.settings_outline, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!, width: 18.w, height: 18.w, fit: BoxFit.cover),
                ),
                label: 'settings'.tr,
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: SvgImage(I.settings, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor!, width: 18.w, height: 18.w, fit: BoxFit.cover),
                )),
          ],
        );
      }),
    );
  }
}
