import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/theme/custom_colors.dart';
import '../../../generated/l10n.dart';
import '../../constants/extensions/context_extension.dart';

class CustomBottomNavigationBar extends ConsumerStatefulWidget {
  const CustomBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends ConsumerState<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: CustomColors.primaryColor,
        selectedItemColor: CustomColors.accentColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.white,
        unselectedLabelStyle: ThemeValueExtension.subtitle3.copyWith(
            fontWeight: FontWeight.w500, color: CustomColors.fillWhiteColor),
        selectedLabelStyle: ThemeValueExtension.subtitle3.copyWith(
            fontWeight: FontWeight.bold, color: CustomColors.accentColor),
        currentIndex: ref.watch(currentNavigationIndex),
        onTap: changeState,
        items: items(),
      ),
    );
  }

  void changeState(value) =>
      ref.read(currentNavigationIndex.notifier).changeState(value);

  List<BottomNavigationBarItem> items() {
    return [
      bottomNavigationBarItem(Icons.person, S.current.profil, 0),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.5.h),
            child: Icon(
              Icons.abc_outlined,
              color: Colors.transparent,
              size: 4.h,
            ),
          ),
          label: ''),
      bottomNavigationBarItem(Icons.list, S.current.todo, 2),
    ];
  }

  BottomNavigationBarItem bottomNavigationBarItem(
      IconData iconData, String label, int currentIndex) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: Icon(
            iconData,
            size: 4.h,
            color: currentIndex == ref.watch(currentNavigationIndex)
                ? CustomColors.accentColor
                : CustomColors.fillWhiteColor,
          ),
        ),
        label: label);
  }
}
