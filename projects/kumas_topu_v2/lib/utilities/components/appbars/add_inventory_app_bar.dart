import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constants/extension/context_extensions.dart';

class AddInventoryAppBar extends AppBar {
  final String label;
  final Widget? leadingWidget;
  final Function? addAction;

  AddInventoryAppBar({super.key, required this.label, this.leadingWidget,required this.addAction})
      : super(
            title: Text(label, style: ThemeValueExtension.headline6),
            leadingWidth: 8.w,
            leading: leadingWidget,
            actions: [
              IconButton(
                  onPressed: addAction as void Function()?,
                  icon: Icon(
                    Icons.add,
                    size: 4.h,
                  ))
            ]);
}
