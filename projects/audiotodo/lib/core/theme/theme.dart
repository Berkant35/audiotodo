import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_colors.dart';

class CustomTheme {
  static final ThemeData themeData = ThemeData(
    primaryColor: CustomColors.primaryColor,
    accentColor: CustomColors.secondaryColor,
    scaffoldBackgroundColor: CustomColors.fillWhiteColor,

    cardColor: CustomColors.fillWhiteColor,
    errorColor: CustomColors.errorColor,

    appBarTheme: const AppBarTheme(
      color: CustomColors.primaryColor,

      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: CustomColors.primaryColor,
        onPrimary: CustomColors.fillWhiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: CustomColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}