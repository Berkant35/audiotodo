import 'package:audiotodo/core/theme/custom_colors.dart';
import 'package:audiotodo/utilities/components/buttons/neu_button_configs.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class MiniNeuSquare extends StatelessWidget {
  final bool isPrimaryButton;
  final IconData iconData;
  final VoidCallback onPressed;
  const MiniNeuSquare({
    Key? key,
    this.isPrimaryButton = false,
    required this.iconData,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      minDistance: NeuButtonConfigs.neuMiniIconButtonMinDistance,
      style:  neuTextButtonNeuStyle(),
      onPressed: onPressed,
      child:  Icon(
        iconData,
        color: isPrimaryButton
            ? CustomColors.secondaryColor
            : CustomColors.fillWhiteColor,
        size: NeuButtonConfigs.neuMiniIconSize,
      ),
    );
  }
  NeumorphicStyle neuTextButtonNeuStyle() => NeumorphicStyle(
      color: isPrimaryButton
          ? CustomColors.fillWhiteColor
          : CustomColors.secondaryColor,
      shadowLightColor: CustomColors.fillBlackElevationColor,
      intensity: NeuButtonConfigs.neuMiniIconButtonIntensity
  );
}
/*
*/
