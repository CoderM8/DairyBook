import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/color.dart';
import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/allwidgets/diarybox.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/getcontroller/homecontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/subscription/configPremium.dart';
import 'package:daily_diary/subscription/subscription.dart';
import 'package:daily_diary/ui/allbottomscreen/creatediary/editdiary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends GetView {
  CalendarScreen({super.key});

  final HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Obx(() {
              hc.isDelete.value;
              hc.nowDate.value;
              return Column(
                children: [
                  SizedBox(height: 40.h),
                  FutureBuilder(
                      future: DatabaseHelper.getMyDiary(),
                      builder: (context, snapshot) {
                        return CalendarDatePicker2(
                          config: CalendarDatePicker2WithActionButtonsConfig(
                              firstDate: DateTime(DateTime.now().year, DateTime.now().month),
                              lastDate: DateTime(DateTime.now().year + 2),
                              calendarType: CalendarDatePicker2Type.single,
                              controlsTextStyle: TextStyle(fontFamily: 'M', fontSize: 18.sp),
                              yearTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
                              monthTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
                              selectedDayHighlightColor: Theme.of(context).hintColor,
                              monthBuilder: ({decoration, isCurrentMonth, isDisabled, isSelected, required month, textStyle}) {
                                return Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: isCurrentMonth == true ? Border.all(color: Theme.of(context).hintColor, width: 2.w) : null),
                                  child: TextModel(DateFormat().dateSymbols.SHORTMONTHS[month - 1],
                                      fontFamily: "M", fontSize: 16.sp, color: isDisabled == true ? grey : Theme.of(context).colorScheme.primary),
                                );
                              },
                              dayBuilder: ({required date, decoration, isDisabled, isSelected, isToday, textStyle}) {
                                if (isSelected == true) {
                                  return Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).hintColor),
                                    child: TextModel(date.day.toString(), fontFamily: "M", fontSize: 16.sp, color: isDisabled == true ? grey : Theme.of(context).colorScheme.primary),
                                  );
                                }
                                for (DiaryModel element in snapshot.data ?? []) {
                                  if (isToday == false &&
                                      date.day == DateTime.parse(element.date).day &&
                                      date.month == DateTime.parse(element.date).month &&
                                      date.year == DateTime.parse(element.date).year) {
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          TextModel(date.day.toString(), fontFamily: "M", fontSize: 16.sp, color: isDisabled == true ? grey : Theme.of(context).colorScheme.primary),
                                          CircleAvatar(backgroundColor: Theme.of(context).hintColor, radius: 4.r),
                                        ],
                                      ),
                                    );
                                  }
                                }
                                return Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: isToday == true ? Border.all(color: Theme.of(context).hintColor, width: 2.w) : null),
                                  child: TextModel(date.day.toString(), fontFamily: "M", fontSize: 16.sp, color: isDisabled == true ? grey : Theme.of(context).colorScheme.primary),
                                );
                              },
                              yearBuilder: ({decoration, isCurrentYear, isDisabled, isSelected, textStyle, required year}) {
                                return Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: isCurrentYear == true ? Border.all(color: Theme.of(context).hintColor, width: 2.w) : null),
                                  child: TextModel(year.toString(), fontFamily: "M", fontSize: 16.sp, color: isDisabled == true ? grey : Theme.of(context).colorScheme.primary),
                                );
                              },
                              selectedDayTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
                              todayTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
                              dayBorderRadius: BorderRadius.circular(8.r),
                              yearBorderRadius: BorderRadius.circular(8.r),
                              weekdayLabelTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: grey),
                              dayTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp)),
                          value: [],
                          onValueChanged: (dates) {
                            if (dates.isNotEmpty) {
                              hc.nowDate.value = dates[0];
                            }
                          },
                        );
                      }),
                  SizedBox(height: 5.h),
                  FutureBuilder(
                    future: DatabaseHelper.getMyDiaryByDate(hc.nowDate.value),
                    builder: (context, md) {
                      if (md.connectionState == ConnectionState.done) {
                        if (md.hasData && md.data!.isNotEmpty) {
                          return AnimationLimiter(
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 24.h, right: 22.w, left: 20.w),
                              separatorBuilder: (context, index) => SizedBox(height: 10.h),
                              itemCount: md.data!.length,
                              itemBuilder: (context, index) {
                                final DiaryModel diary = md.data![index];
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
                                                    md.data!.removeAt(index);
                                                    hc.items.removeWhere((element) => element.id == diary.id);
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
                                          )),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: TextModel('no_diary', fontSize: 16.sp, fontFamily: 'B'),
                          );
                        }
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: const CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                ],
              );
            }),
          ),
          Obx(() {
            if (isSubscribe.value) {
              return const SizedBox.shrink();
            }
            return Container(
              alignment: Alignment.center,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgImage(I.premium, color: Theme.of(context).hintColor, height: 40.w, width: 40.w, fit: BoxFit.cover),
                  SizedBox(height: 20.h),
                  TextModel(
                    'Subscribe_text',
                    fontSize: 18.sp,
                    fontFamily: 'B',
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Button(
                    width: 250.w,
                    onTap: () {
                      Get.to(() => SubscriptionPlan());
                    },
                    title: 'Subscribe_now',
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
