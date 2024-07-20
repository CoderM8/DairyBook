import 'package:daily_diary/ads/ads.dart';
import 'package:daily_diary/ads/adsoptiondialog.dart';
import 'package:daily_diary/allwidgets/passcode.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/getcontroller/creatediarycontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/staticdata.dart';
import 'package:daily_diary/subscription/configPremium.dart';
import 'package:daily_diary/subscription/subscription.dart';
import 'package:daily_diary/ui/allbottomscreen/homesection/hideDiaryscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'button.dart';

Future showEmojiPickerSheet(context, CreateController cc) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 20.h, right: 20.w),
                child: IconButton(
                    onPressed: () {
                      if (cc.selectedEmojiValue.value.isNotEmpty) {
                        cc.selectedEmojiValue.value = "";
                      }
                      Get.back();
                    },
                    icon: Icon(Icons.close, size: 25.sp),
                    color: Theme.of(context).colorScheme.primary),
              )),
          TextModel('feelingText', fontFamily: "M", fontSize: 20.sp),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: StaticsItem.emojiList.length,
            padding: EdgeInsets.all(20.r),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: isTab(context) ? 1.6 : 1, crossAxisSpacing: 15.w, mainAxisSpacing: 15.h),
            itemBuilder: (context, index) {
              return Obx(() {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: index == cc.selectedEmojiIndex.value ? Border.all(width: 3.w, color: Theme.of(context).hintColor) : null,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(StaticsItem.emojiList[index]),
                    ),
                  ),
                ).onTap(() {
                  cc.selectedEmojiIndex.value = index;
                });
              });
            },
          ),
          SizedBox(height: 20.h),
          Button(
            title: 'save',
            width: MediaQuery.sizeOf(context).width,
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            onTap: () {
              cc.selectedEmojiValue.value = StaticsItem.emojiList[cc.selectedEmojiIndex.value];
              Get.back();
            },
          ),
          SizedBox(height: 20.h),
        ],
      );
    },
  );
}

Future showBgPickerSheet(context, CreateController cc) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.2,
        maxChildSize: 0.7,
        expand: false,
        builder: (_, controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Row(
                    children: [
                      SizedBox(width: 30.r),
                      SvgImage(I.arrowDown, color: Theme.of(context).colorScheme.primary, width: 10.w, height: 10.w, fit: BoxFit.cover),
                      SizedBox(width: 20.w),
                      TextModel('background', fontFamily: "M", fontSize: 20.sp),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Button(
                    width: 44.w,
                    height: 32.h,
                    icon: SvgImage(I.check, width: 12.w, height: 12.w, fit: BoxFit.cover),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: TextStyle(fontFamily: "B", fontSize: 14.sp),
                      unselectedLabelStyle: TextStyle(fontFamily: "M", fontSize: 14.sp),
                      tabs: [
                        Tab(text: 'Color'),
                        Tab(text: 'Custom'),
                        Tab(text: 'Background'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          /// COLOR
                          GridView.builder(
                            controller: controller,
                            itemCount: StaticsItem.colorList.length + 1,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(18.r),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 75.w / 80.w, mainAxisSpacing: 5.h, crossAxisSpacing: 5.w),
                            itemBuilder: (context, i) {
                              return Obx(() {
                                isSubscribe.value;
                                if (i == 0) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: cc.selectedBg.value == 0 ? Border.all(color: Theme.of(context).hintColor, width: 3.w) : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.not_interested, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
                                        SizedBox(height: 5.h),
                                        TextModel('default', color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor, fontSize: 11.sp),
                                      ],
                                    ),
                                  ).onTap(() {
                                    if (cc.selectedBgImgValue.value.isNotEmpty) {
                                      cc.selectedBgImgValue.value = "";
                                    }
                                    cc.selectedBg.value = 0;
                                  });
                                }
                                final Color color = StaticsItem.colorList[i - 1]['Color'] as Color;
                                return Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: cc.selectedBg.value == color.value ? Border.all(color: color, width: 3.w) : null,
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: (StaticsItem.colorList[i - 1]['Type'].toString().contains('PAID') && !isSubscribe.value)
                                        ? SvgImage(I.premium, width: 14.w, height: 14.w, fit: BoxFit.cover, color: Colors.white)
                                        : null,
                                  ).onTap(() {
                                    if (cc.selectedBgImgValue.value.isNotEmpty) {
                                      cc.selectedBgImgValue.value = "";
                                    }
                                    if (StaticsItem.colorList[i - 1]['Type'].toString().contains('FREE') || isSubscribe.value) {
                                      cc.selectedBg.value = color.value;
                                    }
                                  }),
                                );
                              });
                            },
                          ),

                          /// custom color
                          ListView(
                            shrinkWrap: true,
                            controller: controller,
                            children: [
                              SizedBox(height: 20.h),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ColorPicker(
                                    colorPickerWidth: MediaQuery.sizeOf(context).width / 1.2,
                                    pickerAreaHeightPercent: .5,
                                    pickerAreaBorderRadius: BorderRadius.circular(10.r),
                                    pickerColor: Theme.of(context).scaffoldBackgroundColor,
                                    hexInputBar: true,
                                    onColorChanged: (Color value) {
                                      if (cc.selectedBgImgValue.value.isNotEmpty) {
                                        cc.selectedBgImgValue.value = "";
                                      }
                                      cc.selectedBg.value = value.value;
                                    },
                                  ),
                                  if (!isSubscribe.value)
                                    Container(
                                      height: MediaQuery.sizeOf(context).width,
                                      color: Theme.of(context).primaryColor.withOpacity(.8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 20.h),
                                          SvgImage(I.premium, color: Theme.of(context).hintColor, height: 40.w, width: 40.w, fit: BoxFit.cover),
                                          SizedBox(height: 20.h),
                                          TextModel(
                                            'Subscribe_text',
                                            fontSize: 16.sp,
                                            fontFamily: 'B',
                                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 20.h),
                                          Button(
                                            width: 250.w,
                                            onTap: () {
                                              Get.back();
                                              Get.to(() => SubscriptionPlan());
                                            },
                                            title: 'Subscribe_now',
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),

                          /// BG IMAGE
                          GridView.builder(
                            controller: controller,
                            itemCount: StaticsItem.bgImageList.length + 1,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(18.r),
                            // physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 75.w / 130.w, mainAxisSpacing: 5.h, crossAxisSpacing: 5.w),
                            itemBuilder: (context, i) {
                              return Obx(() {
                                isSubscribe.value;
                                if (i == 0) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: cc.selectedBgImgIndex.value == 0 ? Border.all(color: Theme.of(context).hintColor, width: 3.w) : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.not_interested, color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
                                        SizedBox(height: 5.h),
                                        TextModel('default', color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor, fontSize: 11.sp),
                                      ],
                                    ),
                                  ).onTap(() {
                                    cc.selectedBgImgIndex.value = 0;
                                    cc.selectedBgImgValue.value = "";
                                  });
                                }
                                return Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: cc.selectedBgImgIndex.value == i ? Border.all(color: Theme.of(context).hintColor, width: 3.w) : null,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage(StaticsItem.bgImageList[i - 1]['Img'].toString()), fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: (StaticsItem.bgImageList[i - 1]['Type'].toString().contains('PAID') && !isSubscribe.value)
                                        ? SvgImage(I.premium, width: 14.w, height: 14.w, fit: BoxFit.cover, color: Colors.white)
                                        : null,
                                  ).onTap(() {
                                    if (StaticsItem.bgImageList[i - 1]['Type'].toString().contains('FREE') || isSubscribe.value) {
                                      cc.selectedBgImgIndex.value = i;
                                      cc.selectedBgImgValue.value = StaticsItem.bgImageList[i - 1]['Img'].toString();
                                    }
                                  }),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future showFontPickerSheet(context, CreateController cc) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
    ),
    builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Row(
                  children: [
                    SizedBox(width: 30.r),
                    SvgImage(I.arrowDown, color: Theme.of(context).colorScheme.primary, width: 10.w, height: 10.w, fit: BoxFit.cover),
                    SizedBox(width: 20.w),
                    TextModel('font', fontFamily: "M", fontSize: 20.sp),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Button(
                  width: 44.w,
                  height: 32.h,
                  icon: SvgImage(I.check, width: 12.w, height: 12.w, fit: BoxFit.cover),
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          /// SELECT FONT-SIZE AND ALIGNMENT
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Row(
                    children: List.generate(StaticsItem.fontWeightList.length, (index) {
                      return Obx(() {
                        cc.selectedFontWeightIndex.value;
                        return Container(
                          height: 44.w,
                          width: 46.w,
                          padding: EdgeInsets.all((10 - index * 3).r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: cc.selectedFontWeightIndex.value == index ? Theme.of(context).hintColor : null,
                          ),
                          child: SvgImage(I.pickFont, color: cc.selectedFontWeightIndex.value == index ? Colors.white : Theme.of(context).colorScheme.primary),
                        ).onTap(() {
                          cc.selectedFontWeightIndex.value = index;
                        });
                      });
                    }),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Row(
                    children: List.generate(StaticsItem.alignList.length, (index) {
                      return Obx(() {
                        cc.selectedAlignIndex.value;
                        return Container(
                          height: 44.w,
                          width: 46.w,
                          padding: EdgeInsets.all((index * 5).r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: cc.selectedAlignIndex.value == index ? Theme.of(context).hintColor : null,
                          ),
                          child: Icon(StaticsItem.alignList[index].value, color: cc.selectedAlignIndex.value == index ? Colors.white : Theme.of(context).colorScheme.primary),
                        ).onTap(() {
                          cc.selectedAlignIndex.value = index;
                        });
                      });
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          /// SELECT FONT COLOR
          SizedBox(
            height: 32.w,
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.w),
              scrollDirection: Axis.horizontal,
              itemCount: StaticsItem.fontColorList.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  cc.selectedTextColor.value;
                  return Container(
                    height: 34.w,
                    width: 34.w,
                    decoration: BoxDecoration(
                      border: cc.selectedTextColor.value == StaticsItem.fontColorList[index].value ? Border.all(color: StaticsItem.fontColorList[index], width: 2.w) : null,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      height: 32.w,
                      width: 32.w,
                      margin: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: StaticsItem.fontColorList[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }).onTap(() {
                  cc.selectedTextColor.value = StaticsItem.fontColorList[index].value;
                });
              },
              separatorBuilder: (context, i) => SizedBox(width: 5.w),
            ),
          ),

          /// SELECT FONT-FAMILY
          GridView.builder(
            itemCount: StaticsItem.fontFamilyList.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(24.r),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 98.w / 53.w, mainAxisSpacing: 16.h, crossAxisSpacing: 16.w),
            itemBuilder: (context, index) {
              return Obx(() {
                cc.selectedFontFamilyIndex.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: cc.selectedFontFamilyIndex.value == index ? Theme.of(context).hintColor : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: TextModel(StaticsItem.fontFamilyList[index]['Name'].toString(),
                          textStyle: Option.style(StaticsItem.fontFamilyList[index]['Name'].toString(),
                              fontFamily: 'B', fontSize: 14.sp, color: cc.selectedFontFamilyIndex.value == index ? Colors.white : Theme.of(context).colorScheme.primary)),
                    ),
                    if (StaticsItem.fontFamilyList[index]['Type'].toString().contains('PAID') && !isSubscribe.value)
                      Positioned(top: 5.h, right: 5.w, child: SvgImage(I.premium, width: 10.w, height: 10.w, fit: BoxFit.cover, color: Colors.white)),
                  ],
                );
              }).onTap(() {
                if (StaticsItem.fontFamilyList[index]['Type'].toString().contains('FREE') || isSubscribe.value) {
                  cc.selectedFontFamilyIndex.value = index;
                } else {
                  if (showAds.value) {
                    Storages.write('index', index);
                    showAdsOption(context);
                  } else {
                    Get.back();
                    Get.to(() => SubscriptionPlan());
                  }
                }
              });
            },
          ),
        ],
      );
    },
  );
}

Future showCategorySheet(context, CreateController cc) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.2,
          maxChildSize: 0.7,
          expand: false,
          builder: (_, controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Row(
                        children: [
                          SizedBox(width: 30.r),
                          SvgImage(I.arrowDown, color: Theme.of(context).colorScheme.primary, width: 10.w, height: 10.w, fit: BoxFit.cover),
                          SizedBox(width: 20.w),
                          TextModel('Categories', fontFamily: "M", fontSize: 20.sp),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Button(
                        width: 44.w,
                        height: 32.h,
                        icon: SvgImage(I.check, width: 12.w, height: 12.w, fit: BoxFit.cover),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: GridView.builder(
                    controller: controller,
                    itemCount: StaticsItem.category.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(18.r),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 75.w / 80.w, mainAxisSpacing: 5.h, crossAxisSpacing: 5.w),
                    itemBuilder: (context, i) {
                      return Obx(() {
                        cc.selectedCat.value;
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: cc.selectedCat.value == i ? Border.all(color: StaticsItem.category[i]['color'], width: 3.w) : null,
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: StaticsItem.category[i]['color'],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgImage(StaticsItem.category[i]['icon'], color: Colors.white, height: 25.w, width: 25.w, fit: BoxFit.cover),
                                SizedBox(height: 8.h),
                                TextModel(StaticsItem.category[i]['title'], color: Colors.white, fontFamily: 'SB', fontSize: 13.sp)
                              ],
                            ),
                          ).onTap(() {
                            cc.selectedCat.value = i;
                          }),
                        );
                      });
                    },
                  ),
                ),
              ],
            );
          });
    },
  );
}

Future showPasswordSheet(context, String oldPassword) {
  final RxBool isWrong = false.obs;

  return showModalBottomSheet(
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
              Obx(() {
                if (isWrong.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgImage(I.password, height: 25.w, width: 25.w, color: Colors.red, fit: BoxFit.cover),
                      SizedBox(height: 15.h),
                      TextModel('incorrect_password', fontSize: 17.sp, fontFamily: "B", color: Colors.red),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgImage(I.password, height: 25.w, width: 25.w, color: Theme.of(context).hintColor, fit: BoxFit.cover),
                    SizedBox(height: 15.h),
                    TextModel('enter_password', fontSize: 17.sp, fontFamily: "B"),
                  ],
                );
              }),
              SizedBox(height: 30.h),
              PasscodeScreen(
                oldPassword: oldPassword,
                onSuccess: (String value) async {
                  print('Hello enter onSuccess value: $value -- Lock password: $oldPassword');
                  if (value == oldPassword) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Get.back();
                      Get.to(() => HideDiary());
                    });
                  } else {
                    if (value.length > 3) {
                      isWrong.value = true;
                      await HapticFeedback.vibrate();
                      Future.delayed(Duration(seconds: 1), () {
                        isWrong.value = false;
                      });
                    }
                  }
                },
                onEntered: (String value) {},
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future setPasswordSheet(context, String hide, {required Function onSave}) {
  return showModalBottomSheet(
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
                  TextModel('set_password', fontSize: 17.sp, fontFamily: "B"),
                  SizedBox(height: 8.h),
                  TextModel('feature2', fontSize: 14.sp, fontFamily: "M", textAlign: TextAlign.center),
                ],
              ),
              SizedBox(height: 30.h),
              PasscodeScreen(
                oldPassword: hide,
                onSuccess: (String value) {
                  print('Hello enter onSuccess value: $value password: $hide');
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
                              TextModel('Save_Password', textStyle: Theme.of(context).dialogTheme.titleTextStyle),
                              SizedBox(height: 12.h),
                              TextModel("dairy_text", textStyle: Theme.of(context).dialogTheme.titleTextStyle!.copyWith(fontSize: 16.sp, fontFamily: 'M'), textAlign: TextAlign.center),
                              SizedBox(height: 32.h),
                              Button(
                                title: 'save',
                                onTap: () {
                                  onSave();
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
}
