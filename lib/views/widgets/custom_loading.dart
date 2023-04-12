import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/loading_controller.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading(
      {super.key, required this.child, this.tapDismiss = false});
  final Widget child;
  final bool tapDismiss;

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> {
  final loadingController = Get.put(LoadingController());
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(children: [
        widget.child,
        GetX<LoadingController>(builder: (builder) {
          return loadingController.isShowLoading()
              ? GestureDetector(
                  onTap: () {
                    if (widget.tapDismiss) {
                      Get.find<LoadingController>().changShowLoading(false);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: const Color(0xff666666).withOpacity(0.7),
                    child: Container(
                      width: 70,
                      height: 70,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                )
              : const SizedBox();
        })
      ]),
    );
  }
}

showLoadingOverlay() {
  Get.find<LoadingController>().changShowLoading(true);
}

hideLoadingOverlay() {
  Get.find<LoadingController>().changShowLoading(false);
}
