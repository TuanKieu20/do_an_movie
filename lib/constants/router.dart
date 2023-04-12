import 'package:get/route_manager.dart';

import '../views/screens/all_comments/all_comments_screen.dart';
import '../views/screens/all_movie_screen.dart/all_movie_screen.dart';
import '../views/screens/all_onboarding/all_onboarding.dart';
import '../views/screens/bottom_navigate/bottom_navigate.dart';
import '../views/screens/detail_movie_screen/detail_movie_screen.dart';
import '../views/screens/home_screen/home_screen.dart';
import '../views/screens/login/login_screen.dart';
import '../views/screens/profile/widgets/download_screen.dart';
import '../views/screens/profile/widgets/edit_profile_screen.dart';
import '../views/screens/profile/widgets/notification_screen.dart';
import '../views/screens/profile/widgets/security_screen.dart';
import '../views/screens/register/register_screen.dart';
import '../views/screens/splash_screen/splash_screen.dart';
import '../views/widgets/custom_video_player.dart';

class Routes {
  static const splash = '/';
  static const onBoarding = '/onboarding';
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const bottomNavigator = '/bottomNavigator';
  static const allMovie = '/allMovie';
  static const detailMovie = '/detailMovie';
  static const customVideo = '/customVideo';
  static const allComments = '/allComments';
  static const editProfile = '/editProfile';
  static const notification = '/notification';
  static const download = '/download';
  static const security = '/security';
}

class AppRouter {
  static final pages = [
    GetPage(name: Routes.home, page: (() => const HomeScreen())),
    GetPage(name: Routes.login, page: (() => const LoginScreen())),
    GetPage(
      name: Routes.splash,
      page: (() => const SplashScreen()),
    ),
    GetPage(name: Routes.onBoarding, page: (() => const AllOnboarding())),
    GetPage(name: Routes.register, page: (() => const RegisterScreen())),
    GetPage(name: Routes.bottomNavigator, page: (() => BottomNavigateScreen())),
    GetPage(name: Routes.allMovie, page: (() => const AllMovieScreen())),
    GetPage(name: Routes.detailMovie, page: (() => const DetailMovieScreen())),
    GetPage(name: Routes.customVideo, page: (() => CustomVideoPlayer())),
    GetPage(name: Routes.allComments, page: (() => AllCommentsScreen())),
    GetPage(name: Routes.editProfile, page: (() => const EditProfileScreen())),
    GetPage(
        name: Routes.notification, page: (() => const NotificationScreen())),
    GetPage(name: Routes.download, page: (() => const DownloadScreen())),
    GetPage(name: Routes.security, page: (() => const SecurityScreen())),
  ];
}
