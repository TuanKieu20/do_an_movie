import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../widgets/custom_button.dart';

class OptionLoggin extends StatelessWidget {
  const OptionLoggin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bạn muốn tới trang nào ?',
              style: mikado500.copyWith(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: Get.width * 0.7,
              child: CustomButton(
                  onTap: () {
                    Get.offAllNamed(Routes.admin);
                  },
                  color: Colors.white,
                  text: 'Admin Page',
                  backgroundColor: Colors.blue),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: Get.width * 0.7,
              child: CustomButton(
                  onTap: () {
                    Get.offAllNamed(Routes.bottomNavigator);
                  },
                  color: Colors.white,
                  text: 'User Page',
                  backgroundColor: Colors.redAccent),
            )
          ],
        ),
      ),
    );
  }
}
