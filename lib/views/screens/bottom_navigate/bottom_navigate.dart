import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/styles.dart';
import '../../../controllers/bottom_navigator.dart';
import '../../../controllers/home_controller.dart';
import '../custom_room/custom_room_screen.dart';
import '../home_screen/home_screen.dart';
import '../livestream_screen/livestream_screen.dart';
import '../profile/profile_screen.dart';
import '../search_screen.dart/search_screen.dart';

class BottomNavigateScreen extends StatelessWidget {
  BottomNavigateScreen({super.key});

  final controller = Get.put(BottomNavigatorController());

  final List<BottomNavigationBarItem> _listScreen = [
    BottomNavigationBarItem(
        activeIcon: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SvgPicture.asset(
              'assets/svgs/bottom_bar/coolicon.svg',
              height: 30,
              color: Colors.red,
            )),
        icon: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SvgPicture.asset('assets/svgs/bottom_bar/coolicon.svg',
                height: 30, color: const Color(0xFF9E9E9E))),
        label: 'Trang chủ'),
    BottomNavigationBarItem(
        activeIcon: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SvgPicture.asset('assets/svgs/bottom_bar/search.svg',
                height: 30, color: Colors.red)),
        icon: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SvgPicture.asset('assets/svgs/bottom_bar/search.svg',
                height: 30, color: const Color(0xFF9E9E9E))),
        label: 'Tìm kiếm'),
    const BottomNavigationBarItem(
        activeIcon: Padding(
          padding: EdgeInsets.all(7.0),
          child: Icon(
            Icons.bookmark_add,
            size: 32,
          ),
        ),
        icon: Padding(
          padding: EdgeInsets.all(7.0),
          child: Icon(
            Icons.bookmark_add,
            size: 32,
          ),
        ),
        label: 'Yêu thích'),
    BottomNavigationBarItem(
        activeIcon: Padding(
          padding: const EdgeInsets.all(7.0),
          child: SvgPicture.asset('assets/svgs/bottom_bar/live_select.svg',
              height: 30),
        ),
        icon: Padding(
          padding: const EdgeInsets.all(7.0),
          child: SvgPicture.asset(
            'assets/svgs/bottom_bar/live.svg',
            height: 30,
            // color: Color(0xFF9E9E9E),
          ),
        ),
        label: 'Phòng live'),
    BottomNavigationBarItem(
        activeIcon: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SvgPicture.asset('assets/svgs/bottom_bar/more.svg',
                height: 30, color: Colors.red)),
        icon: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SvgPicture.asset('assets/svgs/bottom_bar/more.svg',
                height: 30, color: const Color(0xFF9E9E9E))),
        label: 'Xem thêm'),
  ];

  @override
  Widget build(BuildContext context) {
    return GetX<BottomNavigatorController>(builder: (builder) {
      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            HomeScreen(),
            SearchScreen(),
            CustomRoomScreen(),
            LiveStreamScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 108,
          child: BottomNavigationBar(
            backgroundColor: Colors.black.withOpacity(0.8),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedLabelStyle: mikado700.copyWith(fontSize: 10),
            selectedLabelStyle: mikado700.copyWith(fontSize: 10),
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            elevation: 0.0,
            currentIndex: controller.currentIndex.value,
            items: _listScreen,
            onTap: (value) async {
              if (value == 2) {
                await Get.find<HomeController>().getMoviesFavorite();
              }
              controller.changeCurrentIndex(index: value);
            },
          ),
        ),
      );
    });
  }
}
