enum BorderThickness { lowThickness, mediumThickness, highThickness }

extension BorderThicknessExtension on BorderThickness {
  double get borderThickValue {
    switch (this) {
      case BorderThickness.lowThickness:
        return 0.5;
      case BorderThickness.mediumThickness:
        return 1.0;
      case BorderThickness.highThickness:
        return 3.0;
      default:
        throw Exception('Bu kalınlıkta bir border yok');
    }
  }
}
