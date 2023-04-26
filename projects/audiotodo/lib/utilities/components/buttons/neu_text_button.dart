import 'package:audiotodo/utilities/constants/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/theme/custom_colors.dart';
import 'neu_button_configs.dart';

class NeuTextButton extends ConsumerWidget {
  final bool isPrimaryButton;
  final String text;
  final VoidCallback onPressed;
  const NeuTextButton(
      {Key? key, this.isPrimaryButton = false, required this.text,required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: NeuButtonConfigs.neuTextButtonWidth,
      height: NeuButtonConfigs.neuTextButtonHeight,
      child: NeumorphicButton(
        minDistance: NeuButtonConfigs.neuTextButtonMinDistance,
        style: neuTextButtonNeuStyle(),
        onPressed: onPressed,
        child: Center(
          child: neuTextButtonTextWidget(),
        ),
      ),
    );
  }

  NeumorphicStyle neuTextButtonNeuStyle() => NeumorphicStyle(
      color: isPrimaryButton
          ? CustomColors.fillWhiteColor
          : CustomColors.secondaryColor,
      shadowLightColor: CustomColors.fillBlackElevationColor,
      intensity: NeuButtonConfigs.neuTextButtonIntensity
  );

  Text neuTextButtonTextWidget() {
    return Text(
      text,
      style: ThemeValueExtension.buttonTextStyle.copyWith(
          color: isPrimaryButton
              ? CustomColors.primaryColor
              : CustomColors.fillWhiteColor),
    );
  }
}
