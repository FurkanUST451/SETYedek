import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // Editorial display — Space Grotesk
  static TextStyle get displayXL => GoogleFonts.spaceGrotesk(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        height: 1.05,
        letterSpacing: -1.2,
      );

  static TextStyle get heading1 => GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.8,
      );

  static TextStyle get heading2 => GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.4,
      );

  static TextStyle get heading3 => GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.2,
      );

  // Body / UI — Inter
  static TextStyle get body1 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get body2 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.2,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.3,
      );

  // Editorial eyebrow — uppercase, tracked
  static TextStyle get eyebrow => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 2.0,
      );

  // Cinematic wordmark
  static TextStyle get wordmark => GoogleFonts.spaceGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -1.5,
      );
}
