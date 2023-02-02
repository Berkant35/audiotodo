import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../utilities/components/input_form_field.dart';
import '../../../utilities/constants/extension/context_extensions.dart';

class RowFormField extends ConsumerWidget {
  final TextEditingController editingController;
  final String headerName;
  final bool? visibleStatus;

  const RowFormField(
      {Key? key,
      required this.editingController,
      required this.headerName,
      this.visibleStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return rowFormField(headerName, editingController, visibleStatus);
  }

  Column rowFormField(String headerName,
      TextEditingController editingController, bool? visibleStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: seperatePadding(),
          child: Text(
            headerName,
            style: ThemeValueExtension.subtitle,
          ),
        ),
        CustomFormField(
          authEditingFormController: editingController,
          validateFunction: (value) => value != "" ? null : cannotBlank(),
          visibleStatus: visibleStatus,
        ),
      ],
    );
  }

  String cannotBlank() => "Bu alan boş bırakılamaz";

  EdgeInsets seperatePadding() =>
      EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w);
}
