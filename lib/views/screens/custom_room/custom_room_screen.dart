import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/home_controller.dart';

class CustomRoomScreen extends StatefulWidget {
  const CustomRoomScreen({super.key});

  @override
  State<CustomRoomScreen> createState() => _CustomRoomScreenState();
}

class _CustomRoomScreenState extends State<CustomRoomScreen> {
  final homeController = Get.find<HomeController>();
  @override
  void initState() {
    homeController.getMoviesFavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        leadingWidth: 60,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {},
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.add,
                size: 32,
              )),
          const SizedBox(width: 10),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(
            'assets/images/logo.png',
            width: 30,
            height: 30,
          ),
        ),
        title: Text(
          'Danh sách yêu thích',
          style: mikado500.copyWith(fontSize: 18),
        ),
      ),
      body: homeController.moviesFavorite.isNotEmpty
          ? ListView.builder(
              itemCount: homeController.moviesFavorite.length,
              itemBuilder: ((context, index) {
                return Dismissible(
                  onDismissed: (direction) {
                    homeController.removeMovieFavorit(
                        homeController.moviesFavorite[index].id!);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      size: 36,
                    ),
                  ),
                  key: UniqueKey(),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.detailMovie, arguments: {
                        'movie': homeController.moviesFavorite[index]
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: homeController
                                              .moviesFavorite[index].poster ==
                                          ''
                                      ? const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/image_error.jpeg'),
                                          fit: BoxFit.cover)
                                      : DecorationImage(
                                          image: NetworkImage(homeController
                                              .moviesFavorite[index].poster!),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.bottomCenter)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    homeController.moviesFavorite[index].name ??
                                        'Name Movie',
                                    style: mikado600.copyWith(fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person_pin_rounded,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        homeController
                                            .moviesFavorite[index].author!,
                                        style: mikado400.copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        homeController
                                            .moviesFavorite[index].time!,
                                        style: mikado400.copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              }))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    // color: Colors.white,
                    width: 300,
                    height: 300,
                    child: Image.asset(
                      'assets/images/list_empty.png',
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'Danh sách yêu thích chưa có phim nào !',
                    style:
                        mikado500.copyWith(color: Colors.white60, fontSize: 20),
                  )
                ],
              ),
            ),
    );
  }
}
