import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/color.dart';
import '../../../constants/custom_alter.dart';
import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/login_controller.dart';
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password',
                                      style: mikado400.copyWith(
                                          color: AppColors.grayC9C9,
                                          fontStyle: FontStyle.italic,
                                          decoration: TextDecoration.underline),
                                    )),
                              ),
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
                                      controller.emailController.clear();
                                      Get.offAllNamed(Routes.bottomNavigator);
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
                                onTap: () async {
                                  // final List<MovieModel> list = [];
                                  Get.toNamed(Routes.register);

                                  // logger.d(jsonDecode(allData).runtimeType);
                                  // CollectionReference users = FirebaseFirestore
                                  //     .instance
                                  //     .collection('movies');
                                  // users.add({
                                  //   "author": "Byron Howard, Rich Moore,",
                                  //   "category": "Hoạt hình",
                                  //   "comments": [
                                  //     "Phim hay qúa, rất đáng để xem",
                                  //     "Xem đi không lãng phí thời gian của bạn đâu",
                                  //     "Tuyệt vời !!!",
                                  //     "Chất lượng phim quá tốt, phim rất hay !"
                                  //   ],
                                  //   "description":
                                  //       "Phi Vụ Động Trời Zootopia 2016 Full HD Vietsub Thuyết Minh Zootopia 2016 - Zootopia là một thành phố kỳ lạ, không giống bất kỳ thành phố nào trong thế giới Walt Disney trước đây. Nơi đây là khu đô thị vui nhộn của các loài động vật, từ những con to như voi, tê giác, đến những con nhỏ như chuột, thỏ .... Cho đến một ngày, nữ cảnh sát thỏ Judy Hopps xuất hiện, thành phố Zootopia đã hoàn toàn thay đổi. Cô và người bạn đồng hành của mình - chú cáo đầy mánh khóe Nick Wildle (Jasson Bateman lồng tiếng) đã cùng nhau phiêu lưu trong một vụ án kỳ lạ, với mong muốn lập lại trật tự cho thành phố ZOOTOPIA. Trailer của phim vừa được tung ra với phong cách vô cùng độc đáo, Walt Disney đã sử dụng hình ảnh của hai nhân vật chính là cáo Nick Wildle và thỏ Judy Hopps với những câu chữ minh họa ngắn gọn theo nhịp nhạc nhanh - chậm. liên tục. Nhà Chuột cũng hé lộ một cảnh hài hước của cặp đôi khi Judy Hopps tức giận bắn chết Nick Wildle.",
                                  //   "isFullHD": true,
                                  //   "isSub": true,
                                  //   "linkUrl":
                                  //       "https://firebasestorage.googleapis.com/v0/b/do-an-movie.appspot.com/o/video%2FZootopia-%20Phi%20Vu%CC%A3%20%C4%90o%CC%A3%CC%82ng%20Tro%CC%9B%CC%80i.mp4?alt=media&token=01b35d44-3157-4604-ae8d-0fa96021a021",
                                  //   "name": "Zootopia - Phi Vụ Động Trời",
                                  //   "poster":
                                  //       "https://upload.wikimedia.org/wikipedia/vi/archive/2/2b/20230123151114%21Kh%C3%B4ng_ph%E1%BA%A3i_l%C3%BAc_ch%E1%BA%BFt_poster.jpg",
                                  //   "rating": 4.0,
                                  //   "releaseYear": 2016,
                                  //   "time": "96",
                                  //   "trailer": "",
                                  // });
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
