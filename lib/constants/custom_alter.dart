import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/widgets/custom_button.dart';
import 'color.dart';
import 'styles.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({
    Key? key,
    required this.labelText,
    this.buttonText,
    this.buttonText2,
    required this.onPressed,
    this.labelStyle,
    this.padding,
    this.backgroundColor,
    this.onPressed2,
    this.isShowContact = false,
    this.errorCode,
    this.isShowButton2 = false,
  }) : super(key: key);
  final TextStyle? labelStyle;
  final String labelText;
  final String? buttonText;
  final String? buttonText2;
  final Function onPressed;
  final Function? onPressed2;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool? isShowContact;
  final String? errorCode;
  final bool isShowButton2;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              labelText,
              textAlign: TextAlign.center,
              style: labelStyle ??
                  mikado500.copyWith(
                      fontSize: 18, height: 1.5, color: Colors.black),
            ),
            const SizedBox(height: 10),
            if (errorCode != null)
              Text(
                'Error code: $errorCode',
                textAlign: TextAlign.center,
                style: mikado400.copyWith(fontSize: 13, color: Colors.black),
              ),
            const SizedBox(height: 20),
            CustomButton(
                onTap: () {
                  onPressed();
                },
                color: Colors.white,
                text: buttonText ?? 'Xác nhận',
                backgroundColor: backgroundColor ?? AppColors.blue3451F),
            if (isShowButton2) const SizedBox(height: 10),
            if (isShowButton2)
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Huỷ',
                    style: mikado500.copyWith(
                      color: AppColors.blue3451F,
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
