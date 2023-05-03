import 'package:flutter/material.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';

import '../constants/extension/context_extensions.dart';
import 'input_form_field.dart';

class RowFormField extends StatefulWidget {
  final String headerName;
  final String? hintText;
  final TextEditingController editingController;
  final bool? visibleStatus;
  final bool? canEdit;
  final TextInputType? inputType;
  final int? maxLines;
  final int? maxLength;
  final TextAlign? textAlign;
  final String? Function(String? value) custValidateFunction;
  final String? Function(String? value)? customOnChanged;

  const RowFormField(
      {Key? key,
      required this.headerName,
      required this.editingController,
      required this.custValidateFunction,
      this.visibleStatus,
      this.canEdit,
      this.inputType,
      this.textAlign,
      this.hintText,
      this.customOnChanged,
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
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text(
            widget.headerName,
            style: ThemeValueExtension.subtitle,
          ),
        ),
        CustomFormField(
          authEditingFormController: widget.editingController,
          validateFunction: widget.custValidateFunction,
          visibleStatus: widget.visibleStatus,
          inputType: widget.inputType,
          maxLines: widget.maxLines,
          textAlign: widget.textAlign,
          maxLength: widget.maxLength,
          hintText: widget.hintText,
          customOnChanged: widget.customOnChanged,
          canEdit: widget.canEdit,
        ),
      ],
    );
  }

  String? name(value) =>
            value != "" ? null : "Bu alan boş bırakılamaz";
}
