enum maxLengthWordExtension { little, some, enough, much, tooMuch }

extension MaxLengthExtension on maxLengthWordExtension {
  int get maxLengthValue {
    switch (this) {
      case maxLengthWordExtension.little:
        return 18;
      case maxLengthWordExtension.some:
        return 23;
      case maxLengthWordExtension.enough:
        return 40;
      case maxLengthWordExtension.much:
        return 100;
      case maxLengthWordExtension.tooMuch:
        return 140;
      default:
        throw Exception('Böyle bir Length yok');
    }
  }
}
