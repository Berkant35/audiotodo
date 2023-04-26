import 'package:audiotodo/utilities/constants/extensions/edge_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/theme/custom_colors.dart';
import '../../constants/extensions/context_extension.dart';
import '../buttons/neu_button_configs.dart';

class CustomBarContainer extends ConsumerWidget {
  final bool isPrimaryContainer;
  final String text;

  const CustomBarContainer(
      {Key? key, this.isPrimaryContainer = false, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Neumorphic(
      style: NeumorphicStyle(

          boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)))),
      child: Container(
        height: 10.h,
        width: 65.w,
        decoration: BoxDecoration(
            color: isPrimaryContainer
                ? CustomColors.primaryColor
                : CustomColors.fillWhiteColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(EdgeExtension.hugeEdge.edgeValue),
              bottomRight: Radius.circular(EdgeExtension.hugeEdge.edgeValue),
            )),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(text,
                style: ThemeValueExtension.headline1.copyWith(
                  color: isPrimaryContainer
                      ? CustomColors.fillWhiteColor
                      : CustomColors.primaryColor,
                ))),
      ),
    );
  }
}
