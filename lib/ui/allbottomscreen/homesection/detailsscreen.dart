import 'package:daily_diary/ads/ads.dart';
import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/allwidgets/textfield.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/getcontroller/homecontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/ui/allbottomscreen/creatediary/editdiary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({super.key, required this.diary});

  final DiaryModel diary;
  final HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final TextAlign align = diary.style.align;
    TextStyle style({double? fontSize, FontWeight? fontWeight, String? fontFamily}) {
      return Option.style(diary.style.code, fontFamily: fontFamily, fontWeight: fontWeight ?? diary.style.fontWeight, fontSize: fontSize);
    }

    return Scaffold(
      backgroundColor: Color(diary.bgColor),
      appBar: AppBar(
        leading: const Back(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: SvgImage(
              I.more,
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 4.h,
                          width: 48.w,
                          margin: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: const Color(0xffD9D9D9)),
                        ),
                        Divider(color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
                          leading: SvgImage(I.share, color: Theme.of(context).colorScheme.primary, width: 20.w, height: 20.w, fit: BoxFit.cover),
                          title: TextModel("share", color: Theme.of(context).colorScheme.primary, fontSize: 16.sp),
                          dense: true,
                          onTap: () async {
                            await Share.share('Daily Dairy \n ${diary.title} ${diary.emoji}');
                          },
                        ),
                        Divider(color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
                          leading: SvgImage(I.edit, color: Theme.of(context).colorScheme.primary, width: 20.w, height: 20.w, fit: BoxFit.cover),
                          title: TextModel("edit", color: Theme.of(context).colorScheme.primary, fontSize: 16.sp),
                          dense: true,
                          onTap: () async {
                            Get.back();
                            await ApplovinAds.showInterAds();
                            Get.to(() => EditDiary(diary: diary));
                          },
                        ),
                        Divider(color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
                          leading: SvgImage(I.delete, color: Theme.of(context).colorScheme.primary, width: 20.w, height: 20.w, fit: BoxFit.cover),
                          title: TextModel("delete", color: Theme.of(context).colorScheme.primary, fontSize: 16.sp),
                          dense: true,
                          onTap: () {
                            showDeleteDialog(context, onTap: () async {
                              await DatabaseHelper.removeDiary(diary.id!);
                              hc.items.removeWhere((element) => element.id == diary.id);
                              Get.back();
                              Get.back();
                              Get.back();
                            });
                          },
                        ),
                        SizedBox(height: 32.h)
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: InkWell(
            onTap: () async {
              await ApplovinAds.showInterAds();
              Get.to(() => EditDiary(diary: diary));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextModel(DateFormat('MM/dd').format(DateTime.parse(diary.date)), textStyle: style(fontSize: 20.sp, fontFamily: "B"), textAlign: align),
                        SizedBox(height: 10.h),
                        TextModel(DateFormat('EEEE hh:mm a').format(DateTime.parse(diary.date)), textStyle: style(fontSize: 12.sp), textAlign: align),
                      ],
                    ),
                    if (diary.emoji.isNotEmpty) TextModel(diary.emoji, fontSize: 30.sp),
                  ],
                ),
                SizedBox(height: 20.h),
                TextModel(diary.title, textStyle: style(fontSize: 16.sp, fontFamily: "B"), maxLines: 1, textAlign: align),
                SizedBox(height: 10.h),
                TextModel(diary.description, textStyle: style(fontSize: 13.sp), textAlign: align),
                SizedBox(height: 20.h),
                if (diary.items.isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: diary.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgImage(I.arrow_down_up, height: 18.w, width: 18.w, fit: BoxFit.scaleDown, color: Theme.of(context).colorScheme.primary),
                            SizedBox(width: 10.w),
                            diary.items[index].completed
                                ? SvgImage(I.task_fill, height: 20.w, width: 20.w, color: Theme.of(context).colorScheme.primary)
                                : SvgImage(I.task, height: 20.w, width: 20.w, fit: BoxFit.scaleDown, color: Theme.of(context).colorScheme.primary),
                          ],
                        ),
                        title: TextFieldModel(
                          readOnly: true,
                          textController: TextEditingController(text: diary.items[index].title),
                          textInputAction: TextInputAction.done,
                          decoration: diary.items[index].completed ? TextDecoration.lineThrough : TextDecoration.none,
                          hint: diary.items[index].title,
                          suffix: SvgImage(
                            I.close,
                            height: 18.w,
                            width: 18.w,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SvgImage(I.add, height: 15.w, width: 15.w, fit: BoxFit.scaleDown),
                    title: TextFieldModel(
                      readOnly: true,
                      textController: TextEditingController(),
                      textInputAction: TextInputAction.next,
                      hint: 'Add a task...',
                    ),
                  ),
                ],
                if (diary.images.isNotEmpty)
                  GridView.builder(
                    itemCount: diary.images.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: isTab(context) ? 1.6 : 1, crossAxisSpacing: 5.w, mainAxisSpacing: 5.h),
                    itemBuilder: (context, index) {
                      final String file = diary.images[index];
                      return ImageView.file(file, width: MediaQuery.sizeOf(context).width, height: MediaQuery.sizeOf(context).height);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
