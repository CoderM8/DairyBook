import 'package:daily_diary/ads/ads.dart';
import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/allwidgets/diarybox.dart';
import 'package:daily_diary/allwidgets/emojiPicker.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/getcontroller/homecontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/subscription/configPremium.dart';
import 'package:daily_diary/subscription/subscription.dart';
import 'package:daily_diary/ui/allbottomscreen/creatediary/editdiary.dart';
import 'package:daily_diary/ui/allbottomscreen/homesection/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class HomeScreen extends GetView {
  HomeScreen({super.key});

  final HomeController hc = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextModel('myDiary', textStyle: Theme.of(context).appBarTheme.titleTextStyle),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const SearchScreen());
            },
            icon: SvgImage(I.search, color: Theme.of(context).appBarTheme.actionsIconTheme!.color),
          ),
          PopupMenuButton(
            icon: SvgImage(I.sort, color: Theme.of(context).appBarTheme.actionsIconTheme!.color),
            offset: const Offset(-20, 40),
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  onTap: () {
                    if (!hc.isSort.value) {
                      hc.isSort.value = !hc.isSort.value;
                      hc.items.sort((a, b) => a.date.compareTo(b.date));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextModel('newestFirst', fontSize: 13.sp),
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: Obx(() {
                          return hc.isSort.value ? Icon(Icons.check_box, color: Theme.of(context).hintColor) : const Icon(Icons.check_box_outline_blank);
                        }),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  onTap: () {
                    if (hc.isSort.value) {
                      hc.isSort.value = !hc.isSort.value;
                      hc.items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextModel('latestFirst', fontSize: 13.sp),
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: Obx(() {
                          return !hc.isSort.value ? Icon(Icons.check_box, color: Theme.of(context).hintColor) : const Icon(Icons.check_box_outline_blank);
                        }),
                      ),
                    ],
                  ),
                )
              ];
            },
          ),
        ],
      ),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          hc.isVisible.value = true;
        },
        autoRebuild: false,
        child: Obx(() {
          if (hc.isLoad.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (hc.items.isNotEmpty) {
            return AnimationLimiter(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 20.h, right: 20.w, left: 20.w, top: 10.h),
                separatorBuilder: (context, index) {
                  if ((index + 1) % 10 == 0) {
                    return Padding(padding: EdgeInsets.symmetric(vertical: 5.h), child: ApplovinAds.showBannerAds());
                  }
                  return SizedBox(height: 10.h);
                },
                itemCount: hc.items.length,
                itemBuilder: (context, index) {
                  final DiaryModel diary = hc.items[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50,
                      duration: const Duration(milliseconds: 375),
                      child: FadeInAnimation(
                        child: Slidable(
                          endActionPane: ActionPane(
                            dragDismissible: false,
                            motion: const BehindMotion(),
                            extentRatio: .3,
                            children: [
                              CustomSlidableAction(
                                borderRadius: BorderRadius.circular(16.r),
                                backgroundColor: Colors.red,
                                onPressed: (v) {
                                  showDeleteDialog(context, onTap: () async {
                                    await DatabaseHelper.removeDiary(diary.id!);
                                    hc.items.removeAt(index);
                                    hc.refresh();
                                    Get.back();
                                  });
                                },
                                child: SvgImage(I.deleteData, color: Colors.white, fit: BoxFit.cover, height: 32.w, width: 32.w),
                              ),
                            ],
                          ),
                          child: DiaryBox(
                            diary: diary,
                            onTap: () {
                              Get.to(() => EditDiary(diary: diary));
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ApplovinAds.showBannerAds(),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      margin: EdgeInsets.all(20.w),
                      child: CustomPaint(
                        painter: RPSCustomPainter(color: Theme.of(context).bottomNavigationBarTheme.backgroundColor!),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 24.h),
                              SvgImage(isDark ? I.firstStoryDark : I.firstStorylight, width: 140.w, height: 140.w),
                              SizedBox(height: 30.h),
                              TextModel('firstStoryText', fontSize: 16.sp, fontFamily: "B", maxLines: 1, textAlign: TextAlign.center),
                              SizedBox(height: 8.h),
                              TextModel('firstDiaryText', fontSize: 13.sp, maxLines: 1, textAlign: TextAlign.center),
                              SizedBox(height: 40.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
        builder: (BuildContext context, Widget child, IndicatorController controller) {
          if (controller.isScrollingReverse && hc.isVisible.value) {
            hc.isVisible.value = false;
          }
          return Column(
            children: <Widget>[
              Obx(() {
                hc.isVisible.value;
                isSubscribe.value;
                return AnimatedOpacity(
                  duration: Duration(seconds: 1),
                  opacity: hc.isVisible.value ? 1.0 : 0.0,
                  curve: Curves.ease,
                  alwaysIncludeSemantics: true,
                  child: Visibility(
                    visible: hc.isVisible.value,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h, right: 24.w, left: 24.w, top: 10.h),
                      child: ListTile(
                        onTap: !isSubscribe.value
                            ? () {
                                hc.isVisible.value = false;
                                Get.to(() => SubscriptionPlan());
                              }
                            : () {
                                hc.isVisible.value = false;
                                final String? hide = Storages.read('hide');
                                if (hide == null) {
                                  setPasswordSheet(context, hide ?? "", onSave: () {});
                                } else {
                                  showPasswordSheet(context, hide);
                                }
                              },
                        tileColor: Theme.of(context).primaryColor,
                        dense: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        leading: isSubscribe.value
                            ? SvgImage(I.password, color: Theme.of(context).hintColor, height: 22.w, width: 22.w, fit: BoxFit.scaleDown)
                            : SvgImage(I.premium, color: Theme.of(context).hintColor, height: 22.w, width: 22.w, fit: BoxFit.scaleDown),
                        title: TextModel('Lock_Diary', fontFamily: 'B', fontSize: 14.sp, textAlign: TextAlign.start, color: Theme.of(context).hintColor),
                        trailing: SvgImage(I.arrowRight, color: Theme.of(context).hintColor, width: 18.w, height: 18.w, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              }),
              Expanded(
                child: AnimatedBuilder(
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0.0, controller.value * 150.h),
                      child: child,
                    );
                  },
                  animation: controller,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
