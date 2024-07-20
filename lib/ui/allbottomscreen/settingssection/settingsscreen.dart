import 'package:daily_diary/Language/changeLanguage.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/allwidgets/textfield.dart';
import 'package:daily_diary/constant/statics.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/subscription/configPremium.dart';
import 'package:daily_diary/subscription/subscription.dart';
import 'package:daily_diary/themes/changeTheme.dart';
import 'package:daily_diary/ui/allbottomscreen/settingssection/backupscreen.dart';
import 'package:daily_diary/ui/allbottomscreen/settingssection/changeDateformat.dart';
import 'package:daily_diary/ui/allbottomscreen/settingssection/deletedatascreen.dart';
import 'package:daily_diary/ui/allbottomscreen/settingssection/setpasswordscreen.dart';
import 'package:daily_diary/ui/privacyview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends GetView {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextModel('settings', textStyle: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.all(10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: TextModel('account', fontSize: 16.sp, fontFamily: 'M'),
                    ),
                    ProfileTile(title: 'password', leadingSvg: I.password).onTap(
                      () {
                        Get.to(() => SetPassword());
                      },
                    ),
                    const Divider(),
                    ProfileTile(title: 'language', leadingSvg: I.language).onTap(() {
                      Get.to(() => const ChangeLanguage());
                    }),
                    const Divider(),
                    ProfileTile(title: 'theme', leadingSvg: I.theme).onTap(() {
                      Get.to(() => const ThemeChange());
                    }),
                    Obx(() {
                      if (isSubscribe.value) {
                        return SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          ProfileTile(title: 'feature1', leadingSvg: I.ads).onTap(() {
                            Get.to(() => const SubscriptionPlan());
                          }),
                        ],
                      );
                    }),
                    const Divider(),
                    ProfileTile(title: 'Date_Format', leadingSvg: I.date).onTap(() {
                      Get.to(() => const ChangeFormat());
                    }),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.all(10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: TextModel('About', fontSize: 16.sp, fontFamily: 'M'),
                    ),
                    ProfileTile(title: 'FAQ', leadingSvg: I.idea).onTap(() async {
                      final Uri url = Uri.parse("https://youtu.be/1tBGJC1gAF0");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    }),
                    const Divider(),
                    ProfileTile(title: 'Share_app', leadingSvg: I.share).onTap(
                      () async {
                        if (isTab(context)) {
                          await Share.share("${Statics.appName} \n${Statics.shareApp}",
                              sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height / 2));
                        } else {
                          await Share.share("${Statics.appName} \n${Statics.shareApp}");
                        }
                      },
                    ),
                    const Divider(),
                    ProfileTile(title: 'Rate_us', leadingSvg: I.rate).onTap(() async {
                      final Uri url = Uri.parse(Statics.rateApp);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    }),
                    const Divider(),
                    ProfileTile(title: 'Privacy', leadingSvg: I.privacy).onTap(() {
                      Get.to(() => PrivacyView(title: "Privacy", url: Statics.privacy));
                    }),
                    const Divider(),
                    ProfileTile(title: 'Terms', leadingSvg: I.terms).onTap(() {
                      Get.to(() => PrivacyView(title: "Terms", url: Statics.terms));
                    }),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.all(10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: TextModel('data', fontSize: 16.sp, fontFamily: 'M'),
                    ),
                    ProfileTile(title: 'Backup_Restore', leadingSvg: I.backup).onTap(() {
                      Get.to(() => BackUpData());
                    }),
                    const Divider(),
                    ProfileTile(title: 'deleteData', leadingSvg: I.deleteData).onTap(() {
                      Get.to(() => DeleteData());
                    }),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              TextModel('Version ${Statics.version}', fontSize: 12.sp, fontFamily: 'M'),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
