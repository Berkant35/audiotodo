import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/theme/custom_colors.dart';

class BottomMiddleFab extends ConsumerWidget {
  const BottomMiddleFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const mainIndex = 1;

    return Container(
      decoration: BoxDecoration(
         // FAB'in rengi
        borderRadius: BorderRadius.circular(15.h), // FAB'in şekli
        border: Border.all(
          color: CustomColors.secondaryColor,
          width: 1.0,
        ),
      ),
      child: FloatingActionButton(

        onPressed: () =>
            ref.read(currentNavigationIndex.notifier).changeState(mainIndex),
        backgroundColor: ref.watch(currentNavigationIndex) == mainIndex
            ? CustomColors.accentColor
            : CustomColors.fillWhiteColor,
        elevation: 1,
        child: Icon(
          Icons.mic,
          size: 4.h,
          color: ref.watch(currentNavigationIndex) == mainIndex
              ? CustomColors.fillWhiteColor
              : CustomColors.accentColor,
        ),
      ),
    );
  }
}
