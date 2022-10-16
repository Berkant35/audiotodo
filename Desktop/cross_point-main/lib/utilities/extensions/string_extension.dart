extension ImagePathExtension on String {
  String get toSvg => 'assets/svg/$this.svg';

  String get toPng => 'assets/png/$this.png';

  String get toJPEG => 'assets/jpeg/$this.jpeg';
}

extension GuvenliMi on String {
  String get guvenli => 'Guvenli';
}
