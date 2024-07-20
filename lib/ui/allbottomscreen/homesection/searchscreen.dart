import 'package:daily_diary/ads/ads.dart';
import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/allwidgets/diarybox.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/getcontroller/homecontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/ui/allbottomscreen/creatediary/editdiary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final RxString search = "".obs;
  final TextEditingController textEditingController = TextEditingController();
  final HomeController hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Back(),
        titleSpacing: 0,
        title: TextFormField(
          controller: textEditingController,
          style: Theme.of(context).textTheme.displayMedium,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            fillColor: Theme.of(context).bottomSheetTheme.backgroundColor,
            filled: true,
            hintText: "Search".tr,
            hintStyle: Theme.of(context).textTheme.displayMedium,
            prefixIcon: SvgImage(I.search, color: Theme.of(context).appBarTheme.actionsIconTheme!.color, height: 24.w, width: 24.w, fit: BoxFit.scaleDown),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none),
          ),
          onChanged: (value) {
            search.value = value;
          },
        ),
        actions: [
          SizedBox(width: 10.w),
          SvgImage(
            I.close,
            color: Theme.of(context).unselectedWidgetColor,
            height: 24.w,
            width: 24.w,
            fit: BoxFit.scaleDown,
            onTap: () {
              textEditingController.clear();
              search.value = "";
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Obx(() {
        hc.isDelete.value;
        return FutureBuilder<List<DiaryModel>>(
          future: DatabaseHelper.searchByTitle(search.value),
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return AnimationLimiter(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 20.h, right: 20.w, left: 20.w, top: 10.h),
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
                              onTap: () async {
                                await ApplovinAds.showInterAds();
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
