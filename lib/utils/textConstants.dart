import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noteapp/utils/appcolors.dart';

class AppTextTheme {
  static TextStyle appBarTextStyle = GoogleFonts.aBeeZee(
      fontWeight: FontWeight.bold, fontSize: 30, color: AppColor.headTextTheme);
  static TextStyle titleTextStyle = GoogleFonts.aBeeZee(
      fontWeight: FontWeight.bold, fontSize: 25, color: AppColor.headTextTheme);
  static TextStyle subTitleTextStyle = GoogleFonts.aBeeZee(
      fontStyle: FontStyle.italic, fontSize: 15, color: AppColor.contentColor);
  static TextStyle checkTextStyle = GoogleFonts.aBeeZee(
      fontWeight: FontWeight.bold, fontSize: 22, color: AppColor.bodyTextColor);
  static TextStyle bodyTextStyle = GoogleFonts.aBeeZee(
      fontWeight: FontWeight.bold, fontSize: 22, color: AppColor.bodyTextColor);
}