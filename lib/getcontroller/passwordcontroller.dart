import 'package:daily_diary/constant/constant.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  final RxBool isEnable = false.obs;
  final RxBool isWrong = false.obs;
  final RxString password = "".obs;
  final RxString confirm = "".obs;

  @override
  void onInit() async {
    if (appPassword != null) {
      isEnable.value = true;
    }
    super.onInit();
  }
}
