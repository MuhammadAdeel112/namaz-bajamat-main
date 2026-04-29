// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'themes.dart';
//
// ThemeData lightTheme = ThemeData.light().copyWith(
//   appBarTheme: const AppBarTheme(
//       systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
//       iconTheme: IconThemeData(
//         color: Colors.black,
//       )),
//   colorScheme: ThemeData.light().colorScheme.copyWith(
//       secondary: const Color(0xffa1a1a1),
//       primary: const Color(0xff0F0425),
//       onPrimary: const Color(0xff9694B8),
//       outline: const Color(0xfff0f0f0),
//       onBackground: const Color(0xfff6f8f8),
//       background: const Color(0xffDCE8E8),
//       primaryContainer: Colors.white,
//       onPrimaryContainer: const Color(0xffd8d8da)),
//   textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
//   scaffoldBackgroundColor: Colors.white,
//   progressIndicatorTheme: const ProgressIndicatorThemeData(linearTrackColor: Color(0xffECEAEA), color: ThemeConfig.primaryColor),
//   primaryColor: ThemeConfig.primaryColor,
//   radioTheme: RadioThemeData(
//     fillColor: MaterialStateColor.resolveWith(
//       (states) => Colors.black.withOpacity(.4),
//     ),
//   ),
//   textTheme: ThemeData.light().textTheme.copyWith(
//         titleMedium: GoogleFonts.roboto(color: Colors.black),
//         titleSmall: GoogleFonts.roboto(
//           color: Colors.black.withOpacity(.5),
//         ),
//         displayLarge: GoogleFonts.roboto(
//           color: Colors.black,
//         ),
//         displayMedium: GoogleFonts.roboto(
//           color: Colors.black,
//           fontWeight: FontWeight.w400,
//         ),
//         headlineMedium: GoogleFonts.roboto(
//           // color: ThemeConfig.textColor6B698E,
//           color: ThemeConfig.primaryColor,
//         ),
//         displaySmall: GoogleFonts.roboto(
//           color: Colors.black,
//           fontWeight: FontWeight.w400,
//         ),
//         bodyMedium: GoogleFonts.roboto(
//           color: ThemeConfig.textColorBCBFC2,
//         ),
//       ),
// );
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.grey.shade200,
  primaryColor: const Color(0xFF386871),
  // updated primary
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: const Color(0xFF386871),
        // new primary color
        onPrimary: Colors.white,
        secondary: const Color(0xFF92D8F0),
        // new secondary (light)
        background: const Color(0xFFF5F7FA),
        onBackground: const Color(0xFF2C3E50),
        outline: const Color(0xFFD1D5DB),
        primaryContainer: Colors.white,
        onPrimaryContainer:
            const Color(0xFF2A5559), // darker variant of primary
      ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF2C3E50),
    ),
    titleTextStyle: TextStyle(
      color: Color(0xFF2C3E50),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF386871),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF386871),
    linearTrackColor: Color(0xFFD7E3FF),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.roboto(
      color: const Color(0xFF2C3E50),
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.roboto(
      color: const Color(0xFF2C3E50),
      fontWeight: FontWeight.w600,
    ),
    titleSmall: GoogleFonts.roboto(
      color: const Color(0xFF6C7A89),
      fontWeight: FontWeight.w500,
    ),
    displayLarge: GoogleFonts.roboto(color: const Color(0xFF2C3E50)),
    displayMedium: GoogleFonts.roboto(
      color: const Color(0xFF2C3E50),
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.roboto(
      // color: ThemeConfig.textColor6B698E,
      color: const Color(0xFF2C3E50),
    ),
    displaySmall: GoogleFonts.roboto(
      color: const Color(0xFF7F8C8D),
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: GoogleFonts.roboto(
      color: const Color(0xFF2C3E50),
    ),
    bodyMedium: GoogleFonts.roboto(
      color: const Color(0xFF6C7A89),
    ),
    bodySmall: GoogleFonts.roboto(
      color: const Color(0xFF95A5A6),
    ),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(const Color(0xFF386871)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF386871),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  ),
);
