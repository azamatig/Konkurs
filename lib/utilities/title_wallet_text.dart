import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konkurs_app/utilities/constants.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  const TitleText(
      {Key key,
      this.text,
      this.fontSize = 16,
      this.color = LightColors.kLavender})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.muli(
            fontSize: fontSize, fontWeight: FontWeight.w800, color: color));
  }
}
