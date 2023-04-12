import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../../constants/styles.dart';
import '../profile_screen.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

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
          'Tải xuống',
          style: mikado500.copyWith(fontSize: 21),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: const [
          RowProfile(
              icon: Icons.wifi,
              text: 'Chỉ tải xuống khi dùng wifi',
              isDarkMode: true),
          RowProfile(
            icon: Icons.file_download_outlined,
            text: 'Tải xuống thông minh',
          ),
          RowProfile(icon: Icons.high_quality, text: 'Chất lượng video cao'),
          RowProfile(
            icon: Icons.mic_none_rounded,
            text: 'Chất lượng âm thanh cao',
          ),
        ]),
      ),
    );
  }
}
