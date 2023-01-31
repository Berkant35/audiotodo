import 'package:flutter/material.dart';
import 'package:kumas_topu/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TitleAppBar extends AppBar {
  final String label;
  final Widget? leadingWidget;
  final Function? onTap;
  TitleAppBar({super.key, required this.label, this.leadingWidget,required this.onTap})
      : super(
          title: InkWell(
              onTap: onTap as void Function()?,
              child: Text(label, style: ThemeValueExtension.headline6)),
          leadingWidth: 8.w,
          leading: leadingWidget,
        );
}
