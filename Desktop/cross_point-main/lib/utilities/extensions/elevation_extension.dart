enum ElevationExtensions {
  none,
  lowElevation,
  normalElevation,
  mediumElevation,
  hugeElevation,
  mediumtoHighElevation,
  highElevation
}

extension ElevationExtensionValues on ElevationExtensions {
  double get elevateValue {
    switch (this) {
      case ElevationExtensions.none:
        return 0;
      case ElevationExtensions.lowElevation:
        return 2;
      case ElevationExtensions.normalElevation:
        return 4;
      case ElevationExtensions.mediumElevation:
        return 8;
      case ElevationExtensions.mediumtoHighElevation:
        return 12;
      case ElevationExtensions.highElevation:
        return 20;
      case ElevationExtensions.hugeElevation:
        return 30;
      default:
        throw Exception('NOT VALİD ELEVATION');
    }
  }
}
