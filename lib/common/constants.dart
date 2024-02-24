import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';

// colors
const Color kRichBlack = Color(0xFF000814);
const Color kOxfordBlue = Color(0xFF001D3D);
const Color kPrussianBlue = Color(0xFF003566);
const Color kMikadoYellow = Color(0xFFffc300);
const Color kDavysGrey = Color(0xFF4B5358);
const Color kGrey = Color(0xFF303030);

// text style
final TextStyle kHeadingSmall =
    GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400);
final TextStyle kTitleLarge = GoogleFonts.poppins(
    fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15);
final TextStyle kTitleMedium = GoogleFonts.poppins(
    fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15);
final TextStyle kBodyMedium = GoogleFonts.poppins(
    fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25);

// text theme
final kTextTheme = TextTheme(
  headlineSmall: kHeadingSmall,
  titleLarge: kTitleLarge,
  titleMedium: kTitleMedium,
  bodyMedium: kBodyMedium,
);

const kColorScheme = ColorScheme(
  primary: kMikadoYellow,
  primaryContainer: kMikadoYellow,
  secondary: kPrussianBlue,
  secondaryContainer: kPrussianBlue,
  surface: kRichBlack,
  background: kRichBlack,
  error: Colors.red,
  onPrimary: kRichBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onBackground: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
