import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AllFunc {
  static String nextFifteenYear(DateTime dateTime) {
    StringBuffer buffer = StringBuffer();
    if (dateTime.day < 10) {
      buffer.write("0");
      buffer.write(dateTime.day.toString());
    } else {
      buffer.write(dateTime.day.toString());
    }
    buffer.write("-");
    if (dateTime.month < 10) {
      buffer.write("0");
      buffer.write(dateTime.month.toString());
    } else {
      buffer.write(dateTime.month.toString());
    }
    buffer.write("-");
    buffer.write((dateTime.year + 15).toString());

    return buffer.toString();
  }

  static String getWordOfSeatBussiniess(int rowIndex) {
    switch (rowIndex) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return '';
      case 3:
        return 'C';
      case 4:
        return 'D';
      case 5:
        return '';
      case 6:
        return 'E';
      case 7:
        return 'F';
      default:
        return '';
    }
  }

  String getWordOfSeatWideLongEconomy(int rowIndex) {
    switch (rowIndex) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return '';
      case 3:
        return 'D';
      case 4:
        return 'E';
      case 5:
        return '';
      case 6:
        return 'G';
      case 7:
        return 'K';
      case 8:
        return 'L';
      case 9:
        return 'L';
      case 10:
        return 'M';
      default:
        return '';
    }
  }

  static bool isPhone() {
    bool isPhone;

    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;

    final double width = size.width;
    final double height = size.height;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isPhone = false;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isPhone = false;
    } else {
      isPhone = true;
    }

    return isPhone;
  }

  MaterialColor getLoaColor(String exp, DateTime now) {
    DateTime dateTime = DateTime.parse(exp);

    if (now.millisecondsSinceEpoch > dateTime.millisecondsSinceEpoch) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
