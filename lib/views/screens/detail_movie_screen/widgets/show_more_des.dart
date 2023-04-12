import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/styles.dart';
import '../../../../controllers/home_controller.dart';

class ShowMoreDesc extends StatelessWidget {
  ShowMoreDesc({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final dynamic movie;
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        // padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.6),
        ),
        child: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.6,
          // height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.black),
          child: Column(
            children: [
              Align(
                alignment: const Alignment(1.1, -1),
                child: IconButton(
                    onPressed: () {
                      controller.changeShowMore(!controller.isShowMore());
                    },
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 32,
                      color: Colors.white,
                    )),
              ),
              Text(
                movie['movie'].name,
                textAlign: TextAlign.center,
                style: mikado500.copyWith(fontSize: 20),
              ),
              const Divider(
                thickness: 1.0,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: SingleChildScrollView(
                child: Text(
                  movie['movie'].description,
                  textAlign: TextAlign.justify,
                  style: mikado400.copyWith(),
                ),
              )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
