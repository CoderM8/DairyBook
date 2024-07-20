import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RETURN [TRUE] IF PLAN ACTIVATED
final RxBool isSubscribe = false.obs;

class Premium {
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static final RxList<StoreProduct> products = <StoreProduct>[].obs;
  static final RxBool isPurchasing = false.obs;
  static final RxBool isLoadPlan = false.obs;
  static const String entitlementKey = 'pro';

  /// PURCHASE KEY FROM REVENUCAT DASHBOARD
  /// REVENUE-CAT STEP: 2
  static String get apiKey {
    if (Platform.isAndroid) {
      return "";
    } else if (Platform.isIOS) {
      return "appl_GMKTqZGeNZJSzkrNdAtaqCiofwC";
    } else {
      return "Unsupported Platform ${Platform.operatingSystem}";
    }
  }

  /// CONFIGURE REVENUE SDK INITIALIZE PURCHASE
  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.error);
    await Purchases.configure(PurchasesConfiguration(apiKey));
    await Purchases.enableAdServicesAttributionTokenCollection();
    await getActiveSubscription();
  }

  /// GET ALL PRODUCT FORM CLOUD-FIRESTORE DATABASE
  static Future<void> getAllProducts() async {
    try {
      products.clear();
      isLoadPlan.value = true;
      final DocumentSnapshot<Map<String, dynamic>> collection = await fireStore.collection('AppDetails').doc('Premium').get();

      if (collection.exists) {
        final Map<String, dynamic> data = collection.data() as Map<String, dynamic>;
        final List plans = List.from(data['Plans']);
        List<String> subIds = [];
        List<String> purIds = [];
        for (final element in plans) {
          /// consumable A Type for subscriptions.
          if (element['Type'] == "subscription") {
            if (Platform.isAndroid) {
              subIds.add(element['Android']);
            } else if (Platform.isIOS) {
              subIds.add(element['IOS']);
            }
          }

          /// non-consumable A Type for in-app products.
          else if (element['Type'] == "nonSubscription") {
            if (Platform.isAndroid) {
              purIds.add(element['Android']);
            } else if (Platform.isIOS) {
              purIds.add(element['IOS']);
            }
          }
        }
        if (subIds.isNotEmpty) {
          final List<StoreProduct> items = await Purchases.getProducts(subIds, productCategory: ProductCategory.subscription);
          for (final StoreProduct key in items) {
            products.add(key);
          }
        }
        if (purIds.isNotEmpty) {
          final List<StoreProduct> items = await Purchases.getProducts(purIds, productCategory: ProductCategory.nonSubscription);
          for (final StoreProduct key in items) {
            products.add(key);
          }
        }
        products.sort((a, b) => b.price.compareTo(a.price));
      }
      isLoadPlan.value = false;
      if (kDebugMode) {
        print('HELLO PURCHASE INITIALIZE storeProduct ${products.length}');
      }
    } on PlatformException catch (e) {
      isLoadPlan.value = false;
      if (kDebugMode) {
        print('HELLO PURCHASE INITIALIZE ERROR [${e.code}] ${e.message}');
      }
    }
  }

  /// GET USER ACTIVE SUBSCRIPTION DATA
  static Future<void> getActiveSubscription() async {
    isPurchasing.value = false;
    isPurchasing.value = true;
    final CustomerInfo info = await Purchases.getCustomerInfo();
    final bool isPro = info.entitlements.active.containsKey(entitlementKey);
    final bool isActive = info.activeSubscriptions.isNotEmpty || info.nonSubscriptionTransactions.isNotEmpty;
    if (kDebugMode) {
      print('HELLO PURCHASE GET isActive $isActive isPro $isPro sub ${info.activeSubscriptions} inApp ${info.nonSubscriptionTransactions} entitlements ${info.entitlements.active}');
    }
    isSubscribe.value = (isActive && isPro);
    isPurchasing.value = false;
    if (kDebugMode) {
      print('HELLO PURCHASE GET isSubscribe $isSubscribe');
    }
  }

  /// RESTORE PURCHASE
  static Future<void> restoreSubscription() async {
    try {
      isPurchasing.value = false;
      isPurchasing.value = true;
      final CustomerInfo info = await Purchases.restorePurchases();
      final bool isPro = info.entitlements.active.containsKey(entitlementKey);
      final bool isActive = info.activeSubscriptions.isNotEmpty || info.nonSubscriptionTransactions.isNotEmpty;
      if (kDebugMode) {
        print('HELLO PURCHASE RESTORE ACTIVE isActive $isActive isPro $isPro sub ${info.activeSubscriptions} inApp ${info.nonSubscriptionTransactions} entitlements ${info.entitlements.active}');
      }
      isSubscribe.value = (isActive && isPro);
      if (isSubscribe.value) {
        showToast('Plan_Activated');
        LocalNotificationService.showScheduleNotification(delay: Duration(seconds: 10), {"title": "Plan_active".tr.replaceAll('xxx', "Restore".tr)});
      } else {
        showToast('No_plans', s: false);
      }
    } on PlatformException catch (e) {
      showToast(e.message.toString(), s: false);
      isPurchasing.value = false;
      if (kDebugMode) {
        print('HELLO PURCHASE RESTORE ERROR [${e.code}] ${e.message}');
      }
    }
    isPurchasing.value = false;
    if (kDebugMode) {
      print('HELLO PURCHASE RESTORE isSubscribe $isSubscribe');
    }
  }

  /// BUY SUBSCRIPTION PLAN
  static Future<void> buySubscription({required StoreProduct item}) async {
    try {
      isPurchasing.value = false;
      isPurchasing.value = true;

      final CustomerInfo info = await Purchases.purchaseStoreProduct(item);
      final bool isPro = info.entitlements.active.containsKey(entitlementKey);
      final bool isActive = info.activeSubscriptions.isNotEmpty || info.nonSubscriptionTransactions.isNotEmpty;
      if (kDebugMode) {
        print('HELLO PURCHASE BUY isActive $isActive isPro $isPro sub ${info.activeSubscriptions} inApp ${info.nonSubscriptionTransactions} entitlements ${info.entitlements.active} ');
      }
      isSubscribe.value = (isActive && isPro);

      if (isSubscribe.value) {
        showToast("Plan_active".tr.replaceAll('xxx', item.title));
        LocalNotificationService.showScheduleNotification(delay: Duration(seconds: 10), {"title": "Plan_active".tr.replaceAll('xxx', item.title)});
      }

      Get.back();
    } on PlatformException catch (e) {
      isPurchasing.value = false;
      showToast(e.message.toString(), s: false);
      if (kDebugMode) {
        print('HELLO PURCHASE BUY ERROR [${e.code}] ${e.message}');
      }
      if (e.code == '6' || e.message == 'This product is already active for the user.') {
        await restoreSubscription();
      }
    }
    isPurchasing.value = false;
    if (kDebugMode) {
      print('HELLO PURCHASE BUY isSubscribe $isSubscribe');
    }
  }
}
