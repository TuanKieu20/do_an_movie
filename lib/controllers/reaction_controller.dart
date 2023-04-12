import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, x, y, opacity }

class ReactionController extends GetxController {
  ReactionController({required this.animationController});
  final AnimationController animationController;
  final _random = Random();
  List<Widget> animArray = <Widget>[];
  List<int> startRight = <int>[];
  List<int> startBottom = <int>[];

  void addAnimation(int typeLike) {
    animArray.add(anim(typeLike, animationController));
    startRight.add((_random.nextInt(9) + 1) * 10);
    startBottom.add((_random.nextInt(4) + 1) * 10 + 100);
    update();
  }

  Widget anim(typelike, controller) {
    List<double> randomStart = [
      0,
      ...List.filled(3, _random.nextDouble() * 200)
    ];
    List<double> randomEnd = [
      0,
      ...List.filled(5, 0 - _random.nextDouble() * 100)
    ];

    final _tween = TimelineTween<AniProps>()
      ..addScene(
        begin: const Duration(seconds: 0),
        duration: const Duration(seconds: 8),
      )
          .animate(
            AniProps.y,
            tween: Tween(begin: 0.0, end: Get.height * 0.4),
            curve: Curves.fastOutSlowIn,
          )
          .animate(
            AniProps.opacity,
            tween: Tween(begin: 1.0, end: 0.0),
            curve: Curves.fastOutSlowIn,
          )
          .animate(
            AniProps.width,
            tween: Tween(begin: 40.0, end: 0.0),
            curve: Curves.bounceInOut,
          );
    for (int i = 0; i < 4; i++) {
      for (int j = 3; j < 6; j++) {
        _tween
            .addScene(
              begin: const Duration(seconds: 0),
              duration: const Duration(seconds: 5),
            )
            .animate(
              AniProps.x,
              tween: Tween(
                begin: randomStart[i],
                end: randomEnd[j],
              ),
              curve: Curves.bounceInOut,
            )
            .animate(
              AniProps.x,
              tween: Tween(
                begin: randomEnd[j],
                end: randomStart[i],
              ),
              curve: Curves.bounceInOut,
            );
      }
    }
    _tween.animate(controller);

    return Center(
      child: PlayAnimation<TimelineValue<AniProps>>(
        tween: _tween,
        duration: _tween.duration,
        builder: (context, child, value) {
          return Transform.translate(
            offset: Offset(value.get(AniProps.x), -value.get(AniProps.y)),
            child: Opacity(
              opacity: value.get(AniProps.opacity),
              child: SizedBox(
                width: value.get(AniProps.width),
                height: 30,
                child: typelike == 0
                    ? Image.asset('assets/images/live/icon_like.png')
                    : typelike == 1
                        ? Image.asset('assets/images/live/icon_heart.png')
                        : typelike == 2
                            ? Image.asset('assets/images/live/icon_happy.png')
                            : typelike == 3
                                ? Image.asset('assets/images/live/icon_wow.png')
                                : Image.asset(
                                    'assets/images/live/icon_cry.png'),
              ),
            ),
          );
        },
      ),
    );
  }
}
