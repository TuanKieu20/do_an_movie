import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/color.dart';
import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/on_boarding_controller.dart';
import '../../widgets/custom_button.dart';

class AllOnboarding extends StatefulWidget {
  const AllOnboarding({super.key});

  @override
  State<AllOnboarding> createState() => _AllOnboardingState();
}

class _AllOnboardingState extends State<AllOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OnboardingController>(builder: (controller) {
        return Stack(
          // alignment: Alignment.c,
          children: [
            PageView(
              controller: controller.controller,
              onPageChanged: ((value) async {
                if (value == 2) {
                  await Permission.camera.request();
                }
                controller.changeIndexPage(value);
              }),
              children: const [
                Body(
                  image: 'assets/images/on_boarding_1.jpeg',
                  text: 'Unlimited\nmovies, TV\nshow & more',
                  subText: 'Watch anywhere. Cancel\nanytime.',
                ),
                Body(
                  image: 'assets/images/on_boarding_2.webp',
                  text: 'Download and\nwatch offline',
                  subText: 'Always have something to\nwatch offline',
                ),
                Body(
                  image: 'assets/images/on_boarding_3.jpeg',
                  text: 'No pesky\ncontracts',
                  subText: 'Join today, cancel anytime',
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: context.mediaQueryViewPadding.top),
                Align(
                  alignment: const Alignment(-0.8, 0.7),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => GetBuilder<OnboardingController>(
                              builder: (builder) {
                            return Container(
                              width: 16,
                              height: 16,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: index == builder.index()
                                      ? Colors.white
                                      : Colors.blueGrey),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (controller.index.value == 2)
                        CustomButton(
                          onTap: () {
                            Get.offAllNamed(Routes.login);
                            Get.delete<OnboardingController>();
                          },
                          width: Get.width * 0.8,
                          color: Colors.white,
                          text: 'Get started'.toUpperCase(),
                          backgroundColor: Colors.red,
                          fontWeight: FontWeight.w400,
                        )
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      }),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.image,
    required this.text,
    required this.subText,
  }) : super(key: key);

  final String image;
  final String text;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            // color: Colors.black.withOpacity(0.4),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.8)
                // Colors.red
              ],
              begin: const Alignment(1, 0.5),
              end: const Alignment(1, -1),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: context.mediaQueryViewPadding.top),
            // Align(
            //   alignment: const Alignment(-0.8, 0.7),
            //   child: Image.asset(
            //     'assets/images/logo.png',
            //     width: 60,
            //     height: 60,
            //   ),
            // ),
            const Spacer(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: mikado500.copyWith(fontSize: 30, letterSpacing: 1.3),
            ),
            const SizedBox(height: 20),
            Text(
              subText,
              textAlign: TextAlign.center,
              style: mikado400.copyWith(
                  fontSize: 18, letterSpacing: 1.2, color: AppColors.grayC9C9),
            ),
            const SizedBox(height: 60),
            const SizedBox(
              height: 200,
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: List.generate(
              //         3,
              //         (index) =>
              //             GetBuilder<OnboardingController>(builder: (builder) {
              //           return Container(
              //             width: 18,
              //             height: 18,
              //             margin: const EdgeInsets.only(right: 10),
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: index == builder.index()
              //                     ? Colors.white
              //                     : Colors.blueGrey),
              //           );
              //         }),
              //       ),
              //     ),
              //     const SizedBox(height: 20),
              //     CustomButton(
              //       onTap: () {
              //         Get.offAllNamed(Routes.login);
              //         Get.delete<OnboardingController>();
              //       },
              //       color: Colors.white,
              //       text: 'Get started'.toUpperCase(),
              //       backgroundColor: Colors.red,
              //       fontWeight: FontWeight.w400,
              //     )
              //   ],
              // ),
            )
          ],
        )
      ],
    );
  }
}
