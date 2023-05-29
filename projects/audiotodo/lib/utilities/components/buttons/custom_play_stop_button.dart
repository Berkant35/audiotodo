import 'package:audiotodo/utilities/components/buttons/play_stop_button.dart';
import 'package:audiotodo/utilities/constants/extensions/edge_extension.dart';
import 'package:audiotodo/utilities/constants/extensions/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/theme/custom_colors.dart';

class CustomPlayStopButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final double? circleRadius;
  final double iconSize;

  const CustomPlayStopButton(
      {Key? key,
      required this.onPressed,
      this.circleRadius,
      required this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: circleRadius ?? 35.w,
      height: circleRadius ?? 35.w,
      decoration: CustomBoxDecoration.circleContainerDecoration.copyWith(
          color: CustomColors.fillWhiteColor,
          border: Border.all(color: CustomColors.fillWhiteColor, width: 1.75)),
      child: Container(
        decoration: CustomBoxDecoration.circleContainerDecoration.copyWith(
          color: CustomColors.primaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(EdgeExtension.customTiny1.edgeValue),
          child: PlayStopButton(
            onPressed: onPressed,
            iconSize: iconSize,
          ),
        ),
      ),
    );
  }
}
