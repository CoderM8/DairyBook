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

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  final RxInt selectedIndex = 0.obs;

  @override
  void initState() {
    final indexx = AppLanguage.list.indexWhere((element) => element.languageCode == Storages.read('languageCode'));
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
        title: TextModel("language", textStyle: Theme.of(context).appBarTheme.titleTextStyle),
        leading: const Back(),
      ),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).bottomSheetTheme.backgroundColor, borderRadius: BorderRadius.circular(15.r)),
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        child: AnimationLimiter(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            itemCount: AppLanguage.list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final AppLanguage language = AppLanguage.list[index];
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
                        leading: TextModel(language.flag, textAlign: TextAlign.start),
                        title: TextModel(language.name, maxLines: 1, color: Theme.of(context).colorScheme.primary, textAlign: TextAlign.start, fontSize: 13.sp),
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
                          await Storages.write('languageCode', language.languageCode);
                          Get.updateLocale(Locale(language.languageCode));
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
