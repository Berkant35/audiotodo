import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constants/extensions/icon_size_extensions.dart';

class NeuButtonConfigs {
  //NeuTextButton
  static double neuTextButtonMinDistance = NeuMinDistanceExtension.normalDeep;
  static double neuTextButtonIntensity = NeuIntensityExtension.normalIntensity;
  static double neuTextButtonWidth = 65.w;
  static double neuTextButtonHeight = 8.h;

  //NeuMiniIconButton
  static double neuMiniIconButtonMinDistance = NeuMinDistanceExtension.hugeDeep;
  static double neuMiniIconButtonIntensity = NeuIntensityExtension.miniIntensity;
  static double neuMiniIconButtonWidth = 12.w;
  static double neuMiniIconButtonHeight = 12.h;
  static double neuMiniIconSize = IconSizeExtension.medium.sizeValue;
}

extension NeuIntensityExtension on double {
  static double get miniIntensity => 0.25;

  static double get normalIntensity => 0.525;

  static double get hugeIntensity => 0.915;
}

extension NeuMinDistanceExtension on double {
  static double get miniDeep => -1;

  static double get normalDeep => -2;

  static double get hugeDeep => -5;
}
