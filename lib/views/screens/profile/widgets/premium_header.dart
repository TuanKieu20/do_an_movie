import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../../constants/styles.dart';
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
            style: mikado500.copyWith(fontSize: 18),
          ),
          Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
            style: mikado400.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            // height: 60,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Transform.scale(
                  scale: 2.2,
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
                      style:
                          mikado500.copyWith(fontSize: 18, color: Colors.red),
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
                    child: Image.network(
                      FirebaseAuth.instance.currentUser!.photoURL ?? '',
                      width: width,
                      height: width,
                      fit: BoxFit.cover,
                    ),
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
            Positioned(
              bottom: width <= 100 ? 0 : 5,
              right: width <= 100 ? 0 : 5,
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
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