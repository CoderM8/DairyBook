import 'package:daily_diary/ads/ads.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/getcontroller/homecontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GalleryScreen extends GetView {
  GalleryScreen({super.key});

  final HomeController hc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextModel('gallery', textStyle: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Column(
        children: [
          ApplovinAds.showBannerAds(),
          Obx(() {
            hc.isDelete.value;
            return FutureBuilder<List<DiaryModel>>(
              future: DatabaseHelper.getGalleryDiary(),
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  final List<Widget> groupedMessages = [];

                  groupByDateList<DiaryModel, String>(snapshot.data ?? [], (value) {
                    return DateFormat('dd MMMM, y', Storages.read('languageCode')).format(DateTime.parse(value.date));
                  }).forEach((when, images) {
                    groupedMessages.add(
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h, top: 16.h),
                        child: TextModel(when, fontFamily: 'M', textAlign: TextAlign.start, fontSize: 16.sp),
                      ),
                    );
                    final List<Map<String, dynamic>> groupImage = [];
                    for (final element in images) {
                      for (final img in element.images) {
                        /// ADD ALL IMAGE IN SINGLE LIST FOR SAME DATE
                        groupImage.add({"diary": element.toMap(), "image": img});
                      }
                    }
                    groupedMessages.add(GridView.builder(
                      itemCount: groupImage.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 84.w / 84.w, crossAxisSpacing: 7.w, mainAxisSpacing: 10.h),
                      itemBuilder: (context, index) {
                        return ImageView.file(
                          groupImage[index]['image'],
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height,
                        );
                      },
                    ));
                  });
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      children: groupedMessages,
                    ),
                  );
                } else {
                  return Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 24.h),
                    margin: EdgeInsets.all(24.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgImage(isDark ? I.no_photo_dark : I.no_photo_light, width: 145.w, height: 145.w),
                        SizedBox(height: 20.h),
                        TextModel('no_photo', fontSize: 16.sp, fontFamily: 'B'),
                        SizedBox(height: 5.h),
                        TextModel('no_photo_des', fontSize: 13.sp, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
