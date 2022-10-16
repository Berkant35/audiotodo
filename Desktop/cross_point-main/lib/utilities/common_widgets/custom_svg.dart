import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvg extends StatelessWidget {
  final String imagepath;
  final int? customFlex;
  final BoxFit? customBoxFit;
  final double? height;
  final double? width;
  final Color? iconColor;

  const CustomSvg(
      {Key? key,
      required this.imagepath,
      this.customFlex,
      this.customBoxFit,
      this.width,
      this.iconColor,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagepath,
      fit: customBoxFit == null ? BoxFit.fill : customBoxFit!,
      height: height,
      width: width,
      color: iconColor,
    );
  }
}
