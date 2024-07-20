import 'package:daily_diary/Language/AppLanguage.dart';
import 'package:daily_diary/ads/ads.dart';
import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/constant/statics.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/notification.dart';
import 'package:daily_diary/subscription/configPremium.dart';
import 'package:daily_diary/themes/apptheme.dart';
import 'package:daily_diary/ui/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storages.init();
  await Statics.initFirebase();
  await LocalNotificationService.init();
  await LocalNotificationService.cancelAll();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await ApplovinAds.appDetails();

  /// REVENUE-CAT STEP: 3
  await Premium.initialize();

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) {
        AppTheme.setSystemUIOverlayStyle(ThemeMode.values[themeMode]);
        return ThemeNotifier(ThemeMode.values[themeMode]);
      },
      child: const RestartWidget(child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    AppTheme.setSystemUIOverlayStyle(ThemeMode.values[themeMode]);
    super.didChangePlatformBrightness();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppTheme.setSystemUIOverlayStyle(ThemeMode.values[themeMode]);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return ScreenUtilInit(
      designSize: isTab(context) ? const Size(585, 812) : const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, wid) {
        return GetMaterialApp(
          title: Statics.appName,
          translations: AppTranslations(),
          locale: Locale(Storages.read('languageCode')),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.getThemeMode,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
