import 'package:daily_diary/allwidgets/color.dart';
import 'package:daily_diary/allwidgets/images.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/constant.dart';
import 'package:daily_diary/i.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PasscodeScreen extends StatefulWidget {
  final Function(String) onSuccess;
  final Function(String) onEntered;
  final String? oldPassword;

  const PasscodeScreen({Key? key, required this.onSuccess, required this.onEntered, this.oldPassword}) : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  final RxList<String> _input = <String>[].obs;
  final List<String> _keys = List<String>.generate(9, (index) => (index + 1).toString())..addAll(['', '0', '←']);

  void _onKeyPressed(String value) {
    if (value == '←') {
      _onBackspacePressed();
    } else if (_input.length < 4) {
      _input.add(value);
      widget.onEntered(_input.join(''));
      if (_input.length == 4) {
        final String enteredPasscode = _input.join('');
        if (enteredPasscode != widget.oldPassword && widget.oldPassword != null) {
          _input.clear();
        }
        widget.onSuccess(enteredPasscode);
      }
    }
  }

  void _onBackspacePressed() {
    if (_input.isNotEmpty) {
      _input.removeLast();
      widget.onEntered(_input.join(''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildPasscodeDots(),
        _buildNumberPad(),
      ],
    );
  }

  Widget _buildPasscodeDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Obx(() {
          _input;
          return Container(
            margin: EdgeInsets.all(8.w),
            width: 14.w,
            height: 14.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index < _input.length ? Theme.of(context).hintColor : Theme.of(context).primaryColor,
            ),
          );
        });
      }),
    );
  }

  Widget _buildNumberPad() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: isTab(context) ? 1.6 : 1, crossAxisSpacing: 24.w, mainAxisSpacing: 24.h),
      itemCount: _keys.length,
      itemBuilder: (context, index) {
        final String key = _keys[index];
        return key == '' ? SizedBox.shrink() : _buildNumberButton(key);
      },
    );
  }

  Widget _buildNumberButton(String number) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: number == '←' ? null : Colors.white),
      child: number == '←' ? SvgImage(I.delete_line, color: Theme.of(context).colorScheme.primary, height: 24.w, width: 24.w) : TextModel(number, fontSize: 28.sp, color: darkBlue),
    ).onTap(() {
      _onKeyPressed(number);
    });
  }
}
