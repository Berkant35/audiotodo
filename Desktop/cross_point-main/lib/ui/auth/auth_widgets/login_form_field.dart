import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../../utilities/constants/custom_colors.dart';
import '../../../utilities/custom_functions.dart';
import '../../../utilities/extensions/font_extension.dart';
import '../../../utilities/extensions/font_theme.dart';

// ignore: must_be_immutable
class LoginFormField extends StatelessWidget {
  TextEditingController controller;
  String? initialValue;
  Icon? preicon;
  Widget? suficon;
  String? helperText;
  String? counterText;
  int? maxLengthWord;
  EdgeInsets? contentPadding;
  bool? goster;
  bool? isAvailablePaste;
  TextInputType? inputType;
  String? Function(String? value) validateFunction;

  LoginFormField(
      {Key? key,
        required this.controller,
        this.initialValue,
        required this.validateFunction,
        this.preicon,
        this.helperText,
        this.suficon,
        this.contentPadding,
        this.counterText,
        this.isAvailablePaste,
        this.inputType,
        this.goster,
        this.maxLengthWord})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.width / 15),
      child: TextFormField(
        obscureText: goster ?? false,
        keyboardType: inputType ?? TextInputType.text,
        controller: controller,
        enableInteractiveSelection: isAvailablePaste ?? true,
        validator: validateFunction,
        maxLength: maxLengthWord,
        style: ThemeValueExtension.subtitle3,
        enableSuggestions: true,
        cursorColor: Colors.red,
        decoration: InputDecoration(
          counterText: counterText,
          filled: true,
          disabledBorder: null,
          errorBorder: null,
          border: InputBorder.none,
          enabledBorder: null,
          focusedErrorBorder: null,
          focusedBorder: null,
          prefixIcon: preicon,
          suffixIcon: suficon,
          helperText: helperText ?? '',
          fillColor: const Color(0xffc4c4c4).withOpacity(0.15),
          iconColor: Colors.red,
          hoverColor: Colors.red,
          prefixIconColor: Colors.red,
          suffixIconColor: Colors.red,
          focusColor: Colors.red,
          hintText: initialValue ?? '',
          hintStyle: ThemeValueExtension.subtitle3.copyWith(
              color: CustomColors.acikGri,
              fontSize: AllFunc.isPhone()
                  ? 10.sp
                  : FontSizeDegerler.lowFontSize.fontDeger),
        ),
      ),
    );
  }
}
