import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../themes/themes.dart';

class AppTextStyles {
  static TextStyle floatingLabelTextStyle (context) => GoogleFonts.roboto(
    fontSize: 14,
    color: Theme.of(context).textTheme.bodyMedium?.color,
    fontWeight: FontWeight.w400,
  );

  static TextStyle labelTextStyle = GoogleFonts.roboto(
    fontSize: 14,
    color: Colors.black.withOpacity(0.5),
    fontWeight: FontWeight.w400,
  );

  static TextStyle hintTextStyle = GoogleFonts.roboto(
    fontSize: 14,
    color: ThemeConfig.textColorBCBFC2,
    fontWeight: FontWeight.w400,
  );

  static TextStyle buttonTextStyle = GoogleFonts.roboto(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyTextStyle = GoogleFonts.roboto(
    fontSize: 14,
    color: ThemeConfig.textColorBCBFC2,
    fontWeight: FontWeight.w400,
  );

  static TextStyle headingTextStyle = GoogleFonts.roboto(
    fontSize: 24,
    color: ThemeConfig.primaryColor,
    fontWeight: FontWeight.w500,
  );
}
