

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/theme/custom_colors.dart';
import 'divider_configs.dart';

class LoginDivider extends ConsumerWidget {
  const LoginDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Divider(
      height: 4.h,
      endIndent: DividerConfigs.loginEndDivider,
      indent: DividerConfigs.loginIndentDivider,
      thickness: DividerConfigs.thickness,
      color: CustomColors.grey2Color
    );
  }
}
