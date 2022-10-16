import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/common_widgets/custom_svg.dart';
import '../../../utilities/extensions/EdgeExtension.dart';
import '../../../utilities/extensions/font_theme.dart';

class PerItemOfMenu extends ConsumerWidget {
  final String imagePath;
  final String title;
  final Function()? onTap;
  const PerItemOfMenu(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.onTap})
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
                Text(
                  title,
                  style: ThemeValueExtension.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1

                  ),
                  textAlign: TextAlign.center,
                ),
                CustomSvg(
                  imagepath: imagePath,
                  width: context.mediumtoHighValue,
                  height: context.mediumtoHighValue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
