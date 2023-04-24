import 'dart:ui';

import '../utils/pad_consts.dart';

class SidesColorsModel {
  final Color? tr, tl, br, bl;

  Color get anyValidColor {
    if (tr != null) return tr!;
    if (tl != null) return tl!;
    if (br != null) return br!;
    if (bl != null) return bl!;
    return const Color(0x00000000);
  }

  /// when we want to send a signal to keep the colors the same,
  /// usually used for `isCommand`
  final bool same;

  const SidesColorsModel({
    this.tr,
    this.tl,
    this.br,
    this.bl,
    this.same = false,
  });

  factory SidesColorsModel.off() {
    const offColor = Color(0xFF000000);
    return const SidesColorsModel(
        tr: offColor, tl: offColor, br: offColor, bl: offColor);
  }

  factory SidesColorsModel.all(Color clr) {
    return SidesColorsModel(tr: clr, tl: clr, br: clr, bl: clr);
  }

  factory SidesColorsModel.all100(SidesColorsColor clr) {
    return SidesColorsModel.from100Colors(tr: clr, tl: clr, br: clr, bl: clr);
  }

  factory SidesColorsModel.same() {
    return const SidesColorsModel(same: true);
  }

  factory SidesColorsModel.from100Colors({
    SidesColorsColor? tr,
    SidesColorsColor? tl,
    SidesColorsColor? br,
    SidesColorsColor? bl,
  }) {
    return SidesColorsModel(
      tr: tr?.to255Color(),
      tl: tl?.to255Color(),
      br: br?.to255Color(),
      bl: bl?.to255Color(),
    );
  }

  /// this is a simulator parser
  /// we're gonna recieve something like `c1/c2/c3/c4`
  /// and each color is a string that is like `r/g/b`
  /// where rgb are between 0 and 255
  factory SidesColorsModel.fromString(String st) {
    final sp = st.split(defaultSeperator);

    int g = 0;

    return SidesColorsModel(
      tr: SidesColorsColor.fromString(sp[g++]).toColor(),
      tl: SidesColorsColor.fromString(sp[g++]).toColor(),
      br: SidesColorsColor.fromString(sp[g++]).toColor(),
      bl: SidesColorsColor.fromString(sp[g++]).toColor(),


    );
  }

  String colorOrNull(Color? c) {
    // if empty we should send '-1/-1/-1'
    if (c == null) {
      return List.generate(3, (index) => defaultEmptyValue)
          .join(defaultSeperator);
    }

    return [c.red, c.green, c.blue].map(colorUnitTo100).join(defaultSeperator);
  }

  int colorUnitTo100(int unit) => (unit / 255 * 100).floor();

  /// the circles take command in reverse of clockwise order
  Iterable<Color?> get clrs => [tl, bl, br, tr];

  bool colorEquals(Color? c1, Color? c2) {
    return (c1 == null && c2 == null) ||
        c1 != null &&
            c2 != null &&
            c1.red == c2.red &&
            c1.green == c2.green &&
            c1.blue == c2.blue;
  }

  /// if true, we will send from the `all` characteristic
  bool get allColorsSame => same || clrs.every((c) => colorEquals(c, tl));

  /// filter is between 0 and 1,
  /// we multiply each color value we have by the filter
  SidesColorsModel opacity(double filter) {
    Color? withFilter(Color? c) {
      if (c == null) {
        return null;
      }

      return Color.fromARGB(
        c.alpha,
        (c.red * filter).floor(),
        (c.green * filter).floor(),
        (c.blue * filter).floor(),
      );
    }

    return SidesColorsModel(
      tr: withFilter(tr),
      tl: withFilter(tl),
      br: withFilter(br),
      bl: withFilter(bl),
    );
  }

  @override
  String toString() {
    /// if all same we send data as 'r/g/b'
    /// (as we're gonna send them from the `all` characteristic)
    /// else, we send each circle seperate like 'r1/g1/b1/r2/g2/b2/r3/g3/b3'
    return allColorsSame
        ? colorOrNull(clrs.elementAt(0))
        : clrs.map(colorOrNull).join(defaultSeperator);
  }

  SidesColorsModel copyWith({
    Color? tr,
    Color? tl,
    Color? br,
    Color? bl,
  }) {
    return SidesColorsModel(
      tr: tr ?? this.tr,
      tl: tl ?? this.tl,
      br: br ?? this.br,
      bl: bl ?? this.bl,
    );
  }
}

/// the range of r g b here are 0-100
class SidesColorsColor {
  int r, g, b;

  SidesColorsColor(
      this.r,
      this.g,
      this.b,
      );

  Color toColor() {
    return Color.fromARGB(255, r, g, b);
  }

  Color to255Color() {
    int r1 = r, g1 = g, b1 = b;
    r = (r / 100 * 255).floor();
    g = (g / 100 * 255).floor();
    b = (b / 100 * 255).floor();

    final out = toColor();

    r = r1;
    g = g1;
    b = b1;

    return out;
  }

  factory SidesColorsColor.fromString(String st) {
    return SidesColorsColor.fromList(st.split(','));
  }

  /// this is a simulator parser
  /// we're gonna recieve something like `100/100/100`
  factory SidesColorsColor.fromList(List<String> chars) {
    return SidesColorsColor(
      int.parse(chars[0]),
      int.parse(chars[1]),
      int.parse(chars[2]),
    );
  }
}
