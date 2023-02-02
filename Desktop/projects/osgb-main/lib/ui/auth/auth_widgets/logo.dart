

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../utilities/constants/app/assets.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border:
          Border.all(color: const Color(0xff1A8CC0), width: 0.8)),
      child: Center(
          child: Image.asset(
            Assets.logoPNG,
            fit: BoxFit.contain,
            width: 40.w,
            height: 40.w,
          )),
    );
  }
}
