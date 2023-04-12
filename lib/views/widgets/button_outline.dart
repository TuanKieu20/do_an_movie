import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class ButtonContainer extends StatelessWidget {
  const ButtonContainer(
      {Key? key,
      required this.icon,
      required this.backgroundColor,
      required this.isBorder,
      required this.text,
      required this.onpress})
      : super(key: key);
  final IconData icon;
  final Color backgroundColor;
  final bool isBorder;
  final String text;
  final VoidCallback onpress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: mikado500,
            )
          ],
        ),
      ),
    );
  }
}
