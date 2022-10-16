enum ImageQualityExtension {
  lowImageQuality,
  normalImageQuality,
  mediumImageQuality,
  mediumtoHighImageQuality,
  highImageQuality
}

extension ImageQualityExtensionValues on ImageQualityExtension {
  int get imageQuality {
    switch (this) {
      case ImageQualityExtension.lowImageQuality:
        return 10;
      case ImageQualityExtension.normalImageQuality:
        return 25;
      case ImageQualityExtension.mediumImageQuality:
        return 50;
      case ImageQualityExtension.mediumtoHighImageQuality:
        return 75;
      case ImageQualityExtension.highImageQuality:
        return 100;
      default:
        throw Exception('NOT VALİD Quality');
    }
  }
}
