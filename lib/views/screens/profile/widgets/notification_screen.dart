import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../../constants/styles.dart';
import '../../../../controllers/profile_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            )),
        title: Text(
          'Thông báo',
          style: mikado500.copyWith(fontSize: 21),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GetBuilder<ProfileController>(builder: (builder) {
          return Column(
            children: [
              _buildItem(
                  text: 'Thông báo chung',
                  func: () =>
                      builder.changeNotiValue(0, !builder.notiValue1.value),
                  value: builder.notiValue1.value),
              _buildItem(
                  text: 'Thông báo mới',
                  func: () =>
                      builder.changeNotiValue(1, !builder.notiValue2.value),
                  value: builder.notiValue2.value),
              _buildItem(
                  text: 'Tính năng mới phù hợp',
                  func: () =>
                      builder.changeNotiValue(2, !builder.notiValue3.value),
                  value: builder.notiValue3.value),
              _buildItem(
                  text: 'Phim mới phát hàng',
                  func: () =>
                      builder.changeNotiValue(3, !builder.notiValue4.value),
                  value: builder.notiValue4.value),
              _buildItem(
                  text: 'Cập nhật ứng dụng',
                  func: () =>
                      builder.changeNotiValue(4, !builder.notiValue5.value),
                  value: builder.notiValue5.value),
              _buildItem(
                  text: 'Theo dõi',
                  func: () =>
                      builder.changeNotiValue(5, !builder.notiValue6.value),
                  value: builder.notiValue6.value),
            ],
          );
        }),
      ),
    );
  }

  Padding _buildItem(
      {required String text, required Function func, required bool value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: mikado400.copyWith(color: Colors.white, fontSize: 18),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: ((value) {
              func();
            }),
            activeColor: Colors.red,
            trackColor: Colors.grey,
          )
        ],
      ),
    );
  }
}
