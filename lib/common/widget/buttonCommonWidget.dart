import 'package:flutter/material.dart';
import 'package:socialpoc/common/contants.dart';

class ButtonCommonWidget extends StatelessWidget {
  final Color borderColor;
  final double borderRadius;
  final Color backgroundColor;
  final Alignment textAlignment;
  final String buttonText;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;


  const ButtonCommonWidget({
    super.key,
    this.borderColor = colorBorder,
    this.borderRadius = 10,
    this.backgroundColor = colorButton,
    this.textAlignment = Alignment.center,
    required this.buttonText,
    required this.onPressed,
    this.fontSize = textSizeMedium,
    this.fontWeight = FontWeight.normal,
    this.fontColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      ),
      child: Align(
        alignment: textAlignment,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: fontColor,
          ),
        ),
      ),
    );
  }
}
