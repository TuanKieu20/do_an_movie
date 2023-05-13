import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/admin_controller.dart';
import 'movies_manage.dart';
import 'reciept_screen.dart';
import 'user_manage.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});
  final controller = Get.put(AdminController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminController>(builder: (context) {
      return Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                controller.scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu_rounded,
                size: 32,
              )),
          title: Text(
            'Admin Page',
            style: mikado500.copyWith(color: Colors.white, fontSize: 22),
          ),
        ),
        drawer: const NavigationDrawer(),
        body: _body(),
      );
    });
  }

  Widget _body() {
    switch (controller.indexPage.value) {
      case 0:
        return const UserManager();
      case 1:
        return const MoviesManage();
      case 2:
        return RecieptScreen();
      default:
    }
    return Container();
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Thanh Điều Hướng',
              style: mikado500.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Quản lý người dùng'),
            onTap: () {
              // Navigate to the home page.
              controller.changeIndexPage(0);
              controller.scaffoldKey.currentState!.closeDrawer();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.video_camera_back_outlined,
            ),
            title: const Text('Quản lý phim'),
            onTap: () {
              controller.changeIndexPage(1);
              controller.scaffoldKey.currentState!.closeDrawer();
              // Na
              //vigate to the settings page.
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.receipt_rounded,
            ),
            title: const Text('Quản lý giao dịch'),
            onTap: () {
              controller.changeIndexPage(2);
              controller.scaffoldKey.currentState!.closeDrawer();
              // Na
              //vigate to the settings page.
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
            ),
            title: const Text('Đăng xuất'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(Routes.login);
            },
          ),
        ],
      ),
    );
  }
}
