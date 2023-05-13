import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/router.dart';
import '../../../../constants/styles.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../controllers/profile_controller.dart';
import '../../../helpers/helper.dart';

class PremiumHeader extends StatelessWidget {
  const PremiumHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarEdit(
            width: 100,
            onTap: () {},
          ),
          Text(
            Helper.formatEmail(FirebaseAuth.instance.currentUser!.email ?? ""),
            // Get.find<HomeController>().userInforMore['name'],
            style: mikado500.copyWith(fontSize: 18),
          ),
          Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
            style: mikado400.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Get.find<HomeController>().isUserVip.value
              ? const SizedBox()
              : InkWell(
                  onTap: () {
                    Get.toNamed(Routes.subPremium);
                  },
                  child: Container(
                    width: double.infinity,
                    // height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: const Icon(
                            Icons.workspace_premium_outlined,
                            color: Colors.red,
                            // size: 32,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tham gia gói Premium!',
                              style: mikado500.copyWith(
                                  fontSize: 16, color: Colors.red),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Trải nghiệm xem phim Full-HD\nKhông có hạn chế nào, không quảng cáo',
                              style: mikado500.copyWith(
                                  fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class AvatarEdit extends StatelessWidget {
  const AvatarEdit({Key? key, required this.width, required this.onTap})
      : super(key: key);

  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      return InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            width <= 100
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(2100),
                    child: CachedNetworkImage(
                      imageUrl:
                          FirebaseAuth.instance.currentUser!.photoURL ?? '',
                      width: width,
                      height: width,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Text('error',
                          style: mikado400.copyWith(color: Colors.white)),
                      errorWidget: (context, url, error) => Text(
                        'error',
                        style: mikado400.copyWith(color: Colors.white),
                      ),
                    ),
                    // child: Image.network(
                    //   FirebaseAuth.instance.currentUser!.photoURL ?? '',
                    //   width: width,
                    //   height: width,
                    //   fit: BoxFit.cover,
                    // ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(2100),
                    child: (controller.imageFile == '')
                        ? Image.network(
                            FirebaseAuth.instance.currentUser!.photoURL ?? '',
                            width: width,
                            height: width,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(controller.imageFile),
                            width: width,
                            height: width,
                            fit: BoxFit.cover,
                          ),
                  ),
            width <= 100
                ? const SizedBox()
                : Positioned(
                    bottom: width <= 100 ? 0 : 5,
                    right: width <= 100 ? 0 : 5,
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.edit,
                        size: 26,
                      ),
                    ),
                  )
          ],
        ),
      );
    });
  }
}
