import 'package:catchpad_flutter_lib/src/models/sides_colors_model.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  const testMdl = SidesColorsModel();
  group(
    'SidesColorsModel',
    () {
      test(
        'should convert max 255 color unit value to max 100',
        () {
          expect(testMdl.colorUnitTo100(255), 100);
          expect(testMdl.colorUnitTo100(200), 78);
          expect(testMdl.colorUnitTo100(0), 0);
        },
      );
      test(
        'the empty format is correct',
        () {
          expect(
            const SidesColorsModel().toString(),
            '-1/-1/-1',
          );
        },
      );
      test(
        'the off factory works',
        () {
          expect(
            SidesColorsModel.off().toString(),
            '0/0/0',
          );
        },
      );
      test(
        'the all factory works',
        () {
          const clr1 = Color.fromARGB(255, 255, 0, 0);
          const clr2 = Color.fromARGB(255, 100, 200, 150);
          expect(
            SidesColorsModel.all(clr1).toString(),
            '100/0/0',
          );
          expect(
            SidesColorsModel.all(clr2).toString(),
            '39/78/58',
          );
        },
      );
      test(
        'default constructor works',
        () {
          const clr1 = Color.fromARGB(255, 48, 217, 79); // 18/85/30
          const clr2 = Color.fromARGB(255, 154, 21, 99); // 60/8/38
          const clr3 = Color.fromARGB(255, 66, 87, 174); // 25/34/68
          const clr4 = Color.fromARGB(255, 150, 154, 21); // 58/60/8
          expect(
            const SidesColorsModel(tr: clr1, tl: clr2, br: clr3, bl: clr4)
                .toString(),
            // as circles take command in reverse of clockwise order,
            // so, tl/bl/br/tr

            '60/8/38/'
            '58/60/8/'
            '25/34/68/'
            '18/85/30',
          );
        },
      );
      test(
        'the `same` constructor works',
        () {
          expect(
            SidesColorsModel.same().toString(),
            '-1/-1/-1',
          );
        },
      );
      test(
        'opacity works',
        () {
          const clr1 = Color.fromARGB(
              255, 48, 217, 79); // *0.5 = 24/108/39 // to 100: 9/42/15
          const clr2 = Color.fromARGB(
              255, 154, 21, 99); // *0.5 = 77/10/49 // to 100: 30/3/19
          const clr3 = Color.fromARGB(
              255, 66, 87, 174); // *0.5 = 33/43/87 // to 100: 12/16/34
          const clr4 = Color.fromARGB(
              255, 150, 154, 21); //*0.5 =  75/77/10 // to 100: 29/30/3
          const model = SidesColorsModel(
            tr: clr1,
            tl: clr2,
            br: clr3,
            bl: clr4,
          );

          final half = model.opacity(0.5);

          expect(
            half.toString(),
            '30/3/19/'
            '29/30/3/'
            '12/16/34/'
            '9/42/15',
          );
        },
      );
    },
  );
}
