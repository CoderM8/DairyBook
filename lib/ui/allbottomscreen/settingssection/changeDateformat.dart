import 'package:daily_diary/Language/AppLanguage.dart';
import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/color.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChangeFormat extends StatefulWidget {
  const ChangeFormat({super.key});

  @override
  State<ChangeFormat> createState() => _ChangeFormatState();
}

class _ChangeFormatState extends State<ChangeFormat> {
  final RxInt selectedIndex = 0.obs;

  @override
  void initState() {
    final indexx = AppLanguage.format.indexWhere((element) => element == Storages.read('format'));
    if (!indexx.isNegative) {
      selectedIndex.value = indexx;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextModel("Date_Format", textStyle: Theme.of(context).appBarTheme.titleTextStyle),
        leading: const Back(),
      ),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).bottomSheetTheme.backgroundColor, borderRadius: BorderRadius.circular(15.r)),
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: AnimationLimiter(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: AppLanguage.format.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final String language = AppLanguage.format[index];
              return Obx(() {
                final bool active = (selectedIndex.value == index);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    horizontalOffset: 40,
                    duration: const Duration(milliseconds: 375),
                    child: FadeInAnimation(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
                        leading: TextModel(language, maxLines: 1, color: Theme.of(context).colorScheme.primary, textAlign: TextAlign.start, fontSize: 13.sp, fontFamily: "B"),
                        title: TextModel(DateFormat(language, Storages.read('languageCode')).format(DateTime.now()), textAlign: TextAlign.start, fontSize: 16.sp),
                        trailing: active
                            ? CircleAvatar(
                                radius: 11.r,
                                backgroundColor: Theme.of(context).hintColor,
                                child: CircleAvatar(radius: 4.r, backgroundColor: Colors.white),
                              )
                            : CircleAvatar(
                                radius: 10.r,
                                backgroundColor: grey,
                                child: CircleAvatar(radius: 9.r, backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor),
                              ),
                        onTap: () async {
                          selectedIndex.value = index;
                          dateFormat.value = language;
                          await Storages.write('format', language);
                        },
                      ),
                    ),
                  ),
                );
              });
            },
            separatorBuilder: (context, index) => Divider(endIndent: 10.w, indent: 10.w, thickness: 1.h),
          ),
        ),
      ),
    );
  }
}
