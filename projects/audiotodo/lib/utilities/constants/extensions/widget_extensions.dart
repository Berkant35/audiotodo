



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension AppBarExtension on AppBar{
  static AppBar get noneAppBar => AppBar(
    toolbarHeight: 0,
    elevation: 0,
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );


}