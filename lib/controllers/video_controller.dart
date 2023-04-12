import 'dart:async';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoController;
  var position = const Duration(seconds: 0).obs;
  var duration = const Duration(seconds: 0).obs;
  var isShowOverlay = true.obs;
  var startOverlayTimming = true.obs;
  var mute = true.obs;
  var isFullScreen = true.obs;

  Timer _timer = Timer(const Duration(seconds: 100), () {});

  @override
  void onClose() {
    // videoController.dispose();
    super.onClose();
  }

  void setVideoController(VideoPlayerController controller) =>
      videoController = controller;
  void changePosition(Duration value) => position(value);
  void chagneDuration(Duration value) => duration(value);
  void changeMute(bool value) => mute(value);
  void changeIsFullScreen(bool value) => isFullScreen(value);
  void changeShowOverlay(bool value) {
    if (value) {
      autoHideOverlay();
    } else {
      _timer.cancel();
    }
    isShowOverlay(value);
    // update();
  }

  void autoHideOverlay() {
    _timer.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isShowOverlay() && _timer.tick == 5) {
        changeShowOverlay(false);
        _timer.cancel();
      } else if (!isShowOverlay()) {
        _timer.cancel();
      }
    });
  }
}
