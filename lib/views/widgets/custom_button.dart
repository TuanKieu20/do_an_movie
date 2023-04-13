import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.width,
      this.height,
      required this.onTap,
      this.fontSize,
      required this.color,
      required this.text,
      required this.backgroundColor,
      this.fontWeight,
      this.radius});

  final double? width;
  final double? height;
  final VoidCallback onTap;
  final Color color;
  final String text;
  final Color backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: width ?? double.infinity,
          height: height ?? 55,
          alignment: Alignment.center,
          // padding: const Ed,
          // margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(radius ?? 16)),
          child: Text(
            text,
            style: mikado500.copyWith(
                fontSize: fontSize ?? 18,
                color: color,
                fontWeight: fontWeight ?? FontWeight.w500),
          )),
    );
  }
}
