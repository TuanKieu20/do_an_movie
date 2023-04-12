import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../controllers/reaction_controller.dart';

class ReactionAnimation extends StatelessWidget {
  const ReactionAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReactionController>(builder: (controller) {
      return Stack(
        children: [
          for (int i = 0; i < controller.animArray.length; i++)
            Positioned(
                bottom: controller.startBottom[i].toDouble(),
                right: controller.startRight[i].toDouble(),
                child: controller.animArray[i]),
        ],
      );
    });
  }
}

class RowReactionIcon extends StatefulWidget {
  const RowReactionIcon({Key? key}) : super(key: key);

  @override
  _RowReactionIconState createState() => _RowReactionIconState();
}

class _RowReactionIconState extends State<RowReactionIcon> with AnimationMixin {
  // ignore: unused_field
  late ReactionController _controller;

  @override
  void initState() {
    _controller = Get.put(ReactionController(animationController: controller));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List ls = ['heart', 'like', 'happy', 'wow', 'cry'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < ls.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => socketSendLike(i),
              child: Image.asset(
                'assets/images/live/icon_${ls[i]}.png',
                scale: 3.2,
              ),
            ),
          ),
      ],
    );
  }

  void socketSendLike(int typeLike) {
    // final _profileController = Get.find<ProfileController>();
    // final _livestreamController = Get.find<LiveStreamController>();
    if (typeLike == 0) {
      typeLike = 1;
    } else if (typeLike == 1) {
      typeLike = 0;
    }
    _controller.addAnimation(int.parse(typeLike.toString()));
  }
}
