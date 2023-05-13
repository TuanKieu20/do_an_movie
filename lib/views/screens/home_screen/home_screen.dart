import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/movie_model.dart';
import '../../helpers/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  var opacity = 0.0;
  final controller = Get.find<HomeController>();
  @override
  void initState() {
    // controller.getMoviesForYou();
    // controller.getMovies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await controller.getMoviesForYou();
      // await controller.getMovies();
      // await controller.getMoviesForYou();
      // _scrollController.addListener(() {
      //   setState(() {
      //     // logger.d(_scrollController.position.maxScrollExtent);
      //     // logger.d(_scrollController.position.pixels.toInt());
      //     opacity = _scrollController.position.pixels /
      //         _scrollController.position.maxScrollExtent;
      //     if (opacity > 1.0) {
      //       opacity = 1.0;
      //     }
      //     if (opacity < 0.0) {
      //       opacity = 0.0;
      //     }
      //   });
      // });
    });
    // controller.getMovies();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    return GetBuilder<HomeController>(builder: (builder) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _header(),
            RowTitle(
                title: 'Movies For You',
                func: () {
                  Get.toNamed(Routes.allMovie, arguments: {
                    'title': 'Movies For You',
                    'movies': controller.moviesForYou
                  });
                }),
            _buildMoviesForYou(),
            RowTitle(
                title: 'Top 10 Movies This Week',
                func: () {
                  Get.toNamed(Routes.allMovie, arguments: {
                    'title': 'Top 10 Movies This Week',
                    'movies': controller.top10Movies
                  });
                }),
            RowMovies(list: controller.top10Movies),
            RowTitle(
                title: 'New Releases',
                func: () {
                  Get.toNamed(Routes.allMovie, arguments: {
                    'title': 'New Releases',
                    'movies': controller.moviesNew
                  });
                }),
            RowMovies(
              list: controller.moviesNew,
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            )
          ],
        ),
      );
    });
  }

  SliverToBoxAdapter _buildMoviesForYou() {
    return SliverToBoxAdapter(
        child: Container(
      // color: Colors.green,
      height: 150,
      padding: const EdgeInsets.only(left: 20),
      child: ListView.builder(
          itemCount: controller.moviesForYou.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: (() => Get.toNamed(Routes.detailMovie,
                    arguments: {'movie': controller.moviesForYou[index]})),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      // margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 3.0,
                            color: Helper.colorBorder[Random().nextInt(6)]),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            controller.moviesForYou[index].poster ?? '',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Text(
                        controller.moviesForYou[index].name ?? '',
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: mikado600.copyWith(
                            color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
    ));
  }

  SliverAppBar _header() {
    return SliverAppBar(
      elevation: 0.0,
      backgroundColor: Colors.black,
      expandedHeight: 300,
      collapsedHeight: 70,
      leadingWidth: 70,
      pinned: true,
      // floating: true,
      // snap: true,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Image.asset('assets/images/logo.png', width: 36, height: 36),
      ),
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              // image: NetworkImage(controller.movieTrending!.poster!),
              image: CachedNetworkImageProvider(
                controller.movieTrending!.poster ??
                    'assets/images/image_error.jpeg',
                errorListener: () => Image.asset(
                  'assets/images/image_error.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
              ),
            ),
          ),
          // Image.network(
          //   controller.movieTrending!.poster!,
          //   fit: BoxFit.cover,
          //   alignment: Alignment.topCenter,
          // ),
          // ClipRRect(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          //     child: const SizedBox.expand(),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.movieTrending!.name!,
                  style: mikado600.copyWith(fontSize: 20),
                ),
                SizedBox(
                  width: 300,
                  child: Text(
                    controller.movieTrending!.description!,
                    maxLines: 1,
                    // textWidthBasis: TextWidthBas,
                    overflow: TextOverflow.ellipsis,
                    style: mikado400.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _button(
                      onTap: () async {
                        await SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersiveSticky);
                        await SystemChrome.setPreferredOrientations(
                          [
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ],
                        );
                        Get.toNamed(Routes.customVideo, arguments: {
                          'movie': controller.movieTrending,
                          'isTrailer': false
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    _button(
                        backgroundColor: Colors.transparent,
                        text: 'My List',
                        icon: Icons.add,
                        border: Border.all(width: 1.0, color: Colors.white),
                        width: 130,
                        // onTap: (() => Helper.showDialogFuntionLoss()))
                        onTap: () {
                          controller.addMovieFavorite(
                              idMovie: controller.movieTrending!.id);
                        })
                  ],
                ),
                const SizedBox(height: 30)
              ],
            ),
          )
        ],
      )),
      actions: [
        // IconButton(
        //   onPressed: () {
        //     Helper.showDialogFuntionLoss();
        //     // Get.find<HomeController>().getMovies();
        //   },
        //   icon: const Icon(
        //     Icons.search_outlined,
        //     size: 28,
        //   ),
        // ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {
            Helper.showDialogFuntionLoss();
            // controller.getMoviesTop10();
          },
          icon: const Icon(
            Icons.notifications_none_rounded,
            size: 28,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _button(
      {Color? backgroundColor,
      IconData? icon,
      String? text,
      Border? border,
      double? width,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: 30,
        // width: width ?? 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.red,
            borderRadius: BorderRadius.circular(30),
            border: border ?? Border.all(width: 0)),
        child: Row(children: [
          Icon(
            icon ?? Icons.play_circle_fill_outlined,
            size: 24,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            text ?? 'Play',
            style: mikado400,
          )
        ]),
      ),
    );
  }
}

class RowTitle extends StatelessWidget {
  const RowTitle({super.key, required this.title, required this.func});
  final String title;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            // controller.movies[0].name!,
            style: mikado500.copyWith(fontSize: 18),
          ),
          TextButton(
              onPressed: func,
              child: Text(
                'Xem tất cả',
                style: mikado400.copyWith(color: Colors.red),
              ))
        ],
      ),
    ));
  }
}

class RowMovies extends StatelessWidget {
  const RowMovies({super.key, required this.list});
  final List<MovieModel> list;
  // final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
          color: Colors.black,
          height: 310,
          margin: const EdgeInsets.only(left: 20),
          // padding: const EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (contex, index) {
                return InkWell(
                  onTap: () => Get.toNamed(Routes.detailMovie,
                      arguments: {'movie': list[index]}),
                  child: Container(
                      width: 220,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              // image: NetworkImage(list[index].poster!),
                              image: CachedNetworkImageProvider(
                                list[index].poster!,
                                errorListener: () => Image.asset(
                                  'assets/images/image_error.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              fit: BoxFit.cover)),
                      child: Align(
                        alignment: const Alignment(-0.8, -0.9),
                        child: Container(
                          // alignment: Alignment(1, -1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            list[index].rating.toString(),
                            style: mikado400.copyWith(color: Colors.white),
                          ),
                        ),
                      )),
                );
              })),
    );
  }
}
