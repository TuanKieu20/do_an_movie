import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/router.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void dispose() {
    // Get.delete<SplashController>();
    super.dispose();
  }

  @override
  void initState() {
    final pref = Get.find<SharedPreferences>();
    final loginController = Get.find<LoginController>();
    final homeController = Get.find<HomeController>();
    if (pref.getBool('showIntro') == true) {
      pref.setBool('checkUpdateInf', true);
      Future.delayed(const Duration(seconds: 5))
          .then((value) => Get.offAllNamed(Routes.onBoarding));
    } else {
      var checkUserLogin = loginController.checkUserLogin();
      if (checkUserLogin) {
        //remove !
        if (pref.getBool('checkUpdateInf') == true) {
          homeController.getMoviesForYou().then((value) {
            bool isAdmin = homeController.userInforMore['isAdmin'] == null
                ? false
                : homeController.userInforMore['isAdmin'] as bool;

            if (isAdmin) {
              Future.delayed(const Duration(seconds: 5))
                  .then((value) => Get.offAllNamed(Routes.admin));
            } else {
              Future.delayed(const Duration(seconds: 5))
                  .then((value) => Get.offAllNamed(Routes.bottomNavigator));
            }
            return value;
          });
        } else {
          Future.delayed(const Duration(seconds: 5))
              .then((value) => Get.offAllNamed(Routes.suggestTopic));
        }
      } else {
        Future.delayed(const Duration(seconds: 5))
            .then((value) => Get.offAllNamed(Routes.login));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
          child: Lottie.asset('assets/jsons/9103-entertainment.json',
              fit: BoxFit.scaleDown)),
    );
  }
}
