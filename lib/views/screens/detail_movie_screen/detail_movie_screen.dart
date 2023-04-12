import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/movie_model.dart';
import '../../helpers/helper.dart';
import '../../widgets/button_outline.dart';
import 'widgets/header.dart';
import 'widgets/show_more_des.dart';
import 'widgets/tab_view_comment.dart';
import 'widgets/tab_view_trailer.dart';
import 'widgets/tabview_more.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({super.key});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  List<MovieModel> movieByCate = [];
  final controller = Get.find<HomeController>();
  final movie = Get.arguments;

  @override
  void initState() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      controller.changeIndex(tabController.index);
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   movieByCate =
    //       controller.filterByCategory(category: movie['movie'].category);
    //   await Future.delayed(Duration(seconds: 1));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    movieByCate =
        controller.filterByCategory(category: movie['movie'].category);
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            // FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      movie: movie['movie'],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie['movie'].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: mikado600.copyWith(
                                    color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(height: 20),
                              _rowInfo(movie),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.only(right: 20),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ButtonContainer(
                                        onpress: () async {
                                          await SystemChrome
                                              .setEnabledSystemUIMode(
                                                  SystemUiMode.immersiveSticky);
                                          await SystemChrome
                                              .setPreferredOrientations(
                                            [
                                              DeviceOrientation.landscapeLeft,
                                              DeviceOrientation.landscapeRight,
                                            ],
                                          );
                                          Get.toNamed(Routes.customVideo,
                                              arguments: {
                                                'movie': movie['movie'],
                                                'isTrailer': false
                                              });
                                        },
                                        icon: Icons.play_circle,
                                        text: 'Play',
                                        backgroundColor: Colors.red,
                                        isBorder: false,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: ButtonContainer(
                                        onpress: () =>
                                            Helper.showDialogFuntionLoss(),
                                        icon:
                                            Icons.download_for_offline_rounded,
                                        text: 'Download',
                                        backgroundColor: Colors.black,
                                        isBorder: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Thể loại: ${movie['movie'].category}',
                                style: mikado400,
                              ),
                              const SizedBox(height: 10),
                              TextDescription(movie: movie),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 25,
                                      child: FlutterLogo(
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: movie['movie'].author,
                                          style: mikado400),
                                      TextSpan(
                                          text: '\nDirector',
                                          style: mikado400.copyWith(
                                              color: Colors.grey))
                                    ]))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: controller.index() == 0
                                  ? 330
                                  : controller.index() == 1
                                      ? Get.height - 300
                                      : controller.index() * 250 + 30),
                          child: DefaultTabController(
                              length: 3,
                              initialIndex: controller.index.value,
                              child: Column(
                                children: [
                                  TabBar(
                                    controller: tabController,
                                    labelStyle: mikado600.copyWith(
                                        fontSize: 17, color: Colors.red),
                                    labelColor: Colors.red,
                                    indicatorColor: Colors.red,
                                    unselectedLabelColor: Colors.grey,
                                    indicatorWeight: 5,
                                    onTap: (value) {
                                      controller.changeIndex(value);

                                      if (controller.index() == 2) {
                                        // controller.scrollTo(0.0);
                                        controller.scrollTo(controller
                                            .scrollController
                                            .position
                                            .maxScrollExtent);
                                      } else {
                                        controller.scrollTo(250.0);
                                      }
                                    },
                                    tabs: const [
                                      Tab(text: 'Trailers'),
                                      Tab(text: 'More Like This'),
                                      Tab(text: 'Comments')
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: TabBarView(
                                        controller: tabController,
                                        children: [
                                          TabTrailer(movie: movie),
                                          TabViewMoreLikeThis(
                                              movieCate: movieByCate),
                                          StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('movies')
                                                  .doc(movie['movie'].id)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container();
                                                }
                                                return TabViewComment(
                                                    movie: MovieModel.fromJson(
                                                        snapshot.data!.data()
                                                            as Map<String,
                                                                dynamic>,
                                                        idDoc:
                                                            movie['movie'].id));
                                              }),
                                        ]),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              controller.isShowMore.value
                  ? ShowMoreDesc(movie: movie)
                  : const SizedBox()
            ],
          ),
        ),
      );
    });
  }

  Row _rowInfo(movie) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.star_half_rounded,
                  color: Colors.red,
                  size: 28,
                ),
                // const SizedBox(width: 10),
                Text(
                  movie['movie'].rating.toString(),
                  style: mikado400.copyWith(color: Colors.red),
                ),
                // const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.red,
                  size: 22,
                ),
                // const SizedBox(width: 10),
                Text(
                  movie['movie'].releaseYear.toString(),
                  style: mikado500.copyWith(color: Colors.white),
                ),
              ],
            )),
        Flexible(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (movie['movie'].isFullHD) const ButtonOutline(text: 'Full HD'),
              // const SizedBox(width: 10),
              if (movie['movie'].isSub) const ButtonOutline(text: 'Subtitle'),
            ],
          ),
        )
      ],
    );
  }
}

class TextDescription extends StatelessWidget {
  const TextDescription({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final dynamic movie;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Stack(
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(
                text: movie['movie'].description.length > 145
                    ? 'Mô tả: ${movie['movie'].description.substring(0, 141)}...'
                    : 'Mô tả: ${movie['movie'].description}',
                style: mikado400),
            TextSpan(
                text:
                    movie['movie'].description.length > 145 ? ' Xem thêm' : '',
                style: mikado400.copyWith(color: Colors.red),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    controller.changeShowMore(!controller.isShowMore());
                  })
          ])),
        ],
      );
    });
  }
}

class ButtonOutline extends StatelessWidget {
  const ButtonOutline({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.red),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        text,
        style: mikado400.copyWith(color: Colors.red),
      ),
    );
  }
}
