import 'package:flutter/material.dart';

class CustomColors {
  static const Color primaryColor = Color(0xFF028960);
  static final MaterialStateProperty<Color> primaryColorM =
      MaterialStateProperty.all<Color>(primaryColor);

  static const Color secondaryColor = Color(0xFF219F78);
  static final MaterialStateProperty<Color> secondaryColorM =
      MaterialStateProperty.all<Color>(secondaryColor);

  static const Color fillWhiteColor = Color(0xFFFFFFFF);
  static final MaterialStateProperty<Color> fillWhiteColorM =
  MaterialStateProperty.all<Color>(fillWhiteColor);

  static const Color accentColor = Color(0xFFFFA200);
  static final MaterialStateProperty<Color> accentColorM =
  MaterialStateProperty.all<Color>(accentColor);

  //BCBCBC
  static const Color greyColor = Color(0xFFBCBCBC);
  static final MaterialStateProperty<Color> greyColorM =
  MaterialStateProperty.all<Color>(greyColor);

  static const Color textGreyColor = Color(0xFF5E5E5E);
  static final MaterialStateProperty<Color> textGreyColorM =
  MaterialStateProperty.all<Color>(textGreyColor);

  static const Color backGreyColor = Color(0xFFD9D9D9);
  static final MaterialStateProperty<Color> backGreyColorM =
  MaterialStateProperty.all<Color>(backGreyColor);

  static const Color grey2Color = Color(0xFFD2D2D2);
  static final MaterialStateProperty<Color> grey2ColorM =
  MaterialStateProperty.all<Color>(grey2Color);

  static const Color fillBlackElevationColor = Color(0xFF000000);
  static final MaterialStateProperty<Color> fillBlackElevationColorM =
  MaterialStateProperty.all<Color>(fillBlackElevationColor);

  static const Color errorColor = Color(0xFFEF4059);
  static final MaterialStateProperty<Color> errorColorM =
      MaterialStateProperty.all<Color>(errorColor);

}
