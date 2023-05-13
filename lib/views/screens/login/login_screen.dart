import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/color.dart';
import '../../../constants/custom_alter.dart';
import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../helpers/helper.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final controller = Get.put(LoginController());
  final controller = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const Background(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
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
                            'Enjoy your \nFree time with us',
                            style: mikado600.copyWith(
                              fontSize: 32,
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: GetBuilder<LoginController>(builder: (builder) {
                        return Form(
                          key: controller.keyLogin,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your name',
                                style: mikado500.copyWith(
                                    fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 5),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 4.0, sigmaY: 4.0),
                                  child: TextFormField(
                                    controller: controller.emailController,
                                    focusNode: controller.focusNodes[0],
                                    cursorColor: Colors.blue,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ((value) {
                                      return value!.isEmpty
                                          ? 'Tên không được để trống'
                                          : null;
                                    }),
                                    style: mikado400,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        fillColor: Colors.white10,
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                        hintText: 'Enter your name...',
                                        hintStyle: mikado400.copyWith(
                                            color: AppColors.grayC9C9)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Password
                              // ClipRect(
                              //   child: BackdropFilter(
                              //     filter: ImageFilter.blur(
                              //         sigmaX: 4.0, sigmaY: 4.0),
                              //     child: Container(
                              //       width: double.infinity,
                              //       height: 55,
                              //       decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(16),
                              //           color: Colors.white.withOpacity(0.3)),
                              //       child: Padding(
                              //         padding: const EdgeInsets.only(
                              //             top: 15,
                              //             bottom: 15,
                              //             left: 20,
                              //             right: 20),
                              //         child: TextField(
                              //           controller:
                              //               controller.passwordController,
                              //           focusNode: controller.focusNodes[1],
                              //           cursorColor: Colors.blue,
                              //           style: mikado400,
                              //           decoration: InputDecoration.collapsed(
                              //               hintText: 'Password',
                              //               hintStyle: mikado400.copyWith(
                              //                   color: AppColors.grayC9C9)),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Align(
                              //   alignment: Alignment.centerRight,
                              //   child: TextButton(
                              //       onPressed: () {},
                              //       child: Text(
                              //         'Forgot Password',
                              //         style: mikado400.copyWith(
                              //             color: AppColors.grayC9C9,
                              //             fontStyle: FontStyle.italic,
                              //             decoration: TextDecoration.underline),
                              //       )),
                              // ),
                              const SizedBox(height: 40),
                              CustomButton(
                                color: Colors.white,
                                text: 'Sign In',
                                backgroundColor: AppColors.blue3451F,
                                onTap: () async {
                                  if (controller.keyLogin.currentState!
                                      .validate()) {
                                    var res = await controller
                                        .signInWithEmailAndPassword(
                                      email: controller.emailController.text,
                                    );
                                    if (res.isSuccess) {
                                      Get.find<HomeController>()
                                          .getInforUser()
                                          .then((value) {
                                        controller.emailController.clear();
                                        bool isAdmin = Get.find<
                                                        HomeController>()
                                                    .userInforMore['isAdmin'] ==
                                                null
                                            ? false
                                            : Get.find<HomeController>()
                                                    .userInforMore['isAdmin']
                                                as bool;
                                        bool isVip = Get.find<HomeController>()
                                                    .userInforMore['isVip'] ==
                                                null
                                            ? false
                                            : Get.find<HomeController>()
                                                .userInforMore['isVip'] as bool;
                                        if (isAdmin) {
                                          Get.offAllNamed(Routes.optionLogin);
                                        } else {
                                          if (isVip) {
                                            showConfirmLogin();
                                          } else {
                                            Get.offAllNamed(
                                                Routes.bottomNavigator);
                                          }
                                        }
                                      });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return CustomAlert(
                                                labelText: res.message,
                                                onPressed: () => Get.back());
                                          }));
                                    }
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                color: Colors.black,
                                text: 'Create New Account',
                                backgroundColor: Colors.white,
                                onTap: () {
                                  // final List<MovieModel> list = [];
                                  Get.toNamed(Routes.register);
                                },
                              ),
                            ],
                          ),
                        );
                      })),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showConfirmLogin() {
    final keyLogin = TextEditingController();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Mã bảo mật của bạn. Nếu bạn quên hãy chọn liên hệ để được chúng tôi hỗ trợ.',
              textAlign: TextAlign.center,
              style: mikado500.copyWith(color: Colors.black),
            ),
            content: TextFormField(
              controller: keyLogin,
              // focusNode: controller.focusNodes[0],
              cursorColor: Colors.black,
              // autovalidateMode: AutovalidateMode,
              validator: ((value) {
                return value!.isEmpty ? 'Tên phim không được để trống' : null;
              }),
              style: mikado400.copyWith(color: Colors.black),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20)),
                  fillColor: Colors.grey,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  hintText: 'Eg: matkhaune',
                  hintStyle:
                      mikado400.copyWith(color: Colors.black.withOpacity(0.7))),
            ),
            actions: [
              SizedBox(
                width: 100,
                height: 50,
                child: CustomButton(
                    onTap: () {
                      if (keyLogin.text.toLowerCase() ==
                          Get.find<HomeController>()
                              .userInforMore['keyLogin']
                              .toString()
                              .toLowerCase()) {
                        Get.offAllNamed(Routes.bottomNavigator);
                      } else {
                        Helper.showDialogFuntionLoss(text: 'Mã bảo mật sai');
                        // showDialog(

                      }
                    },
                    color: Colors.white,
                    text: 'Tiếp tục',
                    backgroundColor: Colors.red),
              ),
              SizedBox(
                width: 110,
                height: 50,
                child: CustomButton(
                    onTap: () async {
                      Uri _uri = Uri(scheme: 'tel', path: '0385814308');
                      await launchUrl(_uri);
                    },
                    color: Colors.white,
                    text: 'Liên hệ',
                    backgroundColor: Colors.red),
              ),
            ],
          );
        });
  }
}

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Flexible(
            flex: 1,
            child: SizedBox.expand(),
          ),
          Flexible(
              flex: 3,
              child: Image.asset(
                'assets/images/bg.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ))
        ],
      ),
    );
  }
}
