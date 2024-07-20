import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/staticdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'color.dart';

class DiaryBox extends StatelessWidget {
  const DiaryBox({super.key, required this.diary, this.onTap});

  final DiaryModel diary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    TextStyle style({double? fontSize, FontWeight? fontWeight, String? fontFamily}) {
      return Option.style(diary.style.code, fontFamily: fontFamily, fontWeight: fontWeight ?? diary.style.fontWeight, fontSize: fontSize, color: Color(diary.style.color));
    }

    final TextAlign align = diary.style.align;

    return Container(
      decoration: diary.bgImg.isNotEmpty
          ? BoxDecoration(
              image: DecorationImage(image: AssetImage(diary.bgImg), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(12.r),
            )
          : BoxDecoration(
              color: Color(diary.bgColor),
              borderRadius: BorderRadius.circular(12.r),
            ),
      padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Obx(() {
                    return TextModel(DateFormat(dateFormat.value, Storages.read('languageCode')).format(DateTime.parse(diary.date)), fontSize: 20.sp, fontFamily: "B", color: Color(diary.style.color));
                  }),
                  SizedBox(height: 5.h),
                  TextModel(DateFormat('EEEE hh:mm a', Storages.read('languageCode')).format(DateTime.parse(diary.date)), fontSize: 12.sp, color: Color(diary.style.color)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (diary.emoji.isNotEmpty) Image.asset(diary.emoji, width: 60.w, height: 60.w, fit: BoxFit.cover),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12.r), bottomLeft: Radius.circular(8.r)),
                      color: StaticsItem.category[diary.catIndex]['color'],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgImage(StaticsItem.category[diary.catIndex]['icon'], color: Colors.white, height: 16.w, width: 16.w, fit: BoxFit.cover),
                        if (diary.notification) ...[
                          SizedBox(width: 5.w),
                          SvgImage(I.clock, color: Colors.white, height: 16.w, width: 16.w, fit: BoxFit.cover),
                        ],
                        if (diary.pdf.isNotEmpty) ...[
                          SizedBox(width: 5.w),
                          SvgImage(I.pdf, color: Colors.white, height: 16.w, width: 16.w, fit: BoxFit.cover),
                        ],
                        if (diary.items.isNotEmpty) ...[
                          SizedBox(width: 5.w),
                          SvgImage(I.task_fill, color: Colors.white, height: 16.w, width: 16.w, fit: BoxFit.cover),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5.h),
          TextModel(
            diary.title,
            textStyle: style(fontSize: 16.sp, fontFamily: "B"),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            padding: EdgeInsets.only(right: 16.w),
            textAlign: align,
          ),
          SizedBox(height: 5.h),
          TextModel(
            diary.description,
            textStyle: style(fontSize: 13.sp),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            padding: EdgeInsets.only(right: 16.w),
            textAlign: align,
          ),
          SizedBox(height: 5.h),
          if (diary.images.isNotEmpty)
            GridView.builder(
              itemCount: (diary.images.length > 3) ? 4 : diary.images.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 15.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: isTab(context) ? 1.6 : 1, mainAxisSpacing: 5.h, crossAxisSpacing: 5.w),
              itemBuilder: (context, i) {
                if (i == 3 && diary.images.length > 3) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextModel('+ ${diary.images.length - 3}', fontFamily: "B"),
                  );
                }
                final String file = diary.images[i];
                return ImageView.file(file, width: MediaQuery.sizeOf(context).width, height: MediaQuery.sizeOf(context).height);
              },
            ),
        ],
      ),
    ).onTap(onTap);
  }
}

Future<List<DateTime?>?> datePicker(context) async {
  return await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
        closeDialogOnCancelTapped: true,
        closeDialogOnOkTapped: true,
        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year + 2),
        cancelButton: Button(title: 'cancel'.tr, width: 140.w, buttonColor: Colors.white, titleColor: lightBlack),
        okButton: Button(title: 'save'.tr, width: 140.w),
        buttonPadding: EdgeInsets.symmetric(horizontal: 10.w),
        calendarType: CalendarDatePicker2Type.single,
        controlsTextStyle: TextStyle(fontFamily: 'M', fontSize: 18.sp),
        yearTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
        selectedDayHighlightColor: Theme.of(context).hintColor,
        yearBuilder: ({decoration, isCurrentYear, isDisabled, isSelected, textStyle, required year}) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: isCurrentYear == true ? Border.all(color: Theme.of(context).hintColor, width: 2.w) : null),
            child: TextModel(year.toString(), fontFamily: "M", fontSize: 16.sp, color: isDisabled == true ? grey : Theme.of(context).colorScheme.primary),
          );
        },
        monthBuilder: ({decoration, isCurrentMonth, isDisabled, isSelected, required month, textStyle}) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: isCurrentMonth == true ? Border.all(color: Theme.of(context).hintColor, width: 2.w) : null),
            child: TextModel(DateFormat().dateSymbols.SHORTMONTHS[month - 1], fontFamily: "M", fontSize: 16.sp, color: isDisabled == true ? grey : Theme.of(context).colorScheme.primary),
          );
        },
        selectedDayTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
        monthTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
        todayTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
        dayBorderRadius: BorderRadius.circular(8.r),
        yearBorderRadius: BorderRadius.circular(8.r),
        weekdayLabelTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: grey),
        dayTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp)),
    dialogSize: Size(MediaQuery.of(context).size.width, 406.h),
    barrierDismissible: false,
    borderRadius: BorderRadius.circular(15.r),
  );
}
