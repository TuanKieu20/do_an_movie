import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var index = 0.obs;

  final PageController controller = PageController();

  void changeIndexPage(value) {
    index(value);
    update();
  }
}
