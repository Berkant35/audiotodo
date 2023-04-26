import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/custom_colors.dart';


enum EdgeExtension {
  tinyEdge,
  lowEdge,
  lowToNormalEdge,
  normalEdge,
  mediumEdge,
  highEdge,
  hugeEdge,
  mediumtoHighEdge
}

enum BorderGeometryExtension {
  tinyEdge,
  lowEdge,
  lowToNormalEdge,
  normalEdge,
  mediumEdge,
  highEdge,
  hugeEdge,
  mediumtoHighEdge
}

enum BoxDecorationExtensions { cardBoxDecoration, imageBoxDecoration }

extension EdgeValueExtension on EdgeExtension {
  double get edgeValue {
    switch (this) {
      case EdgeExtension.tinyEdge:
        return 6;
      case EdgeExtension.lowEdge:
        return 8;
      case EdgeExtension.lowToNormalEdge:
        return 12;
      case EdgeExtension.normalEdge:
        return 15;
      case EdgeExtension.mediumEdge:
        return 22;
      case EdgeExtension.mediumtoHighEdge:
        return 28;
      case EdgeExtension.highEdge:
        return 36;
      case EdgeExtension.hugeEdge:
        return 40;
      default:
        throw Exception('NOT VALİD FONT SİZE');
    }
  }
}



extension BorderRadiusExtension on BorderGeometryExtension {
  BorderRadiusGeometry get borderRadiusGeometryValue {
    switch (this) {
      case BorderGeometryExtension.tinyEdge:
        return BorderRadius.circular(EdgeExtension.tinyEdge.edgeValue);
      case BorderGeometryExtension.lowEdge:
        return BorderRadius.circular(EdgeExtension.lowEdge.edgeValue);
      case BorderGeometryExtension.lowToNormalEdge:
        return BorderRadius.circular(EdgeExtension.lowToNormalEdge.edgeValue);
      case BorderGeometryExtension.normalEdge:
        return BorderRadius.circular(EdgeExtension.normalEdge.edgeValue);
      case BorderGeometryExtension.mediumEdge:
        return BorderRadius.circular(EdgeExtension.mediumEdge.edgeValue);
      case BorderGeometryExtension.mediumtoHighEdge:
        return BorderRadius.circular(EdgeExtension.mediumtoHighEdge.edgeValue);
      case BorderGeometryExtension.highEdge:
        return BorderRadius.circular(EdgeExtension.highEdge.edgeValue);
      case BorderGeometryExtension.hugeEdge:
        return BorderRadius.circular(EdgeExtension.hugeEdge.edgeValue);
      default:
        throw Exception('NOT VALİD RADIUS');
    }
  }
}
