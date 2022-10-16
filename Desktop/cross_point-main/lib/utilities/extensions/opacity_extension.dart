enum OpacityValues {
  lowOpacity,
  normalOpacity,
  mediumOpacity,
  highOpacity,
  hugeOpacity,
  mediumToHighOpacity,
  normalToMediumOpacity
}

extension OpacityExtension on OpacityValues {
  double get opacityValue {
    switch (this) {
      case OpacityValues.lowOpacity:
        return 0.9;
      case OpacityValues.normalOpacity:
        return 0.7;
      case OpacityValues.mediumOpacity:
        return 0.5;
      case OpacityValues.mediumToHighOpacity:
        return 0.3;
      case OpacityValues.highOpacity:
        return 0.2;
      case OpacityValues.hugeOpacity:
        return 0.1;
      default:
        throw Exception('NOT VALİD Opacity SİZE');
    }
  }
}
