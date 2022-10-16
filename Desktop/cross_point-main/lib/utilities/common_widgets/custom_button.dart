import 'package:flutter/material.dart';


import '../extensions/EdgeExtension.dart';
import '../extensions/elevation_extension.dart';


// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  OutlinedBorder? outBorder;
  Color? primaryColor;
  Color? onPrimaryColor;
  TextStyle? textStyle;
  double? width;
  double? height;
  Function onPressed;
  Widget? inButtonWidget;

  CustomElevatedButton(
      {Key? key, required this.onPressed,
        this.height,
        this.width,
        this.outBorder,
        this.primaryColor,
        this.onPrimaryColor,
        this.textStyle,
        this.inButtonWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: EdgeExtension.lowEdge.edgeValue),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: ElevationExtensions.none.elevateValue,
            shape: outBorder,
            primary: primaryColor,
            onPrimary: onPrimaryColor,
            textStyle: textStyle,
          ),
          onPressed: onPressed as void Function()?,
          child: inButtonWidget,
        ),
      ),
    );
  }
}
