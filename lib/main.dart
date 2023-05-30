// import 'package:firebase_auth/firebase_auth.dart';
import 'package:do_an_movie/constants/router.dart';
import 'package:do_an_movie/controllers/admin_controller.dart';
import 'package:do_an_movie/controllers/connect_controller.dart';
import 'package:do_an_movie/controllers/livestream_controller.dart';
import 'package:do_an_movie/controllers/loading_controller.dart';
import 'package:do_an_movie/controllers/login_controller.dart';
import 'package:do_an_movie/controllers/search_controller.dart';
import 'package:do_an_movie/controllers/splash_controller.dart';
import 'package:do_an_movie/views/widgets/custom_loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/home_controller.dart';
import 'controllers/on_boarding_controller.dart';
import 'controllers/register_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  Get.put(LoadingController());
  Get.put(ConnectivityController());
  Get.lazyPut(() => SplashController());
  Get.put(HomeController());

  Get.put(LoginController());
  Get.put(AdminController());
  // Get.put(SearchController());
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut((() => OnboardingController()));
  Get.lazyPut((() => RegisterController()));
  Get.lazyPut(() => SearchController());
  Get.lazyPut(() => LivestreamControlelr());
  // logger.i(DateTime.now());
  // Get.lazyPut(() => HomeController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // Get.find<ConnectivityController>().listenConectionChanged();
    final pref = Get.find<SharedPreferences>();
    if (pref.getBool('checkUpdateInf') == null) {
      pref.setBool('checkUpdateInf', false);
    }

    if (pref.getBool('showIntro') == null) {
      pref.setBool('showIntro', true);
    } else {
      pref.setBool('showIntro', false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: AppRouter.pages,
      initialRoute: Routes.splash,
      debugShowCheckedModeBanner: false,
      builder: ((context, child) {
        return GetBuilder<SplashController>(builder: (builder) {
          return GetBuilder<LoadingController>(builder: (builder) {
            return CustomLoading(child: child!);
          });
        });
      }),
    );
  }
}
