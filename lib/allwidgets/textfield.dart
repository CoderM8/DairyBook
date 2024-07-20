import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/i.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'images.dart';

class TextFieldModel extends GetView {
  const TextFieldModel({
    Key? key,
    required this.hint,
    required this.textController,
    this.textInputType,
    this.obscureText,
    this.focusNode,
    this.validation,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.maxLan,
    this.suffix,
    this.prefixIcon,
    this.minLine,
    this.textInputAction,
    this.maxLine,
    this.readOnly = false,
    this.autofocus = false,
    this.color,
    this.contentPaddingH,
    this.style,
    this.decoration,
    this.align = TextAlign.start,
  }) : super(key: key);

  final TextEditingController textController;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final String hint;
  final String? Function(String?)? validation;
  final bool? obscureText;
  final bool autofocus;
  final int? maxLan;
  final int? maxLine;
  final int? minLine;
  final bool? readOnly;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Color? color;
  final double? contentPaddingH;
  final TextStyle? style;
  final TextAlign align;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLine,
      minLines: minLine,
      maxLength: maxLan,
      validator: validation,
      focusNode: focusNode,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      style: style ??
          TextStyle(
              fontSize: 16.sp,
              color: color ?? Theme.of(context).colorScheme.primary,
              fontFamily: 'M',
              decoration: decoration,
              decorationColor: color ?? Theme.of(context).colorScheme.primary,
              decorationThickness: 2.w),
      controller: textController,
      textAlign: align,
      inputFormatters: textInputType == const TextInputType.numberWithOptions(signed: true) ? [FilteringTextInputFormatter.digitsOnly] : null,
      obscureText: obscureText ?? false,
      autofocus: autofocus,
      readOnly: readOnly ?? false,
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
          contentPadding: contentPaddingH != null ? EdgeInsets.symmetric(horizontal: contentPaddingH!) : null,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: hint.tr,
          hintStyle: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.primary.withOpacity(.5), fontFamily: 'B'),
          errorStyle: TextStyle(fontSize: 14.sp, color: const Color(0xffDC3545), fontFamily: 'M'),
          suffixIconConstraints: BoxConstraints(minHeight: 30.h, minWidth: 24.w),
          suffix: suffix,
          prefixIcon: prefixIcon),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.title, required this.leadingSvg, this.trailing});

  final String title;
  final String leadingSvg;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
      title: TextModel(title, fontSize: 13.sp),
      leading: SvgImage(leadingSvg, color: Theme.of(context).hintColor, width: 20.w, height: 20.w, fit: BoxFit.cover),
      trailing: trailing ?? SvgImage(I.arrowRight, color: Theme.of(context).hintColor, width: 18.w, height: 18.w, fit: BoxFit.cover),
    );
  }
}
