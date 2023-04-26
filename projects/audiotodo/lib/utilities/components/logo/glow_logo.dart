import 'package:audiotodo/utilities/constants/extensions/icon_size_extensions.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/theme/custom_colors.dart';

class GlowLogo extends ConsumerWidget {
  const GlowLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AvatarGlow(
      startDelay: const Duration(milliseconds: 2000),
      glowColor: CustomColors.fillWhiteColor,
      endRadius: 20.h,
      duration: const Duration(milliseconds: 6000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: const Duration(seconds: 1),
      shape: BoxShape.circle,
      animate: true,
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: 30.h,
        height: 30.h,
        decoration: BoxDecoration(
            color: CustomColors.secondaryColor.withOpacity(0.75),
            borderRadius: BorderRadius.all(Radius.circular(60.h))),
        child: Center(
          child: Icon(
            Icons.mic,
            size: IconSizeExtension.huge.sizeValue,
            color: CustomColors.fillWhiteColor,
          ),
        ),
      ),
    );
  }
}
