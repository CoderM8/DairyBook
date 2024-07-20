import 'dart:io';

import 'package:daily_diary/ads/ads.dart';
import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/commonclass.dart';
import 'package:daily_diary/allwidgets/diarybox.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/allwidgets/emojiPicker.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/allwidgets/textfield.dart';
import 'package:daily_diary/constant/statics.dart';
import 'package:daily_diary/database/sqflite.dart';
import 'package:daily_diary/database/storage.dart';
import 'package:daily_diary/getcontroller/creatediarycontroller.dart';
import 'package:daily_diary/getcontroller/homecontroller.dart';
import 'package:daily_diary/i.dart';
import 'package:daily_diary/staticdata.dart';
import 'package:daily_diary/subscription/configPremium.dart';
import 'package:daily_diary/subscription/subscription.dart';
import 'package:daily_diary/ui/allbottomscreen/creatediary/reminderscreen.dart';
import 'package:daily_diary/ui/pdfpreview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class EditDiary extends StatefulWidget {
  EditDiary({super.key, required this.diary});

  final DiaryModel diary;

  @override
  State<EditDiary> createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  final CreateController cc = Get.put(CreateController());
  final HomeController hc = Get.find<HomeController>();
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    cc.getDataForEdit(widget.diary);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Obx(() {
          cc.selectedBg.value;
          cc.selectedTextColor.value;
          TextStyle style({double? fontSize, FontWeight? fontWeight, String? fontFamily, Color? color}) {
            return Option.style(StaticsItem.fontFamilyList[cc.selectedFontFamilyIndex.value]['Name'].toString(),
                fontFamily: fontFamily, fontWeight: fontWeight ?? StaticsItem.fontWeightList[cc.selectedFontWeightIndex.value], fontSize: fontSize, color: color);
          }

          return Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: cc.selectedBgImgValue.value.isNotEmpty
                ? BoxDecoration(image: DecorationImage(image: AssetImage(cc.selectedBgImgValue.value), fit: BoxFit.cover))
                : BoxDecoration(color: cc.selectedBg.value != 0 ? Color(cc.selectedBg.value) : null),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: const Back(),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: isTab(context) ? 0 : 10.h),
                    child: Button(
                      title: 'save',
                      width: 62.w,
                      height: 31.w,
                      onTap: () async {
                        await cc.updateDiary(context, widget.diary.id!);
                      },
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                controller: cc.scrollController,
                child: Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h, bottom: 100.h),
                  child: Screenshot(
                    controller: screenshotController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          cc.selectedCat.value;
                          cc.attachPDF.value;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: StaticsItem.category[cc.selectedCat.value]['color']),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgImage(StaticsItem.category[cc.selectedCat.value]['icon'], color: Colors.white, height: 25.w, width: 25.w, fit: BoxFit.cover),
                                    SizedBox(width: 8.w),
                                    TextModel(StaticsItem.category[cc.selectedCat.value]['title'], color: Colors.white, fontFamily: 'SB', fontSize: 13.sp),
                                  ],
                                ),
                              ).onTap(() {
                                showCategorySheet(context, cc);
                              }),
                              if (cc.attachPDF.isNotEmpty)
                                PopupMenuButton(
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgImage(I.pdf, color: Colors.white, height: 25.w, width: 25.w, fit: BoxFit.cover),
                                        SizedBox(width: 8.w),
                                        TextModel('PDF', color: Colors.white, fontFamily: 'SB', fontSize: 13.sp),
                                      ],
                                    ),
                                  ),
                                  offset: Offset(0.w, 45.h),
                                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 1,
                                        onTap: () {
                                          FocusManager.instance.primaryFocus!.unfocus();
                                          Get.to(() => PdfPreview(path: cc.attachPDF.value));
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgImage(
                                              I.pdf,
                                              width: 18.w,
                                              height: 18.w,
                                              fit: BoxFit.cover,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            SizedBox(width: 5.w),
                                            TextModel('View_PDF', fontSize: 13.sp),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        onTap: () async {
                                          FocusManager.instance.primaryFocus!.unfocus();
                                          cc.attachPDF.value = "";
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgImage(
                                              I.close,
                                              width: 18.w,
                                              height: 18.w,
                                              fit: BoxFit.cover,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            SizedBox(width: 5.w),
                                            TextModel('Remove_PDF', fontSize: 13.sp),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                            ],
                          );
                        }),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return TextModel(DateFormat(dateFormat.value, Storages.read('languageCode')).format(cc.dateTime.value),
                                          fontFamily: 'B', fontSize: 20.sp, color: Color(cc.selectedTextColor.value));
                                    }),
                                    SizedBox(height: 5.h),
                                    TextModel(DateFormat('EEEE hh:mm a', Storages.read('languageCode')).format(cc.dateTime.value), fontSize: 12.sp, color: Color(cc.selectedTextColor.value)),
                                  ],
                                ),
                                SizedBox(width: 10.w),
                                SvgImage(I.arrowDown, color: Theme.of(context).colorScheme.primary, width: 8.w, height: 8.w, fit: BoxFit.cover),
                              ],
                            ).onTap(() async {
                              FocusManager.instance.primaryFocus!.unfocus();
                              await datePicker(context).then((dates) {
                                if (dates != null && dates.isNotEmpty) {
                                  cc.dateTime.value = dates[0]!;
                                  showTimePicker(
                                    context: context,
                                    confirmText: 'save'.tr,
                                    cancelText: 'cancel'.tr,
                                    initialEntryMode: TimePickerEntryMode.dialOnly,
                                    initialTime: TimeOfDay.fromDateTime(cc.dateTime.value),
                                  ).then((value) {
                                    if (value != null) {
                                      cc.dateTime.value = DateTime(cc.dateTime.value.year, cc.dateTime.value.month, cc.dateTime.value.day, value.hour, value.minute);
                                    }
                                  });
                                }
                              });
                              FocusManager.instance.primaryFocus!.unfocus();
                            }),
                            const Spacer(),
                            if (cc.selectedEmojiValue.value.isEmpty)
                              SvgImage(
                                I.emojiPick,
                                width: 40.w,
                                height: 40.w,
                                color: Theme.of(context).colorScheme.primary,
                                fit: BoxFit.cover,
                                onTap: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  showEmojiPickerSheet(context, cc);
                                  FocusManager.instance.primaryFocus!.unfocus();
                                },
                              )
                            else
                              Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(cc.selectedEmojiValue.value),
                                    ),
                                  )).onTap(() {
                                FocusManager.instance.primaryFocus!.unfocus();
                                showEmojiPickerSheet(context, cc);
                                FocusManager.instance.primaryFocus!.unfocus();
                              }),
                          ],
                        ),
                        Form(
                          key: cc.globalKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              TextFieldModel(
                                textController: cc.titleEditingController,
                                hint: 'title',
                                style: style(fontSize: 16.sp, fontFamily: "M", color: Color(cc.selectedTextColor.value), fontWeight: StaticsItem.fontWeightList[cc.selectedFontWeightIndex.value]),
                                textInputAction: TextInputAction.next,
                                validation: (valid) {
                                  if (valid!.isEmpty) {
                                    return "Required value";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              TextFieldModel(
                                textController: cc.desEditingController,
                                hint: 'writeText',
                                style: style(fontSize: 16.sp, fontFamily: "M", color: Color(cc.selectedTextColor.value), fontWeight: StaticsItem.fontWeightList[cc.selectedFontWeightIndex.value]),
                                textInputAction: TextInputAction.done,
                                validation: (valid) {
                                  if (valid!.isEmpty) {
                                    return "Required value";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        if (cc.showTask.value) ...[
                          AnimationLimiter(
                            child: ReorderableListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cc.tasksList.length,
                              onReorder: (oldIndex, newIndex) {
                                _reorderTasks(oldIndex, newIndex);
                              },
                              itemBuilder: (context, index) {
                                return ReorderableDelayedDragStartListener(
                                  index: index,
                                  key: Key('task_${index.toString()}'), // Required
                                  child: AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      horizontalOffset: 50,
                                      duration: const Duration(milliseconds: 375),
                                      child: FadeInAnimation(
                                        child: Obx(() {
                                          cc.check.value;
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ReorderableDragStartListener(
                                                  key: Key('task_${index.toString()}'), // Required
                                                  index: index,
                                                  child: SvgImage(I.arrow_down_up, height: 18.w, width: 18.w, fit: BoxFit.scaleDown, color: Theme.of(context).colorScheme.primary),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    cc.tasksList[index].completed = !cc.tasksList[index].completed;
                                                    cc.check.value = !cc.check.value;
                                                  },
                                                  icon: cc.tasksList[index].completed
                                                      ? SvgImage(I.task_fill, height: 20.w, width: 20.w, color: Theme.of(context).colorScheme.primary)
                                                      : SvgImage(I.task, height: 20.w, width: 20.w, fit: BoxFit.scaleDown, color: Theme.of(context).colorScheme.primary),
                                                )
                                              ],
                                            ),
                                            title: TextFieldModel(
                                              textController: TextEditingController(text: cc.tasksList[index].title),
                                              textInputAction: TextInputAction.done,
                                              decoration: cc.tasksList[index].completed ? TextDecoration.lineThrough : TextDecoration.none,
                                              hint: cc.tasksList[index].title,
                                              suffix: SvgImage(
                                                I.close,
                                                height: 18.w,
                                                width: 18.w,
                                                fit: BoxFit.scaleDown,
                                                onTap: () {
                                                  cc.tasksList.removeAt(index);
                                                  cc.taskController.clear();
                                                },
                                              ),
                                              onFieldSubmitted: (value) {
                                                _updateTaskTitle(index, value);
                                              },
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SvgImage(
                              I.arrowDown,
                              height: 18.w,
                              width: 18.w,
                              fit: BoxFit.scaleDown,
                              color: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                FocusManager.instance.primaryFocus!.unfocus();
                              },
                            ),
                            title: FocusScope(
                              canRequestFocus: cc.focusNode.value,
                              child: TextFieldModel(
                                autofocus: cc.focusNode.value,
                                textController: cc.taskController,
                                textInputAction: TextInputAction.next,
                                hint: 'writeText',
                                onTap: () {
                                  cc.focusNode.value = true;
                                },
                                onFieldSubmitted: (value) {
                                  _addTask(value);
                                  cc.taskController.clear();
                                  if (cc.scrollController.position.maxScrollExtent > 50) {
                                    cc.scrollController.animateTo(cc.scrollController.position.maxScrollExtent + 100, duration: Duration(seconds: 1), curve: Curves.ease);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                        if (cc.selectedImage.isNotEmpty)
                          AnimationLimiter(
                            child: GridView.builder(
                              itemCount: cc.selectedImage.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: isTab(context) ? 1.6 : 1, crossAxisSpacing: 5.w, mainAxisSpacing: 5.h),
                              itemBuilder: (context, index) {
                                final String file = cc.selectedImage[index];
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  columnCount: 4,
                                  child: SlideAnimation(
                                    verticalOffset: 50,
                                    duration: const Duration(milliseconds: 375),
                                    child: FadeInAnimation(
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          ImageView.file(
                                            file,
                                            width: MediaQuery.sizeOf(context).width,
                                            height: MediaQuery.sizeOf(context).height,
                                          ),
                                          Positioned(
                                            top: 5.h,
                                            right: 5.w,
                                            child: SvgImage(
                                              I.close,
                                              height: 25.w,
                                              width: 25.w,
                                              onTap: () {
                                                cc.selectedImage.removeAt(index);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 20.h),
                        ApplovinAds.showNativeAds(context, 300),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Container(
                padding: EdgeInsets.all(15.w),
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Obx(() {
                  isSubscribe.value;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cc.isUploading.value) LinearProgressIndicator(borderRadius: BorderRadius.circular(3.r)),
                      SizedBox(height: 8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          PopupMenuButton(
                            child: SvgImage(I.add_square, color: Theme.of(context).colorScheme.primary, fit: BoxFit.cover, width: 25.w, height: 25.w),
                            offset: Offset(-28.w, -190.h),
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {
                                    cc.showTask.value = !cc.showTask.value;
                                    if (!cc.showTask.value) {
                                      cc.tasksList.clear();
                                      cc.taskController.clear();
                                      cc.check.value = false;
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (cc.showTask.value)
                                        SvgImage(
                                          I.close,
                                          color: Theme.of(context).colorScheme.primary,
                                          fit: BoxFit.cover,
                                          width: 20.w,
                                          height: 20.w,
                                          onTap: () {
                                            cc.tasksList.clear();
                                            cc.taskController.clear();
                                            cc.check.value = false;
                                            cc.showTask.value = false;
                                          },
                                        )
                                      else
                                        SvgImage(
                                          I.add_square,
                                          width: 20.w,
                                          height: 20.w,
                                          fit: BoxFit.cover,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      SizedBox(width: 5.w),
                                      TextModel(cc.showTask.value ? "Remove_CheckList" : 'Add_CheckList', fontSize: 13.sp),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    await imagePick().then((value) {
                                      cc.isUploading.value = true;
                                      if (value.isNotEmpty) {
                                        for (final img in value) {
                                          cc.selectedImage.add(img);
                                        }
                                        cc.isUploading.value = false;
                                        if (cc.scrollController.position.maxScrollExtent > 50) {
                                          cc.scrollController.animateTo(cc.scrollController.position.maxScrollExtent + 100, duration: Duration(seconds: 1), curve: Curves.ease);
                                        }
                                      }
                                    }).onError(
                                      (error, stackTrace) {
                                        cc.isUploading.value = false;
                                      },
                                    );
                                    FocusManager.instance.primaryFocus!.unfocus();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgImage(
                                        I.pickImage,
                                        width: 18.w,
                                        height: 18.w,
                                        fit: BoxFit.cover,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      SizedBox(width: 5.w),
                                      TextModel('Attach_Images', fontSize: 13.sp),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  onTap: isSubscribe.value
                                      ? () async {
                                          await FilePicker.platform
                                              .pickFiles(
                                            allowMultiple: false,
                                            allowedExtensions: ['pdf'],
                                            type: FileType.custom,
                                            onFileLoading: (FilePickerStatus p0) {
                                              print('Hello FilePickerStatus onFileLoading ${p0.name}');
                                            },
                                          )
                                              .then(
                                            (FilePickerResult? value) {
                                              if (value != null && value.files.isNotEmpty) {
                                                cc.attachPDF.value = value.files[0].path!;
                                              }
                                            },
                                          );
                                        }
                                      : () {
                                          Get.to(() => SubscriptionPlan());
                                        },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (isSubscribe.value)
                                        SvgImage(
                                          I.pdf,
                                          width: 18.w,
                                          height: 18.w,
                                          fit: BoxFit.cover,
                                          color: Theme.of(context).colorScheme.primary,
                                        )
                                      else
                                        SvgImage(
                                          I.premium,
                                          width: 14.w,
                                          height: 14.w,
                                          fit: BoxFit.cover,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      SizedBox(width: 5.w),
                                      TextModel('Attach_PDF', fontSize: 13.sp),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                          SvgImage(
                            I.pickBg,
                            width: 25.w,
                            height: 25.w,
                            fit: BoxFit.cover,
                            color: Theme.of(context).colorScheme.primary,
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              showBgPickerSheet(context, cc);
                            },
                          ),
                          SvgImage(
                            I.pickFont,
                            width: 25.w,
                            height: 25.w,
                            fit: BoxFit.cover,
                            color: Theme.of(context).colorScheme.primary,
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              showFontPickerSheet(context, cc);
                            },
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgImage(
                                I.reminder,
                                width: 25.w,
                                height: 25.w,
                                fit: BoxFit.cover,
                                color: Theme.of(context).colorScheme.primary,
                                onTap: () {
                                  if (isSubscribe.value) {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    Get.to(() => ReminderScreen());
                                  } else {
                                    Get.to(() => SubscriptionPlan());
                                  }
                                },
                              ),
                              if (!isSubscribe.value) SvgImage(I.premium, width: 10.w, height: 10.w, fit: BoxFit.cover, color: Theme.of(context).hintColor),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() {
                                cc.diaryHide.value;
                                return SvgImage(
                                  cc.diaryHide.value ? I.hide : I.show,
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.cover,
                                  color: Theme.of(context).colorScheme.primary,
                                  onTap: () {
                                    if (isSubscribe.value) {
                                      FocusManager.instance.primaryFocus!.unfocus();
                                      final String? hide = Storages.read('hide');
                                      if (hide == null) {
                                        setPasswordSheet(context, hide ?? "", onSave: () {
                                          cc.diaryHide.value = true;
                                        });
                                      } else {
                                        cc.diaryHide.value = !cc.diaryHide.value;
                                        if (cc.diaryHide.value) {
                                          showToast('hide');
                                        } else {
                                          showToast('expose');
                                        }
                                      }
                                    } else {
                                      Get.to(() => SubscriptionPlan());
                                    }
                                  },
                                );
                              }),
                              if (!isSubscribe.value) SvgImage(I.premium, width: 10.w, height: 10.w, fit: BoxFit.cover, color: Theme.of(context).hintColor),
                            ],
                          ),
                          PopupMenuButton(
                            child: SvgImage(I.more, color: Theme.of(context).colorScheme.primary, fit: BoxFit.cover, width: 25.w, height: 25.w),
                            offset: Offset(25.w, cc.attachPDF.value.isNotEmpty ? -200.h : -140.h),
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    screenshotController.capture().then((Uint8List? image) async {
                                      //Capture Done
                                      if (image != null) {
                                        final Directory tempDir = await getTemporaryDirectory();
                                        // Create a file in the temporary directory
                                        final File file = await File(join(tempDir.path, 'diary${widget.diary.id}.jpg')).create();
                                        // Write the data to the file
                                        await file.writeAsBytes(image);
                                        await Share.shareXFiles([XFile(file.path)], text: '${Statics.appName} \n${widget.diary.title} \n${widget.diary.description}');
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgImage(
                                        I.share,
                                        width: 18.w,
                                        height: 18.w,
                                        fit: BoxFit.cover,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      SizedBox(width: 5.w),
                                      TextModel('share', fontSize: 13.sp),
                                    ],
                                  ),
                                ),
                                if (cc.attachPDF.value.isNotEmpty)
                                  PopupMenuItem(
                                    value: 2,
                                    onTap: () async {
                                      await Share.shareXFiles([XFile(cc.attachPDF.value)], text: '${Statics.appName} \n ${widget.diary.title}');
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgImage(
                                          I.pdf,
                                          width: 18.w,
                                          height: 18.w,
                                          fit: BoxFit.cover,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        SizedBox(width: 5.w),
                                        TextModel('${"share".tr} ${"PDF".tr}', fontSize: 13.sp),
                                      ],
                                    ),
                                  ),
                                PopupMenuItem(
                                  value: 3,
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    showDeleteDialog(context, onTap: () async {
                                      await DatabaseHelper.removeDiary(widget.diary.id!);
                                      hc.items.removeWhere((element) => element.id == widget.diary.id);
                                      hc.refresh();
                                      Get.back();
                                      Get.back();
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgImage(
                                        I.delete,
                                        width: 18.w,
                                        height: 18.w,
                                        fit: BoxFit.cover,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      SizedBox(width: 5.w),
                                      TextModel('delete', fontSize: 13.sp),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                    ],
                  );
                }),
              ),
            ),
          );
        }),
        Obx(() {
          if (!cc.isSave.value) return const SizedBox.shrink();
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgImage(I.diary_save),
                  SizedBox(height: 20.h),
                  TextModel('diary_saved', fontFamily: 'B', fontSize: 20.sp),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _addTask(String title) {
    if (title.isNotEmpty) {
      cc.tasksList.add(Task(title: title, completed: false));
    }
  }

  void _updateTaskTitle(int index, String value) {
    cc.tasksList[index].title = value;
  }

  void _reorderTasks(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Task movedTask = cc.tasksList.removeAt(oldIndex);
    cc.tasksList.insert(newIndex, movedTask);
  }
}
