import 'package:audiotodo/utilities/components/bars/app_bars/content_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../utilities/components/containers/custom_bar_container.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: CustomBarContainer(
                text: S.current.sign_up,
              ),
            ),
            const Spacer(
              flex: 14,
            )
          ],
        ),
      ),
    );
  }
}
