import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/color.dart';
import '../../../constants/custom_alter.dart';
import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/register_controller.dart';
import '../../widgets/custom_button.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<RegisterController>();
    final controller = Get.put(RegisterController());

    return Scaffold(
      body: GetBuilder<RegisterController>(builder: (builder) {
        return InkWell(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              const Background(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 46,
                              height: 46,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Register To \nExperience of us',
                            style: mikado600.copyWith(
                              fontSize: 32,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.1,
                          ),
                        ],
                      ),
                      GetBuilder<RegisterController>(builder: (builder) {
                        return Form(
                          key: controller.keyRegister,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: ((builder) {
                                            return Container(
                                                height: Get.height * 0.2,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    // const SizedBox(
                                                    //     height: 30),
                                                    RowChooseOption(
                                                      text: 'Thư viện ảnh',
                                                      icon: Icons.photo,
                                                      onTap: () {
                                                        controller
                                                            .getImage(context);
                                                        Get.back();
                                                      },
                                                    ),
                                                    RowChooseOption(
                                                      text: 'Chụp ảnh',
                                                      icon: Icons.camera_alt,
                                                      onTap: () {
                                                        controller.getImage(
                                                            context,
                                                            isCamera: true);
                                                      },
                                                    )
                                                  ],
                                                ));
                                          }));
                                    },
                                    child: GetBuilder<RegisterController>(
                                        builder: (builder) {
                                      return Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.blue3451F,
                                              width: 3),
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                          image: controller.imageFile == ''
                                              ? const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/personal.png'))
                                              : DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(File(
                                                      controller.imageFile))),
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(3, 5),
                                                color: Colors.black,
                                                blurRadius: 6.0,
                                                spreadRadius: 4.0)
                                          ],
                                        ),
                                      );
                                    }),
                                  ),

                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(
                                  //     Icons.flip_camera_ios,
                                  //     size: 36,
                                  //     color: AppColors.blue3451F,
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 60),
                              SizedBox(
                                // decoration: BoxDecoration(
                                //     color: Colors.white10,
                                //     borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 4.0,
                                        sigmaY: 4.0,
                                        tileMode: TileMode.decal),
                                    child: TextFormField(
                                      controller: controller.nameController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      // focusNode: controller.focusNodes[0],
                                      onChanged: ((value) {
                                        if (value.isEmpty) {}
                                      }),
                                      validator: ((value) {
                                        return controller
                                                .nameController.text.isEmpty
                                            ? 'Tên không được để trống !'
                                            : controller.nameController.text
                                                        .length <
                                                    6
                                                ? 'Tên quá ngắn !'
                                                : null;
                                      }),
                                      cursorColor: Colors.blue,
                                      style: mikado400,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 15),
                                          fillColor: Colors.white10,
                                          filled: true,
                                          hintText: 'Enter your name...',
                                          hintStyle: mikado400.copyWith(
                                              color: AppColors.grayC9C9)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 60),
                              CustomButton(
                                color: Colors.white,
                                text: 'Register',
                                backgroundColor: AppColors.blue3451F,
                                onTap: () async {
                                  if (controller.keyRegister.currentState!
                                      .validate()) {
                                    if (controller.imageFile != '') {
                                      final pref =
                                          Get.find<SharedPreferences>();
                                      if (pref.getBool('checkUpdateInf') ==
                                          true) {
                                        pref.setBool('checkUpdateInf', false);
                                      }
                                      var email =
                                          '${controller.nameController.text}@gmail.com';
                                      if (controller.keyRegister.currentState!
                                          .validate()) {
                                        var res = await controller
                                            .createEmailAndPassword(
                                                email: email);
                                        if (res.isSuccess) {
                                          Get.find<HomeController>()
                                              .getInforUser();
                                          Get.toNamed(Routes.suggestTopic);
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CustomAlert(
                                                    labelText: res.message,
                                                    onPressed: () =>
                                                        Get.back());
                                              });
                                        }
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlert(
                                                labelText:
                                                    'Vui lòng chọn ảnh đại diện',
                                                onPressed: () => Get.back());
                                          });
                                    }
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                color: Colors.black,
                                text: 'Back To Login',
                                backgroundColor: Colors.white,
                                onTap: () async {
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              // controller.checkShowDialog()
              //     ? Container(
              //         width: double.infinity,
              //         height: double.infinity,
              //         color: Colors.black.withOpacity(.7),
              //         // child: CustomAlert(
              //         //     labelText: 'Đăng ký thành công !',
              //         //     onPressed: () {},
              //         //     buttonText: controller.time().toString()),
              //         child: Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             Container(
              //               width: double.infinity,
              //               height: double.infinity,
              //               color: Colors.transparent,
              //             ),
              //             Container(
              //               height: 200,
              //               constraints: const BoxConstraints(maxWidth: 400),
              //               padding: const EdgeInsets.symmetric(
              //                   vertical: 30, horizontal: 20),
              //               decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 shape: BoxShape.rectangle,
              //                 borderRadius: BorderRadius.circular(20),
              //                 boxShadow: const [
              //                   BoxShadow(
              //                     color: Colors.black26,
              //                     blurRadius: 10.0,
              //                     offset: Offset(0.0, 10.0),
              //                   ),
              //                 ],
              //               ),
              //               child: Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Text(
              //                     'Đăng ký thành công !',
              //                     textAlign: TextAlign.center,
              //                     style: mikado500.copyWith(
              //                         fontSize: 18,
              //                         height: 1.5,
              //                         color: Colors.black),
              //                   ),
              //                   const SizedBox(height: 10),
              //                   const SizedBox(height: 20),
              //                   GetBuilder<RegisterController>(
              //                       builder: (builder) {
              //                     logger.d(builder.time());
              //                     return Text(builder.time().toString());
              //                     // return CustomButton(
              //                     //     onTap: () {
              //                     //       // onPressed();
              //                     //     },
              //                     //     color: Colors.white,
              //                     //     text: controller.time().toString(),
              //                     //     backgroundColor: AppColors.blue3451F);
              //                   })
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : const SizedBox()
            ],
          ),
        );
      }),
    );
  }
}

class RowChooseOption extends StatelessWidget {
  const RowChooseOption({
    Key? key,
    required this.onTap,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 40),
          Icon(
            icon,
            color: AppColors.blue3451F,
            size: 36,
          ),
          const SizedBox(width: 40),
          Text(
            text,
            style: mikado500.copyWith(
              fontSize: 20,
              color: AppColors.blue3451F,
            ),
          ),
        ],
      ),
    );
  }
}
