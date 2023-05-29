import 'package:audiotodo/utilities/constants/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/theme/custom_colors.dart';
import '../../../generated/l10n.dart';
import '../../../line/viewmodel/global_providers.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: CustomColors.fillWhiteColor,
      child: Column(
        children: [
          headerOfDrawer(ref),
          contentsOfDrawer(ref),
        ],
      ),
    );
  }

  Expanded contentsOfDrawer(WidgetRef ref) {
    return Expanded(
        flex: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => ref.read(authManager.notifier).signOut(),
                  child: Text(
                    S.current.sign_out,
                    style: ThemeValueExtension.subtitle
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 4.h,
              )
            ],
          ),
        ));
  }

  Expanded headerOfDrawer(WidgetRef ref) {
    return Expanded(
        flex: 3,
        child: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            headerContent(ref)
          ],
        ));
  }

  Expanded headerContent(WidgetRef ref) {
    return Expanded(
        flex: 8,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref.read(authManager)?.userName ?? "-",
                  style: ThemeValueExtension.headline6,
                )
              ],
            ),
          ),
        ));
  }
}
