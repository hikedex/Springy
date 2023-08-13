import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText {
  static dynamic fontFamily = GoogleFonts.nunitoSans;
  static dynamic textTheme = GoogleFonts.nunitoSansTextTheme;
  static TextStyle apply({TextStyle? style, FontWeight? weight, Color? color}) {
    if (style == null) {
      return fontFamily(
        fontWeight: weight,
      );
    }
    return style.merge(fontFamily(
      fontWeight: weight,
      color: color,
    ));
  }
}
