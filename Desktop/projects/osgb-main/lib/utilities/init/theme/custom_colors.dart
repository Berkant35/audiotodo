import 'package:flutter/material.dart';

class CustomColors {
  static const Color primaryColor = Color(0xFF213159);
  static final MaterialStateProperty<Color> primaryColorM =
      MaterialStateProperty.all<Color>(primaryColor);

  static const Color secondaryColor = Color(0xFF507BBF);
  static final MaterialStateProperty<Color> secondaryColorM =
      MaterialStateProperty.all<Color>(secondaryColor);

  static const Color orangeColor = Color(0xFFF04B4C);
  static final MaterialStateProperty<Color> orangeColorM =
      MaterialStateProperty.all<Color>(orangeColor);

  static const Color pinkColor = Color(0xffFF7EA5);
  static final MaterialStateProperty<Color> pinkColorM =
  MaterialStateProperty.all<Color>(pinkColor);

  static const Color customGreyColor = Color(0xFFd1d1d1);
  static final MaterialStateProperty<Color> customGreyColorM =
      MaterialStateProperty.all<Color>(customGreyColor);

  static const Color customCardBackgroundColor = Color(0xFFF8FAFF);
  static final MaterialStateProperty<Color> customCardBackgroundColorM =
      MaterialStateProperty.all<Color>(customGreyColor);

  static const Color errorColor = Color(0xFFA50203);
  static final MaterialStateProperty<Color> errorColorM =
      MaterialStateProperty.all<Color>(errorColor);
}
