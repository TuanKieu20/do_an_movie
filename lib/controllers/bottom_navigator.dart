import 'package:get/get.dart';

import 'home_controller.dart';

class BottomNavigatorController extends GetxController {
  var currentIndex = 0.obs;
  @override
  void onInit() {
    Get.find<HomeController>().getMoviesForYou();
    super.onInit();
  }

  void changeCurrentIndex({required int index}) {
    currentIndex(index);
  }
}
