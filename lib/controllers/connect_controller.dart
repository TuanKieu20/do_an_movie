import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool get isLostConnect => !Get.find<ConnectivityController>().isConnected.value;

class ConnectivityController extends GetxController {
  factory ConnectivityController() {
    return _connectivityController;
  }
  ConnectivityController._internal();
  static final ConnectivityController _connectivityController =
      ConnectivityController._internal();

  var isConnected = true.obs;
  bool get isConnect => isConnected.value;

  Future<bool> check() async {
    ConnectivityResult _result = await Connectivity().checkConnectivity();
    return (_result == ConnectivityResult.wifi ||
        _result == ConnectivityResult.mobile);
  }

  void listenConectionChanged() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isConnected.value = (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile);

      if (isConnected.value) {
        if (Get.isSnackbarOpen) {
          Get.back();
        }
        if (isReconnect(isConnected.value)) {
          showConnectionSnackbar(isConnect: true);
        }
      } else {
        showConnectionSnackbar(isConnect: false);
      }
    });
  }

  bool isReconnect(status) => (status && !isConnected());

  void showConnectionSnackbar({required bool isConnect}) {
    const String connectedString = 'Đã khôi phục kết nối mạng!';
    const String lostConnectString =
        'Đã mất kết nối mạng. Vui lòng kiểm tra tín hiệu kết nối!';
    Get.snackbar(
      '',
      isConnect ? connectedString : lostConnectString,
      backgroundColor: isConnect ? Colors.greenAccent : Colors.red,
      duration: Duration(seconds: isConnect ? 3 : 5),
      titleText: Container(),
      colorText: Colors.white,
    );
  }
}
