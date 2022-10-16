enum EdgeExtension {
  lowEdge,
  normalEdge,
  mediumEdge,
  highEdge,
  hugeEdge,
  mediumtoHighEdge
}

extension EdgeValueExtension on EdgeExtension {
  double get edgeValue {
    switch (this) {
      case EdgeExtension.lowEdge:
        return 8;
      case EdgeExtension.normalEdge:
        return 15;
      case EdgeExtension.mediumEdge:
        return 22;
      case EdgeExtension.mediumtoHighEdge:
        return 28;
      case EdgeExtension.highEdge:
        return 36;
      case EdgeExtension.hugeEdge:
        return 42;
      default:
        throw Exception("NOT VALİD FONT SİZE");
    }
  }
}
