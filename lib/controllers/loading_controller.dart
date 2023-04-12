import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isShowLoading = false.obs;

  changShowLoading(value) => isShowLoading(value);
}
