import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/getcontroller/bottomcontroller.dart';
import 'package:daily_diary/getcontroller/homecontroller.dart';
import 'package:daily_diary/notification.dart';
import 'package:daily_diary/staticdata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class CreateController extends GetxController {
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController desEditingController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final HomeController hc = Get.find<HomeController>();
  final RxBool focusNode = false.obs;
  final RxBool check = false.obs;
  final RxBool showTask = false.obs;
  final RxBool isSave = false.obs;
  final RxBool notification = false.obs;
  final RxBool diaryHide = false.obs;
  final RxBool isUploading = false.obs;

  final Rx<DateTime> dateTime = DateTime.now().obs;
  final Rx<DateTime> reminder = DateTime.now().obs;
  final Rx<DateTime> createdAt = DateTime.now().obs;
  final RxInt selectedEmojiIndex = 0.obs;
  final RxInt selectedBgImgIndex = 0.obs;
  final RxInt selectedFontWeightIndex = 0.obs;
  final RxInt selectedAlignIndex = 0.obs;
  final RxInt selectedFontFamilyIndex = 0.obs;
  final RxString selectedEmojiValue = ''.obs;
  final RxString selectedBgImgValue = ''.obs;
  final RxString attachPDF = "".obs;
  final RxList selectedImage = [].obs;
  final RxList<Task> tasksList = <Task>[].obs;

  final RxInt selectedCat = 0.obs;

  final RxInt selectedBg = 0.obs; // bg color
  final RxInt selectedTextColor = 0.obs; // text color

  @override
  void onInit() {
    selectedTextColor.value = Theme.of(Get.context!).colorScheme.primary.value;
    selectedBg.value = Theme.of(Get.context!).primaryColor.value;
    super.onInit();
  }

  Future<void> createDiary(context) async {
    try {
      if (globalKey.currentState!.validate()) {
        FocusManager.instance.primaryFocus!.unfocus();
        isSave.value = true;
        final DiaryModel diaryModel = DiaryModel(
          notification: notification.value,
          title: titleEditingController.text,
          description: desEditingController.text,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          date: dateTime.toString(),
          reminder: reminder.toString(),
          images: selectedImage,
          emoji: selectedEmojiValue.value,
          bgImg: selectedBgImgValue.value,
          bgColor: selectedBg.value != 0 ? selectedBg.value : Theme.of(context).primaryColor.value,
          items: tasksList.value,
          catIndex: selectedCat.value,
          hide: diaryHide.value,
          pdf: attachPDF.value,
          style: Fonts(
            code: StaticsItem.fontFamilyList[selectedFontFamilyIndex.value]['Name'].toString(),
            fontWeight: StaticsItem.fontWeightList[selectedFontWeightIndex.value],
            align: StaticsItem.alignList[selectedAlignIndex.value].align,
            color: selectedTextColor.value != 0 ? selectedTextColor.value : Theme.of(context).colorScheme.primary.value,
          ),
        );

        final int id = await DatabaseHelper.addDiary(diaryModel);
        debugPrint('DIARY ADDED ✅ ID: $id');
        final DiaryModel diary = (await DatabaseHelper.getById(id)).first;
        if (!diaryHide.value) {
          hc.items.insert(0, diary);
          hc.items.sort((a, b) => a.date.compareTo(b.date));
        }
        hc.refresh();
        if (diary.notification) {
          await LocalNotificationService.zonedScheduleNotification(diary);
        }
        Future.delayed(const Duration(seconds: 2), () {
          isSave.value = false;
          Get.back();
          clear();
          bottomIndex.value = 0;
          Get.back();
        });
      }
    } catch (e, t) {
      isSave.value = false;
      Get.back();
      if (kDebugMode) {
        print('HELLO ADD-DIARY ERROR $e T == $t');
      }
    }
  }

  /// UPDATE / EDIT DAIRY
  Future<void> updateDiary(context, int id) async {
    try {
      if (globalKey.currentState!.validate()) {
        FocusManager.instance.primaryFocus!.unfocus();
        isSave.value = true;
        if (kDebugMode) {
          print('DIARY UPDATE ☑️ ID: $id');
        }
        final DiaryModel diaryModel = DiaryModel(
          id: id,
          notification: notification.value,
          title: titleEditingController.text,
          description: desEditingController.text,
          createdAt: createdAt.toString(),
          updatedAt: DateTime.now().toString(),
          date: dateTime.toString(),
          reminder: reminder.toString(),
          images: selectedImage,
          emoji: selectedEmojiValue.value,
          bgImg: selectedBgImgValue.value,
          bgColor: selectedBg.value != 0 ? selectedBg.value : Theme.of(context).primaryColor.value,
          items: tasksList.value,
          catIndex: selectedCat.value,
          hide: diaryHide.value,
          pdf: attachPDF.value,
          style: Fonts(
            code: StaticsItem.fontFamilyList[selectedFontFamilyIndex.value]['Name'].toString(),
            fontWeight: StaticsItem.fontWeightList[selectedFontWeightIndex.value],
            align: StaticsItem.alignList[selectedAlignIndex.value].align,
            color: selectedTextColor.value != 0 ? selectedTextColor.value : Theme.of(context).colorScheme.primary.value,
          ),
        );

        await DatabaseHelper.updateDiary(id, diaryModel);
        hc.items.removeWhere((element) => element.id == id);
        final DiaryModel diary = (await DatabaseHelper.getById(id)).first;
        if (!diaryHide.value) {
          hc.items.insert(0, diary);
          hc.items.sort((a, b) => a.date.compareTo(b.date));
        }
        hc.refresh();
        if (diary.notification) {
          await LocalNotificationService.cancel(diary.id!);
          await LocalNotificationService.zonedScheduleNotification(diary);
        } else {
          final List<PendingNotificationRequest> pending = await LocalNotificationService.pendingNotification();
          for (final request in pending) {
            if (request.id == diary.id) {
              await LocalNotificationService.cancel(request.id);
            }
          }
        }
        Future.delayed(const Duration(seconds: 2), () {
          isSave.value = false;
          clear();
          Get.back();
          Get.back();
        });
      }
    } catch (e, t) {
      isSave.value = false;
      Get.back();
      if (kDebugMode) {
        print('HELLO ADD-DIARY ERROR $e T == $t');
      }
    }
  }

  /// GET EDIT DATA FROM OLD DIARY
  void getDataForEdit(DiaryModel value) async {
    titleEditingController.text = value.title;
    desEditingController.text = value.description;
    selectedImage.value = value.images;
    dateTime.value = DateTime.parse(value.date);
    notification.value = value.notification;
    reminder.value = DateTime.parse(value.reminder);
    createdAt.value = DateTime.parse(value.createdAt);

    if (value.items.isNotEmpty) {
      showTask.value = true;
      tasksList.value = value.items;
    }

    selectedTextColor.value = value.style.color;

    /// emoji
    if (value.emoji.isNotEmpty) {
      final emojiIndex = StaticsItem.emojiList.indexWhere((element) => element == value.emoji);
      if (!emojiIndex.isNegative) {
        selectedEmojiIndex.value = emojiIndex;
      }
      selectedEmojiValue.value = value.emoji;
    }

    /// bgImg
    if (value.bgImg.isNotEmpty) {
      final bgIndex = StaticsItem.bgImageList.indexWhere((element) => element['Img'] == value.bgImg);
      if (!bgIndex.isNegative) {
        selectedBgImgIndex.value = bgIndex;
      }
      selectedBgImgValue.value = value.bgImg;
    }
    selectedBg.value = value.bgColor;

    /// font family
    if (value.style.code.isNotEmpty) {
      final fontFamilyIndex = StaticsItem.fontFamilyList.indexWhere((element) => element == value.style.code);
      if (!fontFamilyIndex.isNegative) {
        selectedFontFamilyIndex.value = fontFamilyIndex;
      }
    }

    /// font wight
    final fontIndex = StaticsItem.fontWeightList.indexWhere((element) => element == fontWeightToString(value.style.fontWeight));
    if (!fontIndex.isNegative) {
      selectedFontWeightIndex.value = fontIndex;
    }

    /// Align
    final alignIndex = StaticsItem.alignList.indexWhere((element) => element.align == textAlignToString(value.style.align));
    if (!alignIndex.isNegative) {
      selectedAlignIndex.value = alignIndex;
    }

    /// category index
    if (!value.catIndex.isNegative) {
      selectedCat.value = value.catIndex;
    }

    /// diary password
    diaryHide.value = value.hide;

    /// pdf
    attachPDF.value = value.pdf;
  }

  void clear() {
    titleEditingController.clear();
    desEditingController.clear();
    taskController.clear();
    dateTime.value = DateTime.now();
    reminder.value = DateTime.now();
    createdAt.value = DateTime.now();
    notification.value = false;
    selectedEmojiValue.value = '';
    selectedBgImgValue.value = '';
    selectedImage.clear();
    tasksList.clear();
    selectedFontWeightIndex.value = 0;
    selectedAlignIndex.value = 0;
    selectedFontFamilyIndex.value = 0;
    selectedEmojiIndex.value = 0;
    selectedBgImgIndex.value = 0;
    showTask.value = false;
    check.value = false;
    selectedBg.value = 0;
    selectedTextColor.value = 0;
  }
}
