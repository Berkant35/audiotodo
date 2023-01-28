import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/extension/context_extensions.dart';
import '../constants/extension/edge_extension.dart';
import 'custom_svg.dart';

class PerItemOfMenu extends ConsumerWidget {
  final String imagePath;
  final String title;
  final double? scaleHigh;
  final Function()? onTap;

  const PerItemOfMenu(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.onTap,
      this.scaleHigh})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(EdgeExtension.lowEdge.edgeValue),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(EdgeExtension.lowEdge.edgeValue)),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(
                      0,
                      0,
                    ),
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                    color: Colors.grey.withOpacity(0.25)),
                BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    offset: const Offset(0, 0)),
              ]),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      title,
                      style: ThemeValueExtension.headline6.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: CustomSvg(
                    imagepath: imagePath,
                    width: scaleHigh ?? context.highValue,
                    height: scaleHigh ?? context.highValue,
                    customBoxFit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
