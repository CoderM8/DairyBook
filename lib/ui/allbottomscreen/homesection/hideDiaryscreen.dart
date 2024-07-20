import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/allwidgets/diarybox.dart';
import 'package:daily_diary/allwidgets/passcode.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/ui/allbottomscreen/creatediary/editdiary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class HideDiary extends GetView {
  const HideDiary({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool isDelete = false.obs;
    return Scaffold(
      appBar: AppBar(
        leading: const Back(),
        actions: [
          PopupMenuButton(
            icon: SvgImage(I.more, color: Theme.of(context).colorScheme.primary),
            offset: const Offset(-10, 40),
            color: Theme.of(context).primaryColor,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  padding: EdgeInsets.zero,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
                      ),
                      builder: (context) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.9,
                          minChildSize: 0.2,
                          maxChildSize: 1,
                          expand: true,
                          builder: (_, controller) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor.withOpacity(.7),
                                    child: SvgImage(
                                      I.arrowDown,
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 10.w,
                                      height: 10.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ).onTap(() {
                                    Get.back();
                                  }),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgImage(I.password, height: 25.w, width: 25.w, color: Theme.of(context).hintColor, fit: BoxFit.cover),
                                    SizedBox(height: 15.h),
                                    TextModel('change_password', fontSize: 17.sp, fontFamily: "B"),
                                  ],
                                ),
                                SizedBox(height: 30.h),
                                PasscodeScreen(
                                  onSuccess: (String value) {
                                    print('Hello enter onSuccess value: $value');
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
                                                TextModel('Update_Password', textStyle: Theme.of(context).dialogTheme.titleTextStyle),
                                                SizedBox(height: 12.h),
                                                TextModel("dairy_text",
                                                    textStyle: Theme.of(context).dialogTheme.titleTextStyle!.copyWith(fontSize: 16.sp, fontFamily: 'M'), textAlign: TextAlign.center),
                                                SizedBox(height: 32.h),
                                                Button(
                                                  title: 'save',
                                                  onTap: () {
                                                    Storages.write("hide", value);
                                                    Get.back();
                                                    Get.back();
                                                  },
                                                ),
                                                SizedBox(height: 10.h),
                                                Button(
                                                    title: 'cancel',
                                                    buttonColor: Colors.transparent,
                                                    titleColor: Theme.of(context).colorScheme.primary,
                                                    onTap: () {
                                                      Get.back();
                                                      Get.back();
                                                    }),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  onEntered: (String value) {},
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgImage(
                        I.password,
                        color: Theme.of(context).colorScheme.primary,
                        height: 18.w,
                        width: 18.w,
                        fit: BoxFit.scaleDown,
                      ),
                      SizedBox(width: 8.w),
                      TextModel('change_password', fontSize: 12.sp, fontFamily: 'M'),
                    ],
                  ),
                )
              ];
            },
          ),
        ],
      ),
      body: Obx(() {
        isDelete.value;
        return FutureBuilder<List<DiaryModel>>(
          future: DatabaseHelper.getMyHideDiary(),
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return AnimationLimiter(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 24.h, right: 24.w, left: 24.w),
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final DiaryModel diary = snapshot.data![index];
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
                                      Get.back();
                                      isDelete.value = !isDelete.value;
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
              return Center(
                child: TextModel("No_results", fontSize: 18.sp, fontFamily: "B"),
              );
            }
          },
        );
      }),
    );
  }
}
