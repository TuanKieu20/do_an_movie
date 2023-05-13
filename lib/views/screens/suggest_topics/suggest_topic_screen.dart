import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/custom_alter.dart';
import '../../../constants/styles.dart';
import '../../../controllers/register_controller.dart';
import '../../helpers/helper.dart';
import '../../widgets/custom_button.dart';

class SuggestTopicScreen extends StatefulWidget {
  const SuggestTopicScreen({super.key});

  @override
  State<SuggestTopicScreen> createState() => _SuggestTopicScreenState();
}

class _SuggestTopicScreenState extends State<SuggestTopicScreen> {
  final controller = Get.find<RegisterController>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // const SizedBox(height: 100),
                  Container(
                    // color: Colors.red,

                    alignment: Alignment.center,
                    height: 200,
                    child: Text(
                      'Vì ứng dụng của chúng tôi có những bộ phim giới hạn độ tuổi. Vậy nên bạn cho chúng tôi biết thêm thông tin của bạn nhé !',
                      style: mikado400.copyWith(),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // const Spacer(),
                  SizedBox(
                    // height: 500,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Bạn đã đủ 18 tuổi chưa ?',
                            style: mikado500.copyWith(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GetBuilder<RegisterController>(builder: (builder) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.changeAge(0);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              controller.isEighteenAge.value ==
                                                      0
                                                  ? Colors.red
                                                  : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1, color: Colors.red)),
                                      child:
                                          Image.asset('assets/images/girl.png'),
                                      // child: SizedBox(),
                                      // child: Text(
                                      //   text,
                                      //   style: mikado700.copyWith(),
                                      // ),
                                    ),
                                    const Text(
                                      'KID',
                                      style: mikado600,
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.changeAge(1);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              controller.isEighteenAge.value ==
                                                      1
                                                  ? Colors.red
                                                  : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1, color: Colors.red)),
                                      child: Image.asset(
                                          'assets/images/relax.png'),
                                    ),
                                    const Text(
                                      'NOT KID',
                                      style: mikado600,
                                    )
                                  ],
                                ),
                              ),
                              // _buildButton(
                              //     ontap: () {
                              //       controller.changeAge(0);
                              //     },
                              //     text: 'Dưới 18 tuổi',
                              //     isImage: true,
                              //     isChoose: controller.isEighteenAge.value == 0),
                              // _buildButton(
                              //     ontap: () {
                              //       controller.changeAge(1);
                              //     },
                              //     text: 'Trên 18 tuổi',
                              //     isChoose: controller.isEighteenAge.value == 1)
                            ],
                          );
                        }),
                        const SizedBox(height: 100),
                        Center(
                          child: Text(
                            'Bạn quan tâm đến chủ đề nào ?',
                            style: mikado500.copyWith(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: GetBuilder<RegisterController>(
                              builder: (builder) {
                            return Wrap(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              alignment: WrapAlignment.spaceEvenly,
                              spacing: 20.0,
                              runSpacing: 20.0,
                              children: [
                                _buildButton(
                                    ontap: () {
                                      controller.changeTopic(
                                          !controller.selectTopic()[0], 0);
                                    },
                                    text: 'Khoa học',
                                    isChoose: controller.selectTopic()[0]),
                                _buildButton(
                                    ontap: () {
                                      if (controller.isEighteenAge.value == 0) {
                                        Helper.showDialogFuntionLoss(
                                            text:
                                                'Không thể chọn thể loại này khi bạn là trẻ nhỏ');
                                      } else {
                                        controller.changeTopic(
                                            !controller.selectTopic()[1], 1);
                                      }
                                    },
                                    text: 'Kinh dị',
                                    isEnable:
                                        controller.isEighteenAge.value == 0
                                            ? true
                                            : false,
                                    isChoose: controller.selectTopic()[1]),
                                _buildButton(
                                    ontap: () {
                                      if (controller.isEighteenAge.value == 0) {
                                        Helper.showDialogFuntionLoss(
                                            text:
                                                'Không thể chọn thể loại này khi bạn là trẻ nhỏ');
                                      } else {
                                        controller.changeTopic(
                                            !controller.selectTopic()[2], 2);
                                      }
                                    },
                                    isEnable:
                                        controller.isEighteenAge.value == 0
                                            ? true
                                            : false,
                                    text: 'Tình yêu',
                                    isChoose: controller.selectTopic()[2]),
                                _buildButton(
                                    ontap: () {
                                      if (controller.isEighteenAge.value == 0) {
                                        Helper.showDialogFuntionLoss(
                                            text:
                                                'Không thể chọn thể loại này khi bạn là trẻ nhỏ');
                                      } else {
                                        controller.changeTopic(
                                            !controller.selectTopic()[3], 3);
                                      }
                                    },
                                    isEnable:
                                        controller.isEighteenAge.value == 0
                                            ? true
                                            : false,
                                    text: 'Hành động',
                                    isChoose: controller.selectTopic()[3]),
                                _buildButton(
                                    ontap: () {
                                      controller.changeTopic(
                                          !controller.selectTopic()[4], 4);
                                    },
                                    text: 'Hoạt hình',
                                    isChoose: controller.selectTopic()[4]),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 50),
                        CustomButton(
                            onTap: () {
                              if (controller.isEighteenAge.value != (-1)) {
                                final pref = Get.find<SharedPreferences>();
                                if (pref.getBool('checkUpdateInf') == false) {
                                  pref.setBool('checkUpdateInf', true);
                                }
                                // Get.find<HomeController>().getMoviesForYou();
                                controller.updateInforUser();
                                controller.changeShowDialog(true);
                                controller.startTimeText();
                                showDialog(
                                    context: context,
                                    builder: ((context) =>
                                        GetBuilder<RegisterController>(
                                            builder: (builder) {
                                          return CustomAlert(
                                            labelText:
                                                'Cảm ơn bạn !\nBạn sẽ được chuyển đến trang chủ sau:',
                                            onPressed: () {},
                                            buttonText:
                                                '${builder.time().toString()}s',
                                          );
                                        })));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return CustomAlert(
                                          labelText:
                                              'Vui lòng chọn thông tin !!!',
                                          onPressed: () => Get.back());
                                    }));
                              }
                            },
                            color: Colors.white,
                            text: 'Bắt đầu ==>',
                            backgroundColor: Colors.red)
                      ],
                    ),
                  )

                  // const Spacer(),
                ],
              ),
            ),
          )),
    );
  }

  InkWell _buildButton(
      {required Function ontap,
      required bool isChoose,
      required String text,
      bool isEnable = false,
      bool isImage = false}) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: isEnable
                ? Colors.grey
                : isChoose
                    ? Colors.red
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            image: isImage
                ? const DecorationImage(
                    image: AssetImage('assets/images/girl.png'))
                : null,
            border: Border.all(
                width: 1, color: isEnable ? Colors.grey : Colors.red)),
        child: Text(
          text,
          style: mikado700.copyWith(),
        ),
      ),
    );
  }
}
