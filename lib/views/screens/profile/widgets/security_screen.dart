import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/styles.dart';
import '../../../widgets/custom_button.dart';
import '../profile_screen.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Điều khiển',
              style: mikado600.copyWith(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 15),
            const RowProfile(
                icon: Icons.abc, text: 'Thay đổi  mật', isShowIcon: false),
            const RowProfile(
                icon: Icons.abc, text: 'Quản lí thiết bị', isShowIcon: false),
            const RowProfile(
                icon: Icons.abc,
                text: 'Quản lí thông báo quyền',
                isShowIcon: false),
            Text(
              'Bảo mật',
              style: mikado600.copyWith(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 15),
            const RowProfile(
              icon: Icons.abc,
              text: 'Lưu thông tin',
              isShowIcon: false,
              isDarkMode: true,
            ),
            const RowProfile(
              icon: Icons.abc,
              text: 'Xác thực khuân mặt',
              isShowIcon: false,
              isDarkMode: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () {},
              color: Colors.white,
              text: 'Change PIN',
              backgroundColor: const Color(0xff20232b),
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }
}
