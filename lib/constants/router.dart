import 'package:get/route_manager.dart';

import '../views/screens/admin/add_movie.dart';
import '../views/screens/admin/admin_screen.dart';
import '../views/screens/admin/option_loggin.dart';
import '../views/screens/all_comments/all_comments_screen.dart';
import '../views/screens/all_movie_screen.dart/all_movie_screen.dart';
import '../views/screens/all_onboarding/all_onboarding.dart';
import '../views/screens/bottom_navigate/bottom_navigate.dart';
import '../views/screens/buy_premium/confirm_payment.dart';
import '../views/screens/buy_premium/options_payment.dart';
import '../views/screens/buy_premium/subscribe_premium.dart';
import '../views/screens/detail_movie_screen/detail_movie_screen.dart';
import '../views/screens/home_screen/home_screen.dart';
import '../views/screens/login/login_screen.dart';
import '../views/screens/profile/widgets/download_screen.dart';
import '../views/screens/profile/widgets/edit_profile_screen.dart';
import '../views/screens/profile/widgets/history_payment.dart';
import '../views/screens/profile/widgets/notification_screen.dart';
import '../views/screens/profile/widgets/security_screen.dart';
import '../views/screens/register/register_screen.dart';
import '../views/screens/splash_screen/splash_screen.dart';
import '../views/screens/suggest_topics/suggest_topic_screen.dart';
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
  static const suggestTopic = '/suggestTopic';
  static const subPremium = '/subPremium';
  static const optionPayment = '/optionPayment';
  static const confirmPayment = '/confirmPayment';
  static const admin = '/admin';
  static const addMovie = '/addMovie';
  static const optionLogin = '/optionLogin';
  static const historyPayment = '/historyPayment';
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
    GetPage(
        name: Routes.suggestTopic, page: (() => const SuggestTopicScreen())),
    GetPage(name: Routes.subPremium, page: (() => const SubPremiumScreen())),
    GetPage(name: Routes.optionPayment, page: (() => const OptionPayment())),
    GetPage(name: Routes.confirmPayment, page: (() => const ConfirmPayment())),
    GetPage(name: Routes.admin, page: (() => AdminScreen())),
    GetPage(name: Routes.addMovie, page: (() => const AddMovie())),
    GetPage(name: Routes.optionLogin, page: (() => const OptionLoggin())),
    GetPage(
        name: Routes.historyPayment, page: (() => const HistoryPaymentScreen()))
  ];
}
