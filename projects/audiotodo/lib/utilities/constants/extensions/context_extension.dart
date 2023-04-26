import 'dart:math';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../app/application_constants.dart';


extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

extension MediaQueryExtension on BuildContext {
  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  double get lowValue => height * 0.01;

  double get lowToNormalValue => height * 0.015;

  double get normalValue => height * 0.02;

  double get normaltoMediumValue => height * 0.035;

  double get mediumValue => height * 0.04;

  double get mediumtoHighValue => height * 0.065;

  double get highValue => height * 0.1;

  double get rate => height / width;
}

extension PixelOfSvgIconExtension on BuildContext {
  double get pixelOfSvgIconLow => height * 0.04;

  double get pixelOfSvgIconMedium => height * 0.06;

  double get pixelOfSvgIconHigh => height * 0.08;
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorSchema => theme.colorScheme;
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddinglow => EdgeInsets.all(lowValue);

  EdgeInsets get paddingNormal => EdgeInsets.all(normalValue);

  EdgeInsets get paddingMedium => EdgeInsets.all(mediumValue);

  EdgeInsets get paddingHigh => EdgeInsets.all(highValue);
}

//sağa sola yatımra işlemlerindeki dalga dümenler oluyor bu
extension PaddingExtensionSymetric on BuildContext {
  EdgeInsets get paddingLowVertical => EdgeInsets.symmetric(vertical: lowValue);

  EdgeInsets get paddingNormalVertical =>
      EdgeInsets.symmetric(vertical: normalValue);

  EdgeInsets get paddingMediumVertical =>
      EdgeInsets.symmetric(vertical: mediumValue);

  EdgeInsets get paddingHighVertical =>
      EdgeInsets.symmetric(vertical: highValue);

  EdgeInsets get paddingLowHorizontal =>
      EdgeInsets.symmetric(horizontal: lowValue);

  EdgeInsets get paddingNormalHorizontal =>
      EdgeInsets.symmetric(horizontal: normalValue);

  EdgeInsets get paddingMediumHorizontal =>
      EdgeInsets.symmetric(horizontal: mediumValue);

  EdgeInsets get paddingHighHorizontal =>
      EdgeInsets.symmetric(horizontal: highValue);
}

extension PageExtension on BuildContext {
  Color get randomColor => Colors.primaries[Random().nextInt(17)];
}

extension DurationExtension on BuildContext {
  Duration get lowDuration => const Duration(milliseconds: 500);

  Duration get normalDuration => const Duration(seconds: 1);

  Duration get hugeDuration => const Duration(seconds: 3);
}

extension GapSizedBox on Widget{
  static SizedBox get miniGap =>  SizedBox(height: 2.h);
  static SizedBox get smallGap =>  SizedBox(height: 4.h);
  static SizedBox get mediumGap =>  SizedBox(height: 8.h,);
  static SizedBox get highGap =>  SizedBox(height: 12.h,);
}

extension ThemeValueExtension on BuildContext {
  static TextStyle get headline1 => TextStyle(
      fontSize: 23.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get headline2 => TextStyle(
      fontSize: 56.sp,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get headline3 => TextStyle(
      fontSize: 48.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get headline4 => TextStyle(
      fontSize: 36.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get headline5 => TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get headline6 => TextStyle(
      fontSize: 21.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get subtitle => TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get subtitle2 => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get subtitle3 => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get subtitle4 => TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.25.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get subtitle5 => TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get body => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get body2 => TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get caption => TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.4.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get overline => TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      letterSpacing: 1.5.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get buttonTextStyle => TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);

  static TextStyle get titleTextStyle => TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.clip);

  static TextStyle get primary => TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15.sp,
      fontFamily: ApplicationConstants.customFontFamily,
      overflow: TextOverflow.ellipsis);
}
