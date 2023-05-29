import 'package:audiotodo/utilities/components/drawer/profil_drawer.dart';
import 'package:audiotodo/utilities/constants/extensions/icon_size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../core/theme/custom_colors.dart';
import '../../generated/l10n.dart';
import '../../utilities/components/containers/custom_bar_container.dart';

class Profil extends ConsumerStatefulWidget {
  const Profil({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProfilState();
}

class _ProfilState extends ConsumerState<Profil> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const ProfileDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Center(child: CustomBarContainer(text: S.current.profil))),
          Expanded(
              flex: 13,
              child: Container(
                width: 100.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () => _key.currentState!.openDrawer(),
                          icon: Icon(
                            Icons.menu,
                            size: IconSizeExtension.medium.sizeValue,
                          ))
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
