import 'package:flutter/material.dart';
import 'package:kumas_topu/utilities/components/seperate_padding.dart';

import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';
import 'input_form_field.dart';

class RowFormField extends StatefulWidget {
  final String headerName;
  final String? hintText;
  final TextEditingController editingController;
  final bool? visibleStatus;
  final bool? canEdit;
  final IconData? prefixIcon;
  final TextInputType? inputType;
  final double? verticalContentPadding;
  final int? maxLines;
  final int? maxLength;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;
  final String? Function(String? value) custValidateFunction;
  final String? Function(String? value)? onChanged;

  const RowFormField(
      {Key? key,
      required this.headerName,
      required this.editingController,
      required this.custValidateFunction,
      this.visibleStatus,
      this.onChanged,
      this.padding,
      this.prefixIcon,
      this.canEdit,
      this.inputType,
      this.textAlign,
      this.hintText,
      this.verticalContentPadding,
      this.maxLines,
      this.maxLength})
      : super(key: key);

  @override
  State<RowFormField> createState() => _RowFormFieldState();
}

class _RowFormFieldState extends State<RowFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (widget.headerName != "") ? Padding(
          padding: widget.padding == null ? seperatePadding() : widget.padding!,
          child: Text(
            widget.headerName,
            style: ThemeValueExtension.subtitle,
          ),
        ) : const SizedBox(),
        CustomFormField(
          authEditingFormController: widget.editingController,
          validateFunction: widget.custValidateFunction,
          onChanged: widget.onChanged,
          visibleStatus: widget.visibleStatus,
          inputType: widget.inputType,
          maxLines: widget.maxLines,
          textAlign: widget.textAlign,
          maxLength: widget.maxLength,

          hintText: widget.hintText,
          verticialContentPadding: widget.verticalContentPadding,
          iconData: Icon(
            widget.prefixIcon,
            color: CustomColors.primaryColor,
          ),
        ),
      ],
    );
  }

  String? name(value) => value != "" ? null : "Bu alan boş bırakılamaz";
}
