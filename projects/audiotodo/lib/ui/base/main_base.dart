import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/main.dart';
import 'package:audiotodo/ui/base/audiotodo_page.dart';
import 'package:audiotodo/ui/base/plans.dart';
import 'package:audiotodo/ui/base/profil.dart';

import 'package:audiotodo/utilities/components/bars/custom_button_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/components/fabs/bottom_middle_fab.dart';
import '../../utilities/constants/extensions/widget_extensions.dart';

class MainBase extends ConsumerStatefulWidget {
  const MainBase({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MainBaseState();
}

class _MainBaseState extends ConsumerState<MainBase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const BottomMiddleFab(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: showPage(ref.watch(currentNavigationIndex)),
      ),
    );
  }

  showPage(int selectedItemPosition) {
    switch (selectedItemPosition) {
      case 0:
        return const Profil();
      case 1:
        return const AudioToDoPage();
      case 2:
        return const Plans();
      default:
        return const SizedBox.shrink();
    }
  }
}
