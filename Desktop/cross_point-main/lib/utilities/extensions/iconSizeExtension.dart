import '../custom_functions.dart';

enum IconSizeExtension {
  SMALL,
  MEDIUM,
  HIGH,
  SMALLTOMEDIUM,
  MEDIUMTOHIGH,
  HUGE
}

extension IconSizeValue on IconSizeExtension {
  double get sizeValue {
    switch (this) {
      case IconSizeExtension.SMALL:
        return AllFunc.isPhone() ? 8 : 14;
      case IconSizeExtension.SMALLTOMEDIUM:
        return AllFunc.isPhone() ? 12 : 18;
      case IconSizeExtension.MEDIUM:
        return AllFunc.isPhone() ? 18 : 24;
      case IconSizeExtension.MEDIUMTOHIGH:
        return AllFunc.isPhone() ? 22 : 28;
      case IconSizeExtension.HIGH:
        return AllFunc.isPhone() ? 30 : 38;
      case IconSizeExtension.HUGE:
        return AllFunc.isPhone() ? 128 : 155;
      default:
        throw Exception('NOT VALİD FONT SİZE');
    }
  }
}
