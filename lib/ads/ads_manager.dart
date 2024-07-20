// import 'dart:io';
// import 'package:daily_diary/constant/constant.dart';
// import 'package:easy_ads_flutter/easy_ads_flutter.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_device_id/flutter_device_id.dart';
// TODO: easy ads old setup
// String? googleAppId = 'ca-app-pub-1031554205279977~6666002503';
// String? facebookAppId = '1658237181610037';
//
// String? googleBannerAndroid;
// String? googleBannerIOS = 'ca-app-pub-1031554205279977/1389872512';
// String? facebookBannerAndroid;
// String? facebookBannerIOS = '1118964072660182_1119047469318509';
//
// String? googleInterstitialAndroid;
// String? googleInterstitialIOS = 'ca-app-pub-1031554205279977/9076790841';
// String? facebookInterstitialAndroid;
// String? facebookInterstitialIOS = '1118964072660182_1119047669318489';
//
// String? googleRewardedAndroid;
// String? googleRewardedIOS = 'ca-app-pub-1031554205279977/4028230879';
// String? facebookRewardedAndroid;
// String? facebookRewardedIOS = '1118964072660182_1119047792651810';
//
// class AdsTestAdIdManager extends IAdIdManager {
//   AdsTestAdIdManager();
//
//   @override
//   AppAdIds? get fbAdIds => AppAdIds(
//         appId: facebookAppId!,
//         bannerId: Platform.isIOS ? facebookBannerIOS : facebookBannerAndroid,
//         interstitialId: Platform.isIOS ? facebookInterstitialIOS : facebookInterstitialAndroid,
//         rewardedId: Platform.isIOS ? facebookRewardedIOS : facebookRewardedAndroid,
//       );
//
//   @override
//   AppAdIds? get admobAdIds => AppAdIds(
//         appId: googleAppId!,
//         bannerId: Platform.isIOS ? googleBannerIOS : googleBannerAndroid,
//         interstitialId: Platform.isIOS ? googleInterstitialIOS : googleInterstitialAndroid,
//         rewardedId: Platform.isIOS ? googleRewardedIOS : googleRewardedAndroid,
//       );
//
//   @override
//   AppAdIds? get unityAdIds => null;
//
//   @override
//   AppAdIds? get appLovinAdIds => null;
// }
//
// void initAds() async {
//   final IAdIdManager adIdManager = AdsTestAdIdManager();
//
//   final FlutterDeviceId flutterDeviceIdPlugin = FlutterDeviceId();
//
//   final String? deviceId = await flutterDeviceIdPlugin.getDeviceId() ?? '';
//
//   print("DEVICE ID $deviceId");
//   EasyAds.instance.initialize(
//     isShowAppOpenOnAppStateChange: false,
//     adIdManager,
//     adMobAdRequest: const AdRequest(),
//     admobConfiguration: RequestConfiguration(testDeviceIds: [deviceId!]),
//     fbTestMode: true,
//     showAdBadge: Platform.isIOS,
//     fbiOSAdvertiserTrackingEnabled: true,
//   );
// }

/// Banner Ads
// Widget bannerAds() {
// return EasySmartBannerAd(
//   priorityAdNetworks: [AdNetwork.facebook, AdNetwork.admob],
//   adSize: AdSize.banner,
// );
// }

/// Interstitial & Rewarded Ads
// void showAd(AdUnitType adUnitType) {
// if (adUnitType == AdUnitType.interstitial) {
//   if (EasyAds.instance.showAd(adUnitType, adNetwork: AdNetwork.facebook))
//     ;
//   else
//     EasyAds.instance.showAd(adUnitType, adNetwork: AdNetwork.admob);
// } else if (adUnitType == AdUnitType.rewarded) {
//   if (EasyAds.instance.showAd(adUnitType, adNetwork: AdNetwork.facebook))
//     ;
//   else
//     EasyAds.instance.showAd(adUnitType, adNetwork: AdNetwork.admob);
// }
// }
