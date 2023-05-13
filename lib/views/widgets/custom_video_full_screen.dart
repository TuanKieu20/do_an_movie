import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../constants/router.dart';
import '../../constants/styles.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/livestream_controller.dart';
import '../../controllers/reaction_controller.dart';
import '../../controllers/video_controller.dart';
import '../../models/movie_model.dart';
import '../helpers/helper.dart';
import 'custom_video_player.dart';

class VideoPlayerFullscreen extends StatefulWidget {
  const VideoPlayerFullscreen(
      {Key? key,
      required VideoPlayerController videoPlayerController,
      required this.movie,
      required this.isTrailer,
      required this.isLive})
      : _videoPlayerController = videoPlayerController,
        super(key: key);

  final VideoPlayerController _videoPlayerController;
  final MovieModel movie;
  final bool isTrailer;
  final bool isLive;

  @override
  State<VideoPlayerFullscreen> createState() => _VideoPlayerFullscreenState();
}

class _VideoPlayerFullscreenState extends State<VideoPlayerFullscreen>
    with TickerProviderStateMixin {
  final controller = Get.find<VideoController>();
  late AnimationController _animationController;
  VideoPlayerController get videoPlayer => widget._videoPlayerController;
  bool get isLive => widget.isLive;
  final liveController = Get.find<LivestreamControlelr>();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    homeController.getInforUser();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        // if (videoPlayer.value.isPlaying) {
        //   videoPlayer.pause();
        //   _animationController.forward();
        // } else {
        //   videoPlayer.play();
        //   _animationController.reverse();
        // }
        // setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Get.find<HomeController>().isUserVip.value
        InkWell(
          onTap: () {
            controller.changeShowOverlay(true);
          },
          child: VideoPlayer(videoPlayer),
        ),

        /// TODO: chang full hd or 480 quatily with customer vip
        !Get.find<HomeController>().isUserVip.value
            ? InkWell(
                onTap: () {
                  controller.changeShowOverlay(true);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                      child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                    child: Container(
                      color: Colors.black12,
                    ),
                  )),
                ),
              )
            : const SizedBox(),
        _buildOverlay()
      ],
    );
  }

  Widget _buildOverlay() {
    return GetX<VideoController>(builder: (builder) {
      return InkWell(
        onTap: () {
          controller.changeShowOverlay(false);
        },
        child: Visibility(
          visible: controller.isShowOverlay(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
            child: Column(
              children: [
                _buildTopOverlay(),
                const Spacer(),
                _buildSlider(),
                SizedBox(height: controller.isFullScreen() ? 20 : 10),
                if (!widget.isLive)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLeftIcon(),
                      _buildMiddleIcon(),
                      _buildRightIcon()
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }

  Row _buildRightIcon() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.file_download_rounded,
            size: controller.isFullScreen() ? 32 : 24,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () async {
            if (controller.isFullScreen()) {
              await SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              controller.changeIsFullScreen(false);
            } else {
              await SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.immersiveSticky);
              await SystemChrome.setPreferredOrientations(
                [
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ],
              );
              controller.changeIsFullScreen(true);
            }
          },
          icon: Icon(
            controller.isFullScreen() ? Icons.zoom_in_map : Icons.zoom_out_map,
            size: controller.isFullScreen() ? 28 : 24,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Row _buildMiddleIcon() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              controller.changeShowOverlay(true);
              controller.changeIsPlaying(false);
              videoPlayer.pause();
              int check = controller.position().inSeconds - 10;
              Duration newPosition = Duration(seconds: check > 0 ? check : 0);
              videoPlayer
                ..seekTo(newPosition)
                ..play();
              controller.changeIsPlaying(true);
            },
            icon: Icon(
              Icons.replay_10_rounded,
              color: Colors.white,
              size: controller.isFullScreen() ? 32 : 24,
            )),
        InkWell(
            onTap: () {
              if (videoPlayer.value.isPlaying) {
                controller.changeIsPlaying(false);
                videoPlayer.pause();
              } else {
                controller.changeIsPlaying(true);
                videoPlayer.play();
              }
            },
            child: Icon(
              controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
              size: controller.isFullScreen() ? 50 : 38,
              color: Colors.white,
            )),
        IconButton(
            onPressed: () {
              controller.changeShowOverlay(true);
              controller.changeIsPlaying(false);
              videoPlayer.pause();

              int check = controller.position().inSeconds + 10;
              Duration newPosition = Duration(seconds: check);
              videoPlayer
                ..seekTo(newPosition)
                ..play();
              controller.changeIsPlaying(true);
            },
            icon: Icon(
              Icons.forward_10_rounded,
              color: Colors.white,
              size: controller.isFullScreen() ? 32 : 24,
            )),
      ],
    );
  }

  Row _buildLeftIcon() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Helper.showDialogFuntionLoss();
          },
          icon: Icon(
            Icons.lock_open_rounded,
            color: Colors.white,
            size: controller.isFullScreen() ? 32 : 24,
          ),
        ),
        IconButton(
            onPressed: () {
              controller.changeShowOverlay(true);
              if (controller.mute()) {
                controller.changeMute(false);
                videoPlayer.setVolume(0.0);
              } else {
                controller.changeMute(true);
                videoPlayer.setVolume(1.0);
              }
            },
            icon: Icon(
              !controller.mute()
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
              color: Colors.white,
              size: controller.isFullScreen() ? 32 : 24,
            ))
      ],
    );
  }

  GetX<VideoController> _buildSlider() {
    return GetX<VideoController>(builder: (builder) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isLive)
            SizedBox(
              width: 70,
              child: Text(
                Helper.getTime(controller.position.value),
                style: mikado500,
              ),
            ),
          Expanded(
            child: SliderTheme(
                data: SliderThemeData(
                  trackShape: const RectangularSliderTrackShape(),
                  activeTrackColor: Colors.red,
                  inactiveTrackColor: Colors.grey,
                  trackHeight: 5.0,
                  overlayShape: SliderComponentShape.noOverlay,
                  thumbShape: CustomSliderThumbCircle(
                      thumbRadius: widget.isLive ? 3 : 8),
                ),
                child: GetX<VideoController>(builder: (builder) {
                  return Slider(
                      min: 0,
                      max: controller.duration.value.inMilliseconds.toDouble(),
                      divisions: 999999,
                      value: widget.isLive
                          ? controller.duration.value.inMilliseconds.toDouble()
                          : (controller.position.value.inMilliseconds
                                          .toDouble() <
                                      0.0 ||
                                  controller.position.value.inMilliseconds >
                                      controller.duration.value.inMilliseconds)
                              ? 0
                              : controller.position.value.inMilliseconds
                                  .toDouble(),
                      onChanged: ((value) {
                        if (!isLive) {
                          Duration newPosition =
                              Duration(milliseconds: value.toInt());
                          widget._videoPlayerController.seekTo(newPosition);
                        }
                      }));
                })),
          ),
          if (widget.isLive) const SizedBox(width: 10),
          isLive
              ? IconButton(
                  onPressed: () {
                    if (controller.isFullScreen()) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
                      controller.changeIsFullScreen(false);
                    } else {
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersiveSticky);
                      SystemChrome.setPreferredOrientations(
                        [
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight,
                        ],
                      );
                      controller.changeIsFullScreen(true);
                    }
                  },
                  icon: Icon(
                    controller.isFullScreen()
                        ? Icons.zoom_in_map
                        : Icons.zoom_out_map,
                    size: controller.isFullScreen() ? 28 : 24,
                    color: Colors.white,
                  ),
                )
              : SizedBox(
                  width: 70,
                  child: Text(
                    Helper.getTime(controller.duration.value),
                    style: mikado500,
                  ),
                ),
        ],
      );
    });
  }

  Row _buildTopOverlay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (!controller.isFullScreen())
              IconButton(
                padding: const EdgeInsets.all(0),
                splashColor: Colors.red,
                onPressed: () async {
                  Get.find<LivestreamControlelr>()
                      .removeViewer(idMovie: widget.movie.id ?? "");
                  await SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  Get.delete<ReactionController>();
                  // widget._videoPlayerController.dispose();
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            SizedBox(width: isLive ? 0 : 10),
            isLive
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Text(
                      'Trực tiếp'.toUpperCase(),
                      style: mikado500.copyWith(),
                    ),
                  )
                : SizedBox(
                    width: 200,
                    child: Text(
                      widget.isTrailer
                          ? 'Trailer: ${widget.movie.name!}'
                          : widget.movie.name!,
                      style: mikado400.copyWith(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            if (isLive)
              StreamBuilder<DatabaseEvent>(
                  stream: FirebaseDatabase.instance
                      .ref('movies/${widget.movie.id}/users')
                      .onValue,
                  builder: (context, snapshot) {
                    // logger.e(snapshot.data!.snapshot.value);
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            // '3',
                            snapshot.data!.snapshot.value == null
                                ? '0'
                                : (snapshot.data!.snapshot.value as Map)
                                    .keys
                                    .toList()
                                    .length
                                    .toString(),
                            style: mikado500.copyWith(color: Colors.white),
                          )
                        ],
                      ),
                    );
                  })
          ],
        ),
        const Spacer(),
        controller.isFullScreen()
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildButtonTop(Icons.speed_rounded),
                  _buildButtonTop(Icons.timer_outlined),
                  _buildButtonTop(Icons.keyboard_alt_outlined),
                  _buildButtonTop(Icons.mic_none_rounded),
                  // _buildButtonTop(Icons.more_vert_rounded),
                  // PopUpMenu(pressed: (SampleItem item) {
                  //     setState(() {
                  //       selectedMenu = item;
                  //     });
                  //   }, value: selectedMenu)
                  PopupMenuButton<SampleItem>(
                    initialValue: controller.selectedMenu,
                    // Callback that sets the selected popup menu item.
                    onSelected: (SampleItem item) {
                      if (!homeController.isUserVip.value &&
                          item == SampleItem.itemTwo) {
                        Get.offAndToNamed(Routes.subPremium);
                        Helper.showDialogFuntionLoss(
                            text:
                                'Đăngg kí để có trải nghiêkm tốt nhất cùng chúng tớ bạn nhé !');
                      }
                      controller.changeSelectedMenu(item);
                    },
                    child: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<SampleItem>>[
                      PopupMenuItem<SampleItem>(
                        value: SampleItem.itemOne,
                        child: Row(
                          children: [
                            controller.selectedMenu == SampleItem.itemOne
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.red,
                                  )
                                : const SizedBox(),
                            const SizedBox(width: 30),
                            Text(
                              '480P',
                              style: mikado400.copyWith(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem<SampleItem>(
                        value: SampleItem.itemTwo,
                        child: Row(
                          children: [
                            controller.selectedMenu == SampleItem.itemTwo
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.red,
                                  )
                                : const SizedBox(),
                            const SizedBox(width: 30),
                            Text(
                              'Full HD',
                              style: mikado400.copyWith(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      // const PopupMenuItem<SampleItem>(
                      //   value: SampleItem.itemThree,
                      //   child: Text('Item 3'),
                      // ),
                    ],
                  ),
                  // s
                ],
              )
            : PopupMenuButton<SampleItem>(
                initialValue: controller.selectedMenu,
                // Callback that sets the selected popup menu item.
                onSelected: (SampleItem item) {
                  if (!homeController.isUserVip.value &&
                      item == SampleItem.itemTwo) {
                    Get.offAndToNamed(Routes.subPremium);
                    Helper.showDialogFuntionLoss(
                        text:
                            'Đăngg kí để có trải nghiêkm tốt nhất cùng chúng tớ bạn nhé !');
                  }
                  controller.changeSelectedMenu(item);
                },
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem>>[
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    child: Row(
                      children: [
                        controller.selectedMenu == SampleItem.itemOne
                            ? const Icon(
                                Icons.check,
                                color: Colors.red,
                              )
                            : const SizedBox(),
                        const SizedBox(width: 30),
                        Text(
                          '480P',
                          style: mikado400.copyWith(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.itemTwo,
                    child: Row(
                      children: [
                        controller.selectedMenu == SampleItem.itemTwo
                            ? const Icon(
                                Icons.check,
                                color: Colors.red,
                              )
                            : const SizedBox(),
                        const SizedBox(width: 30),
                        Text(
                          'Full HD',
                          style: mikado400.copyWith(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  // const PopupMenuItem<SampleItem>(
                  //   value: SampleItem.itemThree,
                  //   child: Text('Item 3'),
                  // ),
                ],
              ),
      ],
    );
  }

  IconButton _buildButtonTop(IconData icon) {
    return IconButton(
      onPressed: () {
        Helper.showDialogFuntionLoss();
      },
      icon: Icon(
        icon,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({super.key, required this.pressed, required this.value});
  final dynamic value;
  final Function pressed;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SampleItem>(
      initialValue: value,
      // Callback that sets the selected popup menu item.
      onSelected: pressed(),
      child: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Text('Item 1'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          child: Text('Item 2'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          child: Text('Item 3'),
        ),
      ],
    );
  }
}
