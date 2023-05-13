import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/payment_controller.dart';
import '../../widgets/custom_button.dart';

class OptionPayment extends StatelessWidget {
  const OptionPayment({super.key});

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
                color: Colors.white,
              )),
          title: Text(
            'Payment',
            style: mikado500.copyWith(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Chọn phương thức thanh toán bạn muốn dùng.',
                style: mikado400,
              ),
              const SizedBox(height: 20),
              GetBuilder<PaymentController>(builder: (builder) {
                return Expanded(
                    child: ListView.builder(
                        itemCount: controller.cardList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => controller.changeOptionMethod(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                  color: const Color(0xff20232a),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.3,
                                    child: Icon(
                                      controller.cardList[index]['icon'],
                                      color: Colors.lightBlueAccent,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    controller.cardList[index]['text'],
                                    style: mikado500.copyWith(fontSize: 17),
                                  ),
                                  const Spacer(),
                                  Radio(
                                    value: controller.cardList[index]['value'],
                                    groupValue: controller.optionMethod.value,
                                    onChanged: (value) {
                                      controller.changeOptionMethod(value);
                                    },
                                    activeColor: Colors.red,
                                    fillColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Colors.blue;
                                      }
                                      return Colors.red;
                                    }),
                                  )
                                ],
                              ),
                            ),
                          );
                        })));
              }),
              CustomButton(
                  onTap: () => Get.toNamed(Routes.confirmPayment),
                  color: Colors.white,
                  text: 'Tiếp tục',
                  backgroundColor: Colors.red),
              const SizedBox(height: 50),
            ],
          ),
        ));
  }
}
