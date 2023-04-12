import 'package:get/get.dart';

class BottomNavigatorController extends GetxController {
  var currentIndex = 0.obs;

  void changeCurrentIndex({required int index}) {
    currentIndex(index);
  }
}
