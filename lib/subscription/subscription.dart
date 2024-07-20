import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/color.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/statics.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/subscription/configPremium.dart';
import 'package:daily_diary/ui/privacyview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({super.key});

  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

class _SubscriptionPlanState extends State<SubscriptionPlan> with SingleTickerProviderStateMixin {
  final RxInt selectedIndex = 0.obs;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    if (Premium.products.isEmpty) {
      await Premium.getAllProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: TextModel('Choose_your_plan', textStyle: Theme.of(context).appBarTheme.titleTextStyle),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: SvgImage(
              I.close,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              height: 30.w,
              width: 30.w,
              onTap: () {
                Get.back();
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  if (Premium.isLoadPlan.value) {
                    return AnimationLimiter(
                      child: ListView.separated(
                        itemCount: 3,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            child: SlideAnimation(
                              verticalOffset: 50,
                              duration: const Duration(milliseconds: 375),
                              child: FadeInAnimation(
                                curve: Curves.easeIn,
                                child: Shimmer.fromColors(
                                  baseColor: dot.withOpacity(.3),
                                  highlightColor: dot,
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 90.h,
                                        alignment: Alignment.center,
                                        width: MediaQuery.sizeOf(context).width,
                                        padding: EdgeInsets.only(left: 30.w, right: 10.w, bottom: 10.h),
                                        margin: EdgeInsets.only(left: 20.w, right: 20.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Theme.of(context).hintColor),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: index == 1 || index == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                                children: [
                                                  if (index == 1 || index == 0)
                                                    Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(8.r),
                                                            bottomRight: Radius.circular(8.r),
                                                          ),
                                                        ),
                                                        height: 20.h,
                                                        width: 71.w,
                                                        margin: EdgeInsets.only(bottom: 5.h)),
                                                  SizedBox(height: 10.h),
                                                  Container(color: Colors.white, height: 20.h),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 30.w),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(color: Colors.white, height: 20.h, width: 50.w),
                                                Container(color: Colors.white, height: 10.h, width: 50.w, margin: EdgeInsets.symmetric(vertical: 8.h)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index == 0)
                                        Positioned(
                                          left: 8.w,
                                          child: Container(
                                            height: 30.h,
                                            width: 30.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                                            child: Icon(Icons.check, color: Colors.white, size: 20.w),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (Premium.products.isEmpty) {
                    return Center(
                      child: TextModel('No_plans', fontSize: 18.sp, fontFamily: 'M', padding: EdgeInsets.all(20.h)),
                    );
                  }

                  /// REVENUE-CAT STEP: 4
                  return AnimationLimiter(
                    child: ListView.separated(
                      itemCount: Premium.products.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(height: 8.h),
                      itemBuilder: (cont, index) {
                        final StoreProduct product = Premium.products[index];
                        final bool isPopular = product.identifier.contains('year');
                        final bool isBest = product.identifier.contains('lifetime');
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50,
                            child: FadeInAnimation(
                              curve: Curves.easeIn,
                              child: Obx(() {
                                return Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        selectedIndex.value = index;
                                      },
                                      child: AnimatedContainer(
                                          duration: Duration(milliseconds: 375),
                                          curve: Curves.easeIn,
                                          height: 90.h,
                                          alignment: Alignment.center,
                                          width: MediaQuery.sizeOf(context).width,
                                          padding: EdgeInsets.only(left: 30.w, right: 10.w, bottom: 10.h),
                                          margin: EdgeInsets.only(left: 20.w, right: 20.w),
                                          decoration: BoxDecoration(
                                            color: selectedIndex.value == index ? Theme.of(context).hintColor : Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: (isBest || isPopular) ? MainAxisAlignment.start : MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (isBest)
                                                Container(
                                                  height: 23.h,
                                                  width: 80.w,
                                                  padding: EdgeInsets.all(5.w),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: selectedIndex.value == index ? Colors.white : Theme.of(context).hintColor,
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(8.r),
                                                        bottomRight: Radius.circular(8.r),
                                                      )),
                                                  child: TextModel('Best_value', fontFamily: 'M', color: selectedIndex.value == index ? darkBlue : Colors.white, fontSize: 11.sp),
                                                ),
                                              if (isPopular)
                                                Container(
                                                  height: 23.h,
                                                  width: 80.w,
                                                  padding: EdgeInsets.all(5.w),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: selectedIndex.value == index ? Colors.white : Theme.of(context).hintColor,
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(8.r),
                                                        bottomRight: Radius.circular(8.r),
                                                      )),
                                                  child: TextModel('Most_Popular', fontFamily: 'M', color: selectedIndex.value == index ? darkBlue : Colors.white, fontSize: 11.sp),
                                                ),
                                              SizedBox(height: 5.h),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      TextModel(
                                                        product.title,
                                                        fontFamily: "B",
                                                        textAlign: TextAlign.start,
                                                        maxLines: 1,
                                                        fontSize: 16.sp,
                                                        color: selectedIndex.value == index ? Colors.white : Theme.of(context).colorScheme.primary,
                                                        padding: EdgeInsets.symmetric(vertical: 5.h),
                                                      ),
                                                      TextModel(
                                                        "${product.priceString} (${product.description.isNotEmpty ? product.description : (isBest ? "One time" : isPopular ? "Per Year" : "Per Month")}) (${(isBest ? "Forever" : isPopular ? "365 ${"days".tr}" : "30 ${"days".tr}")})",
                                                        fontSize: 12.sp,
                                                        textAlign: TextAlign.start,
                                                        maxLines: 1,
                                                        color: selectedIndex.value == index ? Colors.white : Theme.of(context).colorScheme.primary.withOpacity(.7),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      TextModel(
                                                        product.priceString,
                                                        fontFamily: "B",
                                                        textAlign: TextAlign.start,
                                                        fontSize: 14.sp,
                                                        padding: EdgeInsets.symmetric(vertical: 5.h),
                                                        color: selectedIndex.value == index ? Colors.white : Theme.of(context).colorScheme.primary,
                                                      ),
                                                      TextModel(
                                                        "(${product.description.isNotEmpty ? product.description : (isBest ? "One time" : isPopular ? "Per Year" : "Per Month")})",
                                                        fontSize: 12.sp,
                                                        textAlign: TextAlign.start,
                                                        fontFamily: "M",
                                                        color: selectedIndex.value == index ? Colors.white : Theme.of(context).colorScheme.primary.withOpacity(.5),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                    if (index == selectedIndex.value)
                                      Positioned(
                                        left: 8.w,
                                        child: Container(
                                          height: 30.h,
                                          width: 30.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: Theme.of(context).hintColor, shape: BoxShape.circle, border: Border.all(color: Theme.of(context).primaryColor, width: 3.w)),
                                          child: Icon(Icons.check, color: Colors.white, size: 20.w),
                                        ),
                                      ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.h, bottom: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgImage(I.check_fill, width: 20.w, height: 20.w, color: Theme.of(context).hintColor),
                          SizedBox(width: 15.w),
                          Expanded(child: TextModel("feature1", fontFamily: "M", textAlign: TextAlign.start, fontSize: 14.sp, maxLines: 2)),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          SvgImage(I.check_fill, width: 20.w, height: 20.w, color: Theme.of(context).hintColor),
                          SizedBox(width: 15.w),
                          Expanded(child: TextModel("feature2", fontFamily: "M", textAlign: TextAlign.start, fontSize: 14.sp, maxLines: 2)),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          SvgImage(I.check_fill, width: 20.w, height: 20.w, color: Theme.of(context).hintColor),
                          SizedBox(width: 15.w),
                          Expanded(child: TextModel("feature3", fontFamily: "M", textAlign: TextAlign.start, fontSize: 14.sp, maxLines: 2)),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          SvgImage(I.check_fill, width: 20.w, height: 20.w, color: Theme.of(context).hintColor),
                          SizedBox(width: 15.w),
                          Expanded(child: TextModel("feature4", fontFamily: "M", textAlign: TextAlign.start, fontSize: 14.sp, maxLines: 2)),
                        ],
                      ),
                    ],
                  ),
                ),
                TextModel(
                  "All_feature",
                  fontFamily: "B",
                  textAlign: TextAlign.start,
                  fontSize: 12.sp,
                  maxLines: 2,
                  color: Theme.of(context).hintColor,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                ),
                Obx(() {
                  return Button(
                    enable: Premium.products.isNotEmpty,
                    onTap: () async {
                      await Premium.buySubscription(item: Premium.products[selectedIndex.value]);
                    },
                    margin: EdgeInsets.symmetric(horizontal: 18.w),
                    title: 'purchase_button',
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => PrivacyView(title: "Terms", url: Statics.terms));
                      },
                      child: TextModel('Terms', fontSize: 12.sp, padding: EdgeInsets.all(10.h), maxLines: 2),
                    ),
                    InkWell(onTap: Premium.restoreSubscription, child: TextModel('Restore', fontSize: 12.sp, padding: EdgeInsets.all(10.h))),
                    InkWell(
                      onTap: () {
                        Get.to(() => PrivacyView(title: "Privacy", url: Statics.privacy));
                      },
                      child: TextModel('Privacy', fontSize: 12.sp, padding: EdgeInsets.all(10.h), maxLines: 2),
                    ),
                  ],
                ),
                SizedBox(height: 20.h)
              ],
            ),
          ),
          Obx(() {
            if (!Premium.isPurchasing.value) {
              return const SizedBox.shrink();
            }
            return Container(
              alignment: Alignment.center,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
              child: CircularProgressIndicator(color: Theme.of(context).hintColor),
            );
          }),
        ],
      ),
    );
  }
}
