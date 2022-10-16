import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dialogs {
  static void showSuccess(String title) {
    Fluttertoast.showToast(msg: title, backgroundColor: Colors.greenAccent);
  }

  static void showFailed(String title) {
    Fluttertoast.showToast(msg: title, backgroundColor: Colors.red);
  }
}
