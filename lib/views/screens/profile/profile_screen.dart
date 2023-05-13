import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/profile_controller.dart';
import '../../helpers/helper.dart';
import 'widgets/premium_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return GetBuilder<ProfileController>(builder: (builder) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          centerTitle: false,
          leadingWidth: 60,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Image.asset(
              'assets/images/logo.png',
              width: 40,
              height: 40,
            ),
          ),
          title: Text(
            'Profile',
            style: mikado600.copyWith(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PremiumHeader(),
                const SizedBox(height: 10),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      rowProfile(
                          icon: Icons.person_outline_rounded,
                          text: 'Cá nhân',
                          onTap: () {
                            // await Get.find<HomeController>().getInforUser();
                            Get.toNamed(Routes.editProfile);
                          }),
                      rowProfile(
                          icon: Icons.history,
                          text: 'Lịch sử giao dịch',
                          onTap: () => Get.toNamed(Routes.historyPayment)),
                      rowProfile(
                          icon: Icons.notifications_none_rounded,
                          text: 'Thông báo',
                          onTap: (() => Get.toNamed(Routes.notification))),
                      rowProfile(
                        icon: Icons.file_download_outlined,
                        text: 'Tải xuống',
                        onTap: () => Get.toNamed(Routes.download),
                      ),
                      rowProfile(
                          icon: Icons.security,
                          text: 'Bảo mật',
                          onTap: (() => Get.toNamed(Routes.security))),
                      rowProfile(
                          icon: Icons.language_rounded,
                          text: 'Ngôn ngữ',
                          isLanguage: true),
                      rowProfile(
                        icon: Icons.dark_mode_outlined,
                        text: 'Chế độ ban đêm',
                        isDarkMode: true,
                      ),
                      rowProfile(
                          icon: Icons.logout_rounded,
                          text: 'Đăng xuất',
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            // Get.find<HomeController>().isUserVip(false);
                            // Get.put(SearchController());
                            Get.offAllNamed(Routes.login);
                          }),
                    ],
                  ),
                ))
              ],
            )),
      );
    });
  }

  InkWell rowProfile(
      {VoidCallback? onTap,
      required IconData icon,
      required String text,
      bool isLanguage = false,
      bool isDarkMode = false}) {
    return InkWell(
      onTap: onTap ?? () => Helper.showDialogFuntionLoss(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: mikado500,
            ),
            const Spacer(),
            if (isLanguage) const Text('Vietnamese', style: mikado500),
            const SizedBox(width: 10),
            isDarkMode
                ? CupertinoSwitch(
                    value: Get.find<ProfileController>().isDarkMode.value,
                    activeColor: Colors.red,
                    trackColor: Colors.grey,
                    onChanged: ((value) {
                      Get.find<ProfileController>().changeDarkMode(value);
                    }))
                : const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  )
          ],
        ),
      ),
    );
  }
}

class RowProfile extends StatelessWidget {
  const RowProfile(
      {super.key,
      this.onTap,
      required this.icon,
      required this.text,
      this.isLanguage = false,
      this.isDarkMode = false,
      this.isShowIcon = true});

  final VoidCallback? onTap;
  final bool isLanguage;
  final bool isDarkMode;
  final IconData icon;
  final String text;
  final bool isShowIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Helper.showDialogFuntionLoss(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isShowIcon)
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            if (isShowIcon) const SizedBox(width: 20),
            Text(
              text,
              style: mikado500,
            ),
            const Spacer(),
            if (isLanguage) const Text('Vietnamese', style: mikado500),
            const SizedBox(width: 10),
            isDarkMode
                ? CupertinoSwitch(
                    value: true,
                    activeColor: Colors.red,
                    trackColor: Colors.grey,
                    onChanged: (value) {})
                : const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  )
          ],
        ),
      ),
    );
  }
}
