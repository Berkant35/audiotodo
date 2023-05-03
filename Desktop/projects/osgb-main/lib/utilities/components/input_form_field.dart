import 'package:flutter/material.dart';

import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController? authEditingFormController;
  final String? hintText;
  final Icon? iconData;
  final Icon? suffixData;
  final TextStyle? hintStyle;
  final TextAlign? textAlign;
  bool? visibleStatus;
  bool? canEdit;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? inputType;
  String? Function(String? value) validateFunction;
  String? Function(String? value)? customOnChanged;

  CustomFormField(
      {Key? key,
      required this.authEditingFormController,
      this.hintText,
      this.visibleStatus,
      this.maxLines,
      this.suffixData,
      this.maxLength,
      this.textAlign,
      this.canEdit,
      this.hintStyle,
      this.customOnChanged,
      this.inputType,
      required this.validateFunction,
      this.iconData})
      : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        onChanged: widget.customOnChanged,
        keyboardType: widget.inputType ?? TextInputType.text,
        controller: widget.authEditingFormController,
        textAlign: widget.textAlign ?? TextAlign.start,
        readOnly: widget.canEdit != null ? !widget.canEdit! : false,
        style: ThemeValueExtension.subtitle
            .copyWith(color: Colors.black, fontWeight: FontWeight.w400),
        cursorColor: CustomColors.secondaryColor,
        textAlignVertical: TextAlignVertical.center,
        obscureText: widget.visibleStatus ?? false,
        maxLines: widget.maxLines ?? 1,
        maxLength: widget.maxLength,
        validator: widget.validateFunction,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.customGreyColor, width: borderWidth()),
              borderRadius: BorderRadius.circular(context.lowValue),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.secondaryColor, width: borderWidth()),
              borderRadius: BorderRadius.circular(context.lowValue),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.errorColor, width: borderWidth()),
              borderRadius: BorderRadius.circular(context.lowValue),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.secondaryColor, width: borderWidth()),
              borderRadius: BorderRadius.circular(context.lowValue),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.customGreyColor, width: borderWidth()),
              borderRadius: BorderRadius.circular(context.lowValue),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.secondaryColor, width: borderWidth()),
              borderRadius: BorderRadius.circular(context.lowValue),
            ),
            errorStyle: ThemeValueExtension.subtitle3
                .copyWith(color: CustomColors.errorColor),
            hintText: widget.hintText,
            isCollapsed: true,
            prefixIcon: widget.iconData,
            suffixIcon: widget.suffixData != null
                ? widget.suffixData!
                : widget.visibleStatus != null
                    ? IconButton(
                        onPressed: () {
                          widget.visibleStatus = !widget.visibleStatus!;
                          setState(() {});
                        },
                        icon: Icon(widget.visibleStatus!
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )
                    : null,
            hintStyle: widget.hintStyle ?? ThemeValueExtension.subtitle.copyWith(
              color: CustomColors.customGreyColor
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: context.normalValue, horizontal: context.lowValue)),
      ),
    );
  }

  double borderWidth() => 1.5;
}
