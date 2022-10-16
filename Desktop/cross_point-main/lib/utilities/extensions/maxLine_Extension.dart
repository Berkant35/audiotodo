enum maxLineWordExtension { little, some, enough, much, tooMuch }

extension MaxLineExtension on maxLineWordExtension {
  int get maxLineValue {
    switch (this) {
      case maxLineWordExtension.little:
        return 1;
      case maxLineWordExtension.some:
        return 5;
      case maxLineWordExtension.enough:
        return 10;
      case maxLineWordExtension.much:
        return 15;
      case maxLineWordExtension.tooMuch:
        return 20;
      default:
        throw Exception('Böyle bir Length yok');
    }
  }
}
