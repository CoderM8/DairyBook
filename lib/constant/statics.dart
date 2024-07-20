import 'dart:io';
import 'dart:ui';

import 'package:daily_diary/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Statics {
  static final RxString version = "".obs;

  /// FIREBASE INITIALIZE
  static Future<void> initFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    /// automatically get breadcrumb logs to understand user actions leading up to a crash, non-fatal, or ANR event
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    /// This data can help you understand basic interactions, such as how many times your app was opened, and how many users were active in a chosen time period.
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version + " (${packageInfo.buildNumber})";
  }

  static String get appName => "Daily Diary Work Planner";

  static String get privacy => "https://vocsyapp.com/Work%20Planner/DailyDiaryWorkPlanner.php";
  static String get terms => "https://vocsyapp.com/Work%20Planner/TermsAndConditions.php";

  static String get shareApp {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id=com.vocsy.diary";
    } else if (Platform.isIOS) {
      return "https://apps.apple.com/in/app/daily-diary-work-planner/id6499462953";
    } else {
      return "Unsupported Platform ${Platform.operatingSystem}";
    }
  }

  static String get rateApp {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id=com.vocsy.diary";
    } else if (Platform.isIOS) {
      return "https://itunes.apple.com/app/id6499462953?action=write-review";
    } else {
      return "Unsupported Platform ${Platform.operatingSystem}";
    }
  }
}
