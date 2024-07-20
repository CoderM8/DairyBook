import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

/// Use either the light or dark theme based on what the user has selected
int themeMode = 0;
bool isDark = false;
String? appPassword;
final RxString dateFormat = "dd/MM".obs;

bool isTab(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= 600 && MediaQuery.sizeOf(context).width < 2048;
}

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initTracking() async {
  final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  print('HELLO TRACKING STATUS $status');
  // If the system can show an authorization request dialog
  if (status == TrackingStatus.notDetermined) {
    // Wait for dialog popping animation
    await Future.delayed(const Duration(milliseconds: 200));
    // Request system's tracking authorization dialog
    await AppTrackingTransparency.requestTrackingAuthorization();
  }

  if (status == TrackingStatus.authorized) {
    await AppTrackingTransparency.getAdvertisingIdentifier();
  }
}

/// CUSTOM PAINT

class RPSCustomPainter extends CustomPainter {
  RPSCustomPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color;
    canvas.drawRRect(
        RRect.fromRectAndCorners(Rect.fromLTWH(size.width * 0.02531646, size.height * 0.02142857, size.width * 0.9493671, size.height * 0.8678571),
            bottomRight: Radius.circular(size.width * 0.07594937),
            bottomLeft: Radius.circular(size.width * 0.07594937),
            topLeft: Radius.circular(size.width * 0.07594937),
            topRight: Radius.circular(size.width * 0.07594937)),
        paint0Fill);

    final Path path_1 = Path();
    path_1.moveTo(size.width * 0.4843418, size.height * 0.9498929);
    path_1.lineTo(size.width * 0.4258924, size.height * 0.8695000);
    path_1.cubicTo(size.width * 0.4172184, size.height * 0.8575679, size.width * 0.4128797, size.height * 0.8516000, size.width * 0.4128354, size.height * 0.8465679);
    path_1.cubicTo(size.width * 0.4127975, size.height * 0.8421929, size.width * 0.4145411, size.height * 0.8380393, size.width * 0.4175601, size.height * 0.8352964);
    path_1.cubicTo(size.width * 0.4210348, size.height * 0.8321429, size.width * 0.4278734, size.height * 0.8321429, size.width * 0.4415506, size.height * 0.8321429);
    path_1.lineTo(size.width * 0.5584494, size.height * 0.8321429);
    path_1.cubicTo(size.width * 0.5721266, size.height * 0.8321429, size.width * 0.5789652, size.height * 0.8321429, size.width * 0.5824399, size.height * 0.8352964);
    path_1.cubicTo(size.width * 0.5854589, size.height * 0.8380393, size.width * 0.5872025, size.height * 0.8421929, size.width * 0.5871646, size.height * 0.8465679);
    path_1.cubicTo(size.width * 0.5871203, size.height * 0.8516000, size.width * 0.5827816, size.height * 0.8575679, size.width * 0.5741076, size.height * 0.8695000);
    path_1.lineTo(size.width * 0.5156582, size.height * 0.9498929);
    path_1.cubicTo(size.width * 0.5102911, size.height * 0.9572750, size.width * 0.5076044, size.height * 0.9609679, size.width * 0.5043829, size.height * 0.9623107);
    path_1.cubicTo(size.width * 0.5015538, size.height * 0.9634857, size.width * 0.4984462, size.height * 0.9634857, size.width * 0.4956171, size.height * 0.9623107);
    path_1.cubicTo(size.width * 0.4923956, size.height * 0.9609679, size.width * 0.4897089, size.height * 0.9572750, size.width * 0.4843418, size.height * 0.9498929);
    path_1.close();

    final Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension Extensions on Widget {
  Widget onTap(VoidCallback? onTap) {
    return InkWell(highlightColor: Colors.transparent, splashColor: Colors.transparent, onTap: onTap, child: this);
  }
}

void showToast(String msg, {bool s = true}) {
  Fluttertoast.showToast(msg: "${s ? '✅' : '🚫'} ${msg.tr}", textColor: Colors.black, backgroundColor: Colors.white, gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_LONG);
}

/// IMAGE PICK FUNCTION
Future<List> imagePick({ImageSource source = ImageSource.gallery, bool multi = true}) async {
  final ImagePicker picker = ImagePicker();
  if (multi) {
    final List<XFile> response = await picker.pickMultiImage();
    List img = [];
    if (response.isNotEmpty) {
      for (final file in response) {
        img.add(file.path);
      }
      return img;
    } else {
      return img;
    }
  } else {
    final XFile? response = await picker.pickImage(source: source);
    if (response != null) {
      return [response.path];
    } else {
      return [];
    }
  }
}

class Option {
  static TextStyle style(String value, {double? fontSize, FontWeight? fontWeight, Color? color, double? letterSpacing, double? height, String? fontFamily, TextDecoration? textDecoration}) {
    switch (value) {
      case "Default":
        {
          return TextStyle(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, fontFamily: fontFamily ?? "R", decoration: textDecoration);
        }
      case "Inter":
        {
          return GoogleFonts.inter(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "Satisfy":
        {
          return GoogleFonts.satisfy(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "Roboto":
        {
          return GoogleFonts.roboto(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "Alice":
        {
          return GoogleFonts.alice(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "Martel":
        {
          return GoogleFonts.martel(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "Praise":
        {
          return GoogleFonts.praise(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "Carter":
        {
          return GoogleFonts.carterOne(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "Bayon":
        {
          return GoogleFonts.bayon(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "PtSans":
        {
          return GoogleFonts.ptSans(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "Jost":
        {
          return GoogleFonts.jost(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      case "Lobster":
        {
          return GoogleFonts.lobster(fontSize: fontSize ?? 18.sp, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height, decoration: textDecoration);
        }
      default:
        return TextStyle(fontSize: fontSize ?? 18.sp, color: color, letterSpacing: letterSpacing, height: height, fontFamily: fontFamily ?? "R", fontWeight: fontWeight, decoration: textDecoration);
    }
  }
}

/// SORT LIST BY DATE
Map<T, List<S>> groupByDateList<S, T>(Iterable<S> values, T Function(S) key) {
  final map = <T, List<S>>{};
  for (final element in values) {
    (map[key(element)] ??= []).add(element);
  }
  return map;
}
