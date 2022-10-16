import 'package:sizer/sizer.dart';

enum FontSizeDegerler {
  tiny,
  tinyToLowSize,
  lowFontSize,
  lowToNormalFontSize,
  normalFontSize,
  mediumFontSize,
  highFontSize,
  hugeFontSize,
  mediumtoHighFontSize,
  normalToMediumFontSize
}

extension FontSizeExtension on FontSizeDegerler {
  double get fontDeger {
    switch (this) {
      case FontSizeDegerler.tiny:
        return 7.sp;
      case FontSizeDegerler.tinyToLowSize:
        return 9.sp;
      case FontSizeDegerler.lowFontSize:
        return 12.sp;
      case FontSizeDegerler.lowToNormalFontSize:
        return 14.sp;
      case FontSizeDegerler.normalFontSize:
        return 16.sp;
      case FontSizeDegerler.normalToMediumFontSize:
        return 18.sp;
      case FontSizeDegerler.mediumFontSize:
        return 21.sp;
      case FontSizeDegerler.mediumtoHighFontSize:
        return 24.sp;
      case FontSizeDegerler.highFontSize:
        return 32.sp;
      case FontSizeDegerler.hugeFontSize:
        return 64.sp;
      default:
        throw Exception('NOT VALİD FONT SİZE');
    }
  }
}
