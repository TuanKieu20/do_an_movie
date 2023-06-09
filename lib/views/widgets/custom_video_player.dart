import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../constants/color.dart';
import '../../constants/logger.dart';
import '../../constants/router.dart';
import '../../constants/styles.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/livestream_controller.dart';
import '../../controllers/reaction_controller.dart';
import '../../controllers/video_controller.dart';
import '../../models/movie_model.dart';
import '../helpers/helper.dart';
import '../screens/detail_movie_screen/detail_movie_screen.dart';
import 'custom_button.dart';
import 'custom_video_full_screen.dart';
import 'react_live.dart';

class CustomVideoPlayer extends StatefulWidget {
  CustomVideoPlayer({super.key});

  /// nedd movie and isTrailder
  final bool isLivve = Get.arguments['isLive'] ?? false;
  final MovieModel movie = Get.arguments['movie'];
  final bool isTrailer = Get.arguments['isTrailer'];

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with TickerProviderStateMixin, AnimationMixin {
  late VideoPlayerController _videoPlayerController;
  late TabController tabController;
  final controller1 = Get.put(VideoController());
  final liveStreamController = Get.find<LivestreamControlelr>();
  MovieModel get movie => widget.movie;
  bool get isLive => widget.isLivve;
  @override
  void initState() {
    super.initState();
    if (Get.find<HomeController>().isUserVip.value) {
      controller1.changeSelectedMenu(SampleItem.itemTwo);
    }
    liveStreamController.scrollController = ScrollController();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      FocusManager.instance.primaryFocus?.unfocus();
      liveStreamController.changeIndexTab(tabController.index);
    });
    Wakelock.enable();
    // assets/videos/Marvel Studios’ Eternals - Official Teaser.mp4
    _videoPlayerController = VideoPlayerController.network(
      (widget.movie.linkUrl == '' || widget.movie.linkUrl!.isEmpty)
          ? 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
          : widget.isTrailer
              ? movie.trailer!
              : widget.movie.linkUrl!,
      // : 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    )
      // _videoPlayerController =
      //     VideoPlayerController.asset('assets/videos/demo.mp4')
      ..addListener(_listener)
      ..initialize().then((_) {
        controller1.setVideoController(_videoPlayerController);
        if (widget.isLivve) {
          _videoPlayerController
              .seekTo(Duration(seconds: liveStreamController.getStartTime()));
        }
        _videoPlayerController.play();
        controller1.autoHideOverlay();
        setState(() {});
      }, onError: (e) {
        e as PlatformException;
        logger.e(e.code);
        logger.e(e);
      });
  }

  //    _videoPlayerController = VideoPlayerController.asset(
  //     'assets/videos/Marvel Studios’ Eternals - Official Teaser.mp4')

  _listener() async {
    controller1
      ..changePosition(_videoPlayerController.value.position)
      ..chagneDuration(_videoPlayerController.value.duration);
    if (_videoPlayerController.value.position.inSeconds >=
            _videoPlayerController.value.duration.inSeconds &&
        widget.isLivve) {
      liveStreamController.deleteComments(idMovie: movie.id ?? '');
      liveStreamController.changeEndLive(true);
      liveStreamController.updateStartTime(idMovie: movie.id ?? '');
      // liveStreamController.changeListEmpty(true);
      _buildDialogEndLive();
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    liveStreamController.changeEndLive(false);
    _videoPlayerController.dispose();
    Get.delete<VideoController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.black,
            body: SizedBox.expand(
              child: GetX<VideoController>(builder: (builder) {
                return Stack(
                  children: [
                    _videoPlayerController.value.isInitialized
                        ? controller1.isFullScreen()
                            ? VideoPlayerFullscreen(
                                videoPlayerController: _videoPlayerController,
                                movie: widget.movie,
                                isTrailer: widget.isTrailer,
                                isLive: isLive,
                              )
                            : Column(
                                // alignment: Alignment.bottomCenter,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: VideoPlayerFullscreen(
                                      videoPlayerController:
                                          _videoPlayerController,
                                      movie: widget.movie,
                                      isTrailer: widget.isTrailer,
                                      isLive: isLive,
                                    ),
                                  ),
                                  Expanded(
                                    child: isLive
                                        ? GetBuilder<LivestreamControlelr>(
                                            builder: (builder) {
                                            return DefaultTabController(
                                                length: 2,
                                                initialIndex:
                                                    liveStreamController
                                                        .indexTab.value,
                                                child: Column(
                                                  children: [
                                                    _buildTabBar(),
                                                    Expanded(
                                                        child: TabBarView(
                                                            controller:
                                                                tabController,
                                                            children: [
                                                          Builder(builder:
                                                              (context) {
                                                            return _tabComment();
                                                          }),
                                                          Builder(builder:
                                                              (context) {
                                                            return _builfInfoMovie();
                                                          })
                                                        ]))
                                                  ],
                                                ));
                                          })
                                        : _builfInfoMovie(),
                                  )
                                ],
                              )
                        : controller1.isFullScreen()
                            ? _buildOverlayInit()
                            : AspectRatio(
                                aspectRatio: 16 / 9,
                                child: _buildOverlayInit()),
                  ],
                );
              }),
            )),
      ),
    );
  }

  StreamBuilder<DatabaseEvent> _tabComment() {
    return StreamBuilder<DatabaseEvent>(
        stream: (FirebaseDatabase.instance
            .ref('movies/${movie.id}/comments')
            .onValue),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
          } else {
            final snapshotData = snapshot.data!.snapshot.value;
            if (snapshotData == null) {
              liveStreamController.changeListEmpty(true);
              // return CommentEmpty(
              //     liveStreamController: liveStreamController, movie: movie);
            }
            if (snapshotData != null) {
              liveStreamController.changeListEmpty(false);
            }
            final map = liveStreamController.isListCommentEmpty.value
                ? {}
                : snapshot.data!.snapshot.value as Map;
            var listComment = map.values.toList();
            listComment.sort(
              (a, b) {
                var time1 = DateTime.parse(a['time']);
                var time2 = DateTime.parse(b['time']);
                return time1.compareTo(time2);
              },
            );
            return GetBuilder<LivestreamControlelr>(builder: (builder) {
              return InkWell(
                onTap: (() => FocusScope.of(context).unfocus()),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Stack(
                        children: [
                          liveStreamController.isListCommentEmpty.value
                              ? SizedBox.expand(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Lottie.asset(
                                            'assets/jsons/Comment icon .json',
                                            width: 100,
                                            height: 100),
                                        Text(
                                            'Trò chuyện cùng mọi người bạn nhé 💗',
                                            style: mikado400.copyWith(
                                                color: Colors.black)),
                                        const SizedBox(height: 70),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  reverse: true,
                                  controller:
                                      liveStreamController.scrollController,
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 0),
                                  itemCount: listComment.length,
                                  itemBuilder: ((context, index) {
                                    final comment = listComment[
                                        listComment.length - 1 - index];
                                    return Helper.formatEmail(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .email ??
                                                    "")
                                                .toLowerCase() ==
                                            comment['id']
                                                .toString()
                                                .toLowerCase()
                                        ? _commentOfMine(comment, index == 0)
                                        : _commentGuest(comment, index == 0);
                                  })),
                          CommentContainer(
                              liveStreamController: liveStreamController,
                              movie: movie)
                        ],
                      ),
                    ),
                    // const ReactionAnimation()
                    StreamBuilder<DatabaseEvent>(
                        stream: (FirebaseDatabase.instance
                            .ref('movies/${movie.id}/reaction')
                            .onValue),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.snapshot.value != null) {
                              final snapshotData =
                                  snapshot.data!.snapshot.value;

                              var listReact =
                                  (snapshotData as Map).values.toList();
                              listReact.sort(
                                (a, b) {
                                  var time1 = DateTime.parse(a['time']);
                                  var time2 = DateTime.parse(b['time']);
                                  return time1.compareTo(time2);
                                },
                              );
                              int typeLike =
                                  int.parse(listReact.last['type'].toString());
                              if (typeLike == 0) {
                                typeLike = 1;
                              } else if (typeLike == 1) {
                                typeLike = 0;
                              }
                              // snapshot.data!.previousChildKey;
                              Get.put(ReactionController(
                                  animationController: controller));
                              Get.find<ReactionController>()
                                  .addAnimation(typeLike);
                            }
                          }
                          return const ReactionAnimation();
                        })
                  ],
                ),
              );
            });
          }
          return Container();
        });
  }

  Padding _commentGuest(comment, isCommentEnd) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0, bottom: isCommentEnd ? 120 : 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(comment['avatar']),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    Helper.capitalize(comment['name']),
                    style:
                        mikado500.copyWith(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Helper.getTime(
                      Duration(
                        seconds: Helper.calculateTimeDifferenceInSeconds(
                          liveStreamController.startTime(),
                          DateTime.parse(comment['time']),
                        ),
                      ),
                    ),
                    style: mikado400.copyWith(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Color(0xffEDEDED),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: Text(
                  Helper.validateRestrictedWord(comment['data']),
                  style: mikado400.copyWith(fontSize: 14, color: Colors.black),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Padding _commentOfMine(comment, isCommenntEnd) {
    return Padding(
      padding: EdgeInsets.only(top: 24, bottom: isCommenntEnd ? 120 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                Helper.getTime(
                  Duration(
                    seconds: Helper.calculateTimeDifferenceInSeconds(
                      liveStreamController.startTime(),
                      DateTime.parse(comment['time']),
                    ),
                  ),
                ),
                style: mikado400.copyWith(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            constraints: BoxConstraints(maxWidth: Get.width * 0.7),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Text(
              Helper.validateRestrictedWord(comment['data']),
              style: mikado400.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
        controller: tabController,
        labelStyle: mikado600.copyWith(fontSize: 17, color: Colors.red),
        labelColor: Colors.red,
        indicatorColor: Colors.red,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 5,
        onTap: ((value) {
          FocusScope.of(context).unfocus();
          liveStreamController.changeIndexTab(value);
        }),
        tabs: const [
          Tab(text: 'Bình luận'),
          Tab(text: 'Thông tin'),
        ]);
  }

  Future<dynamic> _buildDialogEndLive() {
    return showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            // elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 0.0,
            // backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 34),
            child: Container(
              constraints: const BoxConstraints(maxWidth: double.infinity),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 26),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0))
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                          'Livestream đã kết thúc. Vui lòng quay trở lại !!!',
                          textAlign: TextAlign.center,
                          style: mikado500.copyWith(
                              fontSize: 16, color: Colors.black))),
                  const SizedBox(height: 30),
                  CustomButton(
                      width: 110,
                      height: 40,
                      onTap: (() {
                        // logger.e('herhe');
                        _videoPlayerController.dispose();
                        if (controller1.isFullScreen.value) {
                          controller1.changeIsFullScreen(false);
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                          ]);
                        }
                        Get.back();
                        Get.until((route) =>
                            Get.currentRoute == Routes.bottomNavigator);
                      }),
                      color: Colors.white,
                      text: 'Quay lại',
                      backgroundColor: AppColors.blue3451F),
                ],
              ),
            ),
          );
        }));
  }

  Container _builfInfoMovie() {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            movie.name ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: mikado500.copyWith(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 20),
          _rowInfo(movie),
          const SizedBox(height: 20),
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
                  TextSpan(text: movie.author, style: mikado400),
                  TextSpan(
                      text: '\nTác giả',
                      style: mikado400.copyWith(color: Colors.grey))
                ]))
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Mô tả: \n${movie.description}',
                      maxLines: 1000000,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: mikado400,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
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
                  movie.rating.toString(),
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
                  movie.releaseYear.toString(),
                  style: mikado500.copyWith(color: Colors.white),
                ),
              ],
            )),
        Flexible(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (movie.isFullHD) const ButtonOutline(text: 'Full HD'),
              // const SizedBox(width: 10),
              if (movie.isSub) const ButtonOutline(text: 'Subtitle'),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOverlayInit() {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          const Center(child: CircularProgressIndicator()),
          Positioned(
              top: 20,
              left: 20,
              child: InkWell(
                onTap: () async {
                  await SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  _videoPlayerController.dispose();
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 24,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class CommentContainer extends StatelessWidget {
  const CommentContainer({
    Key? key,
    required this.liveStreamController,
    required this.movie,
  }) : super(key: key);

  final LivestreamControlelr liveStreamController;
  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 2, color: Colors.grey),
          ),
        ),
        width: double.infinity,
        height: 100,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: liveStreamController.commentController,
                focusNode: liveStreamController.node,
                onChanged: ((value) {
                  if (value.isEmpty) {
                    liveStreamController.changeCommentEmpty(false);
                  } else {
                    liveStreamController.changeCommentEmpty(true);
                  }
                }),
                decoration: InputDecoration(
                    fillColor: const Color(0xffEAEBEC),
                    filled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    hintText: 'Nhập nội dung ...'),
              ),
            ),
            const SizedBox(width: 10),
            liveStreamController.isFocusNode.value
                ? const SizedBox()
                : Container(
                    width: 3,
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 28),
                    color: Colors.grey,
                  ),
            const SizedBox(width: 5),
            liveStreamController.isFocusNode.value
                ? GetX<LivestreamControlelr>(builder: (_) {
                    return IconButton(
                        highlightColor: Colors.red,
                        onPressed: () {
                          if (liveStreamController.commentController.text
                              .trim()
                              .isNotEmpty) {
                            liveStreamController.addComment(
                                comment:
                                    liveStreamController.commentController.text,
                                idMovie: movie.id ?? '');
                            liveStreamController.changeListEmpty(false);
                            FocusScope.of(context).unfocus();
                            if (!liveStreamController
                                .isListCommentEmpty.value) {
                              // liveStreamController.scrollTo(comments.length < 4
                              //     ? comments.length * 50.0
                              //     : 0.0);
                            }
                          }
                        },
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                          Icons.send,
                          color: !liveStreamController.isCommentEmpty.value
                              ? Colors.grey
                              : Colors.blue,
                        ));
                  })
                : SizedBox(
                    width: 150,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: RowReactionIcon(
                          idMovie: movie.id ?? 'id',
                        )),
                  )
          ],
        ),
      ),
    );
  }
}

class CommentEmpty extends StatelessWidget {
  const CommentEmpty({
    Key? key,
    required this.liveStreamController,
    required this.movie,
  }) : super(key: key);

  final LivestreamControlelr liveStreamController;
  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text(
            'Chưa có bình luận nào !!!',
            style: mikado700.copyWith(fontSize: 24, color: Colors.white),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 2, color: Colors.grey),
              ),
            ),
            width: double.infinity,
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: liveStreamController.commentController,
                    focusNode: liveStreamController.node,
                    onChanged: ((value) {
                      if (value.isEmpty) {
                        liveStreamController.changeCommentEmpty(false);
                      } else {
                        liveStreamController.changeCommentEmpty(true);
                      }
                    }),
                    decoration: InputDecoration(
                        fillColor: const Color(0xffEAEBEC),
                        filled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Nhập nội dung ...'),
                  ),
                ),
                const SizedBox(width: 10),
                liveStreamController.isFocusNode.value
                    ? const SizedBox()
                    : Container(
                        width: 3,
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 28),
                        color: Colors.grey,
                      ),
                const SizedBox(width: 5),
                liveStreamController.isFocusNode.value
                    ? GetX<LivestreamControlelr>(builder: (_) {
                        return IconButton(
                            highlightColor: Colors.red,
                            onPressed: () {
                              if (liveStreamController.commentController.text
                                  .trim()
                                  .isNotEmpty) {
                                liveStreamController.addComment(
                                    comment: liveStreamController
                                        .commentController.text,
                                    idMovie: movie.id ?? '');
                              }
                            },
                            padding: const EdgeInsets.all(0),
                            icon: Icon(
                              Icons.send,
                              color: !liveStreamController.isCommentEmpty.value
                                  ? Colors.grey
                                  : Colors.blue,
                            ));
                      })
                    : SizedBox(
                        width: 150,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: RowReactionIcon(
                              idMovie: movie.id ?? 'id',
                            )),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  const CustomSliderThumbCircle({
    required this.thumbRadius,
    this.min = 0,
    this.max = 10,
  });
  final double thumbRadius;
  final int min;
  final int max;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    required double value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(255, 240, 143, 7),
          Color.fromARGB(255, 241, 7, 7),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset.fromDirection(0.0, 1.0),
        radius: 1.0,
      ));

    Paint paintBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas
      ..drawCircle(center, thumbRadius * .9, paint)
      ..drawCircle(center, thumbRadius * .9, paintBorder);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
