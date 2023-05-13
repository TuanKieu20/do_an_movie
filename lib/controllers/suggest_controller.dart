import 'package:get/get.dart';

class SuggestTopicController extends GetxController {
  var isEighteenAge = (-1).obs;
  var selectTopic = [false, false, false, false, false].obs;

  void changeAge(int value) {
    isEighteenAge(value);
    update();
  }

  void changeTopic(bool value, int index) {
    selectTopic()[index] = value;
    // switch (index) {
    //   case 0:
    //     selectTopic()[0] = value;
    //     break;
    //   case 1:
    //     selectTopic()[1] = value;
    //     break;
    //   case 2:
    //     selectTopic()[2] = value;
    //     break;
    //   case 3:
    //     selectTopic()[3] = value;
    //     break;
    //   case 4:
    //     selectTopic()[4] = value;
    //     break;
    //   default:
    // }
    update();
  }
}
