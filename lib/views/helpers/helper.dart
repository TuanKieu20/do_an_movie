import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/color.dart';
import '../../constants/restricted_words.dart';
import '../../constants/styles.dart';
import '../widgets/custom_button.dart';

class Helper {
  static void showMissingPermission(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (buider) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 34),
              child: Container(
                constraints: const BoxConstraints(maxWidth: double.infinity),
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 26),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0))
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(message,
                            textAlign: TextAlign.center,
                            style: mikado500.copyWith(
                                fontSize: 16, color: Colors.black))),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                            width: 110,
                            height: 40,
                            onTap: (() => Get.back()),
                            color: Colors.white,
                            text: 'Huỷ',
                            backgroundColor: AppColors.blue3451F),
                        CustomButton(
                            width: 110,
                            height: 40,
                            onTap: (() async {
                              Get.back();
                              await openAppSettings();
                            }),
                            color: Colors.white,
                            text: "Cài đặt",
                            backgroundColor: AppColors.blue3451F),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  static String formatEmail(String email) {
    if (email.endsWith("@gmail.com")) {
      email = email.substring(0, email.length - 10);
    }
    List<String> words = email.split(" ");
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(" ");
  }
  //   title: 'Thông Báo !!!',
  // message:
  //     'Tính năng đang được chúng tôi được phát triển. Xin lỗi vì sự bất tiện này !!',

  static void showDialogFuntionLoss({String? text}) {
    Get.snackbar('', '',
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP,
        maxWidth: 500,
        titleText: Center(
          child: Text(
            'Thông báo',
            style: mikado600.copyWith(color: Colors.red),
          ),
        ),
        messageText: Text(
          text ??
              'Tính năng đang được chúng tôi được phát triển. Xin lỗi vì sự bất tiện này !!!',
          textAlign: TextAlign.center,
          style: mikado400.copyWith(fontSize: 14),
        ));
  }

  static String? getValueFilter(int valuee, int index) {
    String value = '';
    if (valuee == (-1)) {
      return null;
    }
    if (index == 0) {
      switch (valuee) {
        case 0:
          value = 'Khoa học viễn tưởng';
          break;
        case 1:
          value = 'Kinh dị';
          break;
        case 2:
          value = 'Hành động';
          break;
        case 3:
          value = 'Hoạt hình';
          break;
        case 4:
          value = 'Tình cảm';
          break;
        case 5:
          value = 'Khoa học';
          break;
        case (-1):
          return null;
        default:
          return null;
      }
      return value;
    }
    if (index == 1) {
      switch (valuee) {
        case 0:
          value = '0 - 2 ⭐';
          break;
        case 1:
          value = '2 - 4 ⭐';
          break;
        case 2:
          value = '4 - 5 ⭐';
          break;
        default:
          return null;
      }
      return value;
    }
    if (index == 2) {
      switch (valuee) {
        case 0:
          value = 'Phổ biến';
          break;
        case 1:
          value = 'Mới nhất';
          break;
        default:
          return null;
      }
      return value;
    }
    return null;
  }

// mã hoá tên hiểu thị
  static String hideString(String originalString) {
    final random = Random();
    final suffixLength = random.nextInt(4) + 3;
    final suffix = List.generate(
            suffixLength, (_) => String.fromCharCode(random.nextInt(26) + 97))
        .join();

    // Randomly insert or append the suffix to the original string
    if (random.nextBool()) {
      return suffix + originalString;
    } else {
      final index = random.nextInt(originalString.length);
      return originalString.substring(0, index) +
          suffix +
          originalString.substring(index);
    }
  }

// viết hoá kí tự đầu
  static String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  static String getTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? "${twoDigits(duration.inHours)}:" : ""}$twoDigitMinutes:$twoDigitSeconds";
  }

  static int calculateTimeDifferenceInSeconds(DateTime time1, DateTime time2) {
    Duration difference = time2.difference(time1);
    int seconds = difference.inSeconds;
    return seconds;
  }

  static String? validatePhoneNumber(String input) {
    if (input.isEmpty) {
      return 'Vui lòng nhập số điện thoại của bạn !';
    } else {
      String pattern =
          r'^(0|84)(2(0[3-9]|1[0-6|8|9]|2[0-2|5-9]|3[2-9]|4[0-9]|5[1|2|4-9]|6[0-3|9]|7[0-7]|8[0-9]|9[0-4|6|7|9])|3[2-9]|5[5|6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])([0-9]{7})$';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(input)) {
        return null;
      } else {
        return 'Số điện thoại không hợp lệ.';
      }
    }
  }

  static String? validateEmail(String email) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(pattern);

    if (regex.hasMatch(email)) {
      return null;
    } else {
      return "Email không hợp lệ";
    }
  }

  static String validateRestrictedWord(String input) {
    final regexVietnamese = RegExp(
        r'[0-9a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễếệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]');
    for (var string in restrictedWords) {
      // Check upperCase string input
      while (input.contains(string.toLowerCase())) {
        input = input.replaceAll(
            string.toLowerCase(), string.replaceAll(regexVietnamese, '*'));
      }
      // Check lowerCase string input
      while (input.contains(string.toUpperCase())) {
        input = input.replaceAll(
            string.toUpperCase(), string.replaceAll(regexVietnamese, '*'));
      }
      // Check lowerCase and upperCase string input
      while (input.contains(string)) {
        input =
            input.replaceAll(string, string.replaceAll(regexVietnamese, '*'));
      }
    }
    return input;
  }

  static String dateTimeToFormattedString(String dateTimeStr) {
    // Chuyển đổi chuỗi kiểu DateTime thành DateTime object
    DateTime dateTime = DateTime.parse(dateTimeStr);

    // Định dạng ngày tháng năm theo kiểu "dd/MM/yyyy"
    String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.year.toString()}";

    // Trả về chuỗi ngày tháng năm đã định dạng
    return formattedDate;
  }

  static String convertDateExpried(String dateTimeStr, int type) {
    // Chuyển đổi chuỗi kiểu DateTime thành DateTime object
    DateTime dateTime = DateTime.parse(dateTimeStr);
    if (type == 1) {
      dateTime = DateTime(dateTime.year, dateTime.month + 1, dateTime.day);
    } else {
      dateTime = DateTime(dateTime.year + 1, dateTime.month, dateTime.day);
    }
    // Định dạng ngày tháng năm theo kiểu "dd/MM/yyyy"
    String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.year.toString()}";

    // Trả về chuỗi ngày tháng năm đã định dạng
    return formattedDate;
  }

  static DateTime convertdDateTime(String dateTimeStr, int type) {
    // Chuyển đổi chuỗi kiểu DateTime thành DateTime object
    DateTime dateTime = DateTime.parse(dateTimeStr);
    if (type == 1) {
      dateTime = DateTime(dateTime.year, dateTime.month + 1, dateTime.day);
    } else {
      dateTime = DateTime(dateTime.year + 1, dateTime.month, dateTime.day);
    }
    return dateTime;
  }

  static void showDialogConfirm(
      BuildContext context, VoidCallback onTap, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text(
              'Bạn có chắc chắn đặt quyền Admin cho người dùng này không ?'),
          actions: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                onTap();
              },
            ),
          ],
        );
      },
    );
  }

  static List<Color> colorBorder = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.deepPurpleAccent,
    Colors.deepOrange,
    Colors.white,
    Colors.yellowAccent
  ];
}
