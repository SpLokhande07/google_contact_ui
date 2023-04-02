import 'package:contacts_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class HText extends StatelessWidget {
  String title;
  Color? color;
  FontWeight? fontWeight;
  double? fontSize;

  HText(
      {Key? key,
      required this.title,
      this.fontWeight,
      this.color,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.roboto(
          color: color ?? kFontColor,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontSize: fontSize ?? 14.sp,
        ));
  }
}
