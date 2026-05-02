import 'package:flutter/material.dart';


class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines, // Now null by default (unlimited lines)
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: true,
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines, // null = unlimited lines
      overflow: overflow, // null = no ellipsis
      style: style?.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ) ??
          TextStyle(
            color: color ?? Colors.black,
            fontSize: fontSize ?? 14, // Replace with your default
            fontFamily: 'Poppins',
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
    );
  }
}