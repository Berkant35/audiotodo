import 'package:flutter/material.dart';

import '../../../core/theme/custom_colors.dart';
import 'edge_extension.dart';

extension CustomBoxDecoration on BoxDecoration {
  static BoxDecoration get customType1BoxDecoration => BoxDecoration(
      color: Colors.white,
      boxShadow: CustomBoxShadows.customBoxShadowListType1,
      borderRadius: CustomBorder.allHighRadius);

  static BoxDecoration get customType2BoxDecoration => BoxDecoration(
      color: CustomColors.primaryColor,
      boxShadow: CustomBoxShadows.customBoxShadowListType1,
      borderRadius: CustomBorder.onlyBottomHugeRadius);

  static BoxDecoration get customType3BoxDecoration => BoxDecoration(
      color: CustomColors.backGreyColor.withOpacity(0.3),
      boxShadow: CustomBoxShadows.customBoxShadowListType3,
      borderRadius: CustomBorder.onlyBottomHugeRadius);

  static BoxDecoration get circleContainerDecoration => BoxDecoration(
      shape: BoxShape.circle,
      color: CustomColors.fillWhiteColor,
      boxShadow: CustomBoxShadows.customBoxShadowListType2,
     );
}

extension CustomRadius on Radius {
  static Radius get lowRadius =>
      Radius.circular(EdgeExtension.normalEdge.edgeValue);

  static Radius get mediumRadius =>
      Radius.circular(EdgeExtension.mediumEdge.edgeValue);

  static Radius get highRadius =>
      Radius.circular(EdgeExtension.highEdge.edgeValue);

  static Radius get hugeRadius =>
      Radius.circular(EdgeExtension.hugeEdge.edgeValue);
}

extension CustomBorder on BorderRadius {
  static BorderRadius get onlyBottomHighRadius => BorderRadius.only(
      bottomRight: CustomRadius.highRadius,
      bottomLeft: CustomRadius.highRadius);

  static BorderRadius get onlyBottomHugeRadius => BorderRadius.only(
      bottomRight: CustomRadius.hugeRadius,
      bottomLeft: CustomRadius.hugeRadius);


  static BorderRadius get allHighRadius =>
      BorderRadius.all(CustomRadius.highRadius);
}

extension CustomBoxShadows on BoxShadow {
  static BoxShadow get customType1BoxShadow => BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3),
      );
  static BoxShadow get customType2BoxShadow => BoxShadow(
    color: CustomColors.primaryColor.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  static BoxShadow get customType3BoxShadow => BoxShadow(
    color: CustomColors.backGreyColor,
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  static List<BoxShadow>? get customBoxShadowListType1 =>
      [customType1BoxShadow];

  static List<BoxShadow>? get customBoxShadowListType2 =>
      [customType2BoxShadow];

  static List<BoxShadow>? get customBoxShadowListType3 =>
      [customType3BoxShadow];
}
