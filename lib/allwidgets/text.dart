import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TextModel extends GetView {
  const TextModel(this.text,
      {Key? key,
      this.textAlign,
      this.maxLines,
      this.overflow,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.letterSpacing,
      this.height,
      this.fontFamily,
      this.textDecoration,
      this.padding = EdgeInsets.zero,
      this.textStyle})
      : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextDecoration? textDecoration;
  final TextStyle? textStyle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text.tr,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: true,
        textScaler: const TextScaler.linear(1),
        style: textStyle ??
            TextStyle(
                fontSize: fontSize ?? 18.sp,
                fontWeight: fontWeight,
                color: color ?? Theme.of(context).colorScheme.primary,
                letterSpacing: letterSpacing,
                height: height,
                fontFamily: fontFamily ?? "R",
                decoration: textDecoration),
      ),
    );
  }
}
