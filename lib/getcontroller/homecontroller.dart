import 'package:daily_diary/database/sqflite.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<DiaryModel> items = <DiaryModel>[].obs;
  final RxBool isLoad = false.obs;
  final RxBool isSort = true.obs;
  final RxBool isDelete = false.obs;
  final RxBool isVisible = false.obs;
  final Rx<DateTime> nowDate = DateTime.now().obs;

  void refresh() {
    isDelete.value = !isDelete.value;
  }

  @override
  Future<void> onInit() async {
    await getDiary();
    super.onInit();
  }

  Future<void> getDiary() async {
    isLoad.value = true;
    await DatabaseHelper.getMyDiary().then((List<DiaryModel> list) async {
      for (final DiaryModel ele in list) {
        items.add(ele);
      }
    });
    isLoad.value = false;
  }
}
