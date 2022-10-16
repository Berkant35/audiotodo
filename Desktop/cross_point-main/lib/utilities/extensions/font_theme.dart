import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../constants/values.dart';
import '../custom_functions.dart';

extension ThemeValueExtension on TextStyle {
  static TextStyle get headline1 => TextStyle(
      fontSize: AllFunc.isPhone() ? 98.sp : 90.sp,
      fontWeight: FontWeight.w100,
      letterSpacing: -1.5.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get headline2 => TextStyle(
      fontSize: AllFunc.isPhone() ? 61.sp : 58.sp,
      fontWeight: FontWeight.w100,
      letterSpacing: -0.5.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get headline3 => TextStyle(
      fontSize: AllFunc.isPhone() ? 49.sp : 45.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get headline4 => TextStyle(
      fontSize: AllFunc.isPhone() ? 35.sp : 30.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get headline5 => TextStyle(
      fontSize: AllFunc.isPhone() ? 25.sp : 23.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.08.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get headline6 => TextStyle(
      fontSize: AllFunc.isPhone() ? 20.sp : 18.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.08.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get subtitle => TextStyle(
      fontSize: AllFunc.isPhone() ? 16.sp : 12.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.08.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get subtitle2 => TextStyle(
      fontSize: AllFunc.isPhone() ? 12.sp : 10.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.08.sp.sp,
      fontFamily: Values.customFontFamily);
  static TextStyle get subtitle3 => TextStyle(
      fontSize: AllFunc.isPhone() ? 10.sp : 7.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25.sp,
      fontFamily: Values.customFontFamily);
  static TextStyle get subtitle4 => TextStyle(
      fontSize: AllFunc.isPhone() ? 8.sp : 6.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get subtitle5 => TextStyle(
      fontSize: AllFunc.isPhone() ? 6.sp : 4.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get body => TextStyle(
      fontSize: AllFunc.isPhone() ? 16.sp : 14.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get body2 => TextStyle(
      fontSize: AllFunc.isPhone() ? 14.sp : 12.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get caption => TextStyle(
      fontSize: AllFunc.isPhone() ? 12.sp : 10.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.4.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get overline => TextStyle(
      fontSize: AllFunc.isPhone() ? 12.sp : 10.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 1.5.sp,
      fontFamily: Values.customFontFamily);

  static TextStyle get buttonTextStyle => TextStyle(
      fontSize: AllFunc.isPhone() ? 14.sp : 12.sp,
      fontWeight: FontWeight.w100,
      letterSpacing: 1.25.sp,
      fontFamily: Values.customFontFamily);
}
