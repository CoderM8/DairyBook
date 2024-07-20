import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SvgImage extends GetView {
  final String url;
  final Color? color;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final BoxFit fit;

  const SvgImage(this.url, {super.key, this.color, this.height, this.width, this.onTap, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: SvgPicture.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }
}

class ImageView {
  static Widget network(String url, {double width = 200, double height = 200, bool circle = false, double radius = 8}) {
    return Container(
      height: height,
      width: width,
      decoration: circle
          ? BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
            ),
    );
  }

  static Widget asset(String url, {double width = 200, double height = 200, bool circle = false, double radius = 8}) {
    return Container(
      height: height,
      width: width,
      decoration: circle
          ? BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover),
            ),
    );
  }

  static Widget file(String url, {double width = 200, double height = 200, bool circle = false, double radius = 8}) {
    return Container(
      height: height,
      width: width,
      decoration: circle == true
          ? BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: FileImage(File(url)), fit: BoxFit.cover),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              image: DecorationImage(image: FileImage(File(url)), fit: BoxFit.cover),
            ),
    );
  }
}
