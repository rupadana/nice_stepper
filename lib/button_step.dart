import 'package:flutter/material.dart';

class ButtonStep extends StatelessWidget {
  final double? fontSize;
  final String text;
  final Color colors;
  final Color? textColors;
  final Color? iconColors;
  final Function()? onPressed;
  final bool? isNext;
  const ButtonStep({
    required this.colors,
    this.textColors,
    this.iconColors,
    required this.text,
    this.fontSize = 12,
    this.onPressed,
    this.isNext = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        child: isNext == true
            ? Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(color: textColors),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: iconColors,
                    size: 10,
                  )
                ],
              )
            : Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    color: iconColors,
                    size: 10,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    text,
                    style: TextStyle(color: textColors),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
        style: ElevatedButton.styleFrom(
            primary: colors,
            textStyle:
                TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
