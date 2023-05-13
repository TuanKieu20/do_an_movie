import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/custom_alter.dart';
import '../../../../constants/logger.dart';
import '../../../../constants/styles.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../controllers/profile_controller.dart';
import '../../../helpers/helper.dart';
import '../../../widgets/custom_button.dart';
import 'premium_header.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.find<ProfileController>();
  final homeContrller = Get.find<HomeController>();
  late bool isVip;

  @override
  void initState() {
    logger.e(homeContrller.userInforMore);
    isVip = Get.find<HomeController>().userInforMore['isVip'] == null
        ? false
        : Get.find<HomeController>().userInforMore['isVip'] as bool;
    controller.nameTextController = TextEditingController(
        text: controller.currentUser!.displayName == null
            ? homeContrller.userInforMore['name'] ?? 'Người dùng'
            : controller.currentUser?.displayName);
    controller.emailTextController =
        TextEditingController(text: controller.currentUser!.email);
    controller.numberTextController = TextEditingController(
        text: homeContrller.userInforMore['phoneNumber'] ?? '');
    if (isVip) {
      controller.keyLoginController =
          TextEditingController(text: homeContrller.userInforMore['keyLogin']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              var check = controller.checkChangValue();
              if (check) {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return CustomAlert(
                        labelText: 'Bạn có muốn huỷ những sự thay đổi này ?',
                        onPressed: () {
                          Get.back();
                          Get.back();
                          controller.update();
                        },
                        isShowButton2: true,
                      );
                    }));
              } else {
                Get.back();
                controller.update();
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            )),
        title: Text(
          'Thông tin cá nhân',
          style: mikado500.copyWith(fontSize: 21),
        ),
      ),
      body: GetBuilder<ProfileController>(builder: (builder) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: AvatarEdit(
                  width: 150,
                  onTap: () => controller.getImage(context),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                  key: controller.editKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.nameTextController,
                        style: mikado500.copyWith(color: Colors.white),
                        autovalidateMode: AutovalidateMode.always,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập tên của bạn';
                          } else if (value.length < 6) {
                            return 'Tên quá ngắn, vui lòng thử lại';
                          }
                          return null;
                        }),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            // hintText: 'hanhnhanhne',
                            fillColor: const Color(0xff20232b),
                            filled: true,
                            hintStyle: mikado500.copyWith(color: Colors.red),
                            labelStyle: mikado500.copyWith(color: Colors.red),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20)),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: controller.emailTextController,
                        style: mikado500.copyWith(color: Colors.white),
                        autovalidateMode: AutovalidateMode.always,
                        // enabled: false,
                        readOnly: true,
                        onTap: () => Helper.showDialogFuntionLoss(
                            text: 'Không được thay đổi trường này !'),
                        validator: (value) {
                          return Helper.validateEmail(value ?? '');
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            // hintText: 'hanhnhanhne',
                            fillColor: const Color(0xff20232b),
                            filled: true,
                            hintStyle: mikado500.copyWith(color: Colors.red),
                            labelStyle: mikado500.copyWith(color: Colors.red),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20)),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: controller.numberTextController,
                        style: mikado500.copyWith(color: Colors.white),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return Helper.validatePhoneNumber(value ?? '');
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Số điện thoại...',
                            fillColor: const Color(0xff20232b),
                            filled: true,
                            hintStyle:
                                mikado500.copyWith(color: Colors.white54),
                            // labelStyle: mikado500.copyWith(color: Colors.red),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20)),
                      ),
                      const SizedBox(height: 10),
                      if (isVip)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Mã bảo mật',
                              style: mikado500.copyWith(
                                  color: Colors.white, fontSize: 18)),
                        ),
                      const SizedBox(height: 10),
                      if (isVip)
                        TextFormField(
                          controller: controller.keyLoginController,
                          style: mikado500.copyWith(color: Colors.white),
                          autovalidateMode: AutovalidateMode.always,
                          readOnly: true,
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập tên của bạn';
                            } else if (value.length < 6) {
                              return 'Tên quá ngắn, vui lòng thử lại';
                            }
                            return null;
                          }),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              // hintText: 'hanhnhanhne',
                              fillColor: const Color(0xff20232b),
                              filled: true,
                              hintStyle: mikado500.copyWith(color: Colors.red),
                              labelStyle: mikado500.copyWith(color: Colors.red),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20)),
                        ),
                      const SizedBox(height: 30),
                      CustomButton(
                        onTap: () async {
                          if (controller.editKey.currentState!.validate()) {
                            await controller.updateInforUser();
                            Get.back();
                            Helper.showDialogFuntionLoss(
                                text:
                                    'Cập nhật thông tin người dùng thành công !');
                          }
                        },
                        color: Colors.white,
                        text: 'Cập nhật',
                        backgroundColor: Colors.red,
                        radius: 30,
                      )
                    ],
                  ))
            ],
          ),
        );
      }),
    );
  }
}
