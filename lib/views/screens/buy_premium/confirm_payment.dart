import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/bottom_navigator.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/payment_controller.dart';
import '../../helpers/helper.dart';
import '../../widgets/custom_button.dart';

class ConfirmPayment extends StatelessWidget {
  const ConfirmPayment({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentController>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              size: 28,
            )),
        title: Text(
          'Tóm Tắt Giao Dịch',
          style: mikado500.copyWith(color: Colors.white, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<PaymentController>(builder: (builder) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItem(
                    price: controller.currentPrice.toString(),
                    onTap: () {},
                    month: controller.currenMonth.value == 1
                        ? ' /tháng'
                        : ' /năm'),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xff20232a),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Giá',
                            style: mikado400.copyWith(fontSize: 18),
                          ),
                          Text(
                            '\$${controller.currentPrice.toString()}',
                            style: mikado400.copyWith(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Thuế',
                            style: mikado400.copyWith(fontSize: 18),
                          ),
                          Text(
                            '\$1.99',
                            style: mikado400.copyWith(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng',
                            style: mikado400.copyWith(fontSize: 18),
                          ),
                          Text(
                            '\$${(controller.currentPrice.toDouble() + (controller.currenMonth.value == 1 ? 1.99 : 4.99)).toStringAsFixed(2)}',
                            style: mikado400.copyWith(fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xff20232a),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Icon(
                          controller.cardList[controller.optionMethod.value]
                              ['icon'],
                          color: Colors.lightBlueAccent,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        controller.cardList[controller.optionMethod.value]
                            ['text'],
                        style: mikado500.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                CustomButton(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: ((context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.transparent,
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 30),
                                decoration: BoxDecoration(
                                    color: const Color(0xff20232a),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/zyro-image.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                    Text(
                                      'Chúc Mừng !',
                                      textAlign: TextAlign.center,
                                      style: mikado500.copyWith(
                                          fontSize: 20, color: Colors.red),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Chúc mừng bạn đã đăng kí thành công gói ${controller.currenMonth.value == 1 ? 'một tháng' : 'một năm'}. Chúc bạn có một trải nghiệm thật tốt !!',
                                      textAlign: TextAlign.justify,
                                      style: mikado500.copyWith(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    const SizedBox(height: 20),
                                    CustomButton(
                                        onTap: () {
                                          Get.find<HomeController>()
                                              .isUserVip(true);
                                          controller.addPayment();
                                          showDialog(
                                              // barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Column(
                                                    children: [
                                                      Text(
                                                        'Để bảo mật tài khoản của bạn, vui lòng điền mã bí mật của bạn nhé',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            mikado500.copyWith(
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      Text(
                                                        'Nhớ nó cho lần đăng nhập kế tiếp bạn nhé nhé !!!',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            mikado500.copyWith(
                                                                color:
                                                                    Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                  content: TextFormField(
                                                    controller:
                                                        controller.keyLogin,
                                                    // focusNode: controller.focusNodes[0],
                                                    cursorColor: Colors.black,
                                                    // autovalidateMode: AutovalidateMode,
                                                    // validator: ((value) {
                                                    //   return value!.isEmpty
                                                    //       ? 'Tên phim không được để trống'
                                                    //       : null;
                                                    // }),
                                                    style: mikado400.copyWith(
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        fillColor: Colors.grey,
                                                        filled: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20,
                                                                vertical: 15),
                                                        hintText:
                                                            'Eg: matkhaune',
                                                        hintStyle:
                                                            mikado400.copyWith(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7))),
                                                  ),
                                                  actions: [
                                                    Center(
                                                      child: SizedBox(
                                                        width: 150,
                                                        child: CustomButton(
                                                            onTap: () async {
                                                              if (controller
                                                                  .keyLogin
                                                                  .text
                                                                  .isNotEmpty) {
                                                                if (controller
                                                                        .keyLogin
                                                                        .text
                                                                        .length <
                                                                    6) {
                                                                  Helper.showDialogFuntionLoss(
                                                                      text:
                                                                          'Mã quá ngắn vui lòng thử lại');
                                                                } else {
                                                                  Get.offAllNamed(
                                                                      Routes
                                                                          .bottomNavigator);
                                                                  Get.delete<
                                                                      PaymentController>();
                                                                  Get.find<
                                                                          BottomNavigatorController>()
                                                                      .changeCurrentIndex(
                                                                          index:
                                                                              0);
                                                                  await controller
                                                                      .updateKeyLogin();
                                                                }
                                                              } else {
                                                                Helper.showDialogFuntionLoss(
                                                                    text:
                                                                        'Không được để trống');
                                                              }
                                                            },
                                                            color: Colors.white,
                                                            text: 'Tiếp tục',
                                                            backgroundColor:
                                                                Colors.red),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        color: Colors.white,
                                        text: 'Đồng ý',
                                        backgroundColor: Colors.red)
                                  ],
                                ),
                              ),
                            );
                          }));
                    },
                    color: Colors.white,
                    text: 'Thanh toán',
                    backgroundColor: Colors.red)
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildItem(
      {required String price, required Function onTap, required String month}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        margin: const EdgeInsets.only(top: 20),
        height: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xff20232a),
            border: Border.all(
              width: 3,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Transform.scale(
              scale: 1.3,
              child: const Icon(
                Icons.workspace_premium_outlined,
                color: Colors.red,
                size: 48,
                // size: 32,
              ),
            ),
            const SizedBox(height: 20),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: price,
                style: mikado600.copyWith(color: Colors.white, fontSize: 26),
              ),
              TextSpan(
                text: month,
                style: mikado400.copyWith(color: Colors.white, fontSize: 14),
              ),
            ])),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Xem phim không chứa quảng cáo',
                          style: mikado400.copyWith(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Xem trực tuyến 4k',
                          style: mikado400.copyWith(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Chất lượng video tốt nhất',
                          style: mikado400.copyWith(),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
