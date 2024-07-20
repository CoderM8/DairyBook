import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/i.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'color.dart';

class Button extends GetView {
  const Button(
      {Key? key,
      this.title = "",
      this.titleColor,
      this.buttonColor,
      this.onTap,
      this.width,
      this.height,
      this.borderRadius,
      this.fontSize,
      this.fontWeight,
      this.enable = true,
      this.border = false,
      this.icon,
      this.margin = EdgeInsets.zero})
      : super(key: key);
  final String title;
  final Color? titleColor;
  final Color? buttonColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? icon;
  final EdgeInsets margin;
  final bool enable;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: enable ? onTap : null,
      child: Container(
        height: height ?? 40.w,
        width: width ?? MediaQuery.sizeOf(context).width,
        margin: margin,
        padding: EdgeInsets.all(5.h),
        decoration: BoxDecoration(
            color: border
                ? Colors.transparent
                : enable
                    ? buttonColor ?? Theme.of(context).hintColor
                    : dot.withOpacity(.4),
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
            border: border ? Border.all(color: dot, width: 1.w) : null),
        child: icon == null
            ? Center(child: TextModel(title, color: titleColor ?? Colors.white, fontFamily: 'B', fontSize: fontSize ?? 14.sp, fontWeight: fontWeight, maxLines: 1))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  if (title.isNotEmpty) SizedBox(width: 16.w),
                  Center(child: TextModel(title, color: titleColor ?? Colors.white, fontFamily: 'B', fontSize: 14.sp, fontWeight: fontWeight, maxLines: 1)),
                ],
              ),
      ),
    );
  }
}

class Back extends GetView {
  const Back({Key? key, this.onTap, this.color, this.svgUrl}) : super(key: key);
  final VoidCallback? onTap;
  final Color? color;
  final String? svgUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap ?? () => Get.back(),
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: SvgImage(svgUrl ?? I.back, color: color ?? Theme.of(context).colorScheme.primary, height: 24.w, width: 24.w, fit: BoxFit.scaleDown),
      ),
    );
  }
}
