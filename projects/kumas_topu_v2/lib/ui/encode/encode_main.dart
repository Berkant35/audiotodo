import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/ui/encode/select_standart.dart';
import 'package:kumas_topu/utilities/components/custom_svg.dart';
import 'package:kumas_topu/utilities/components/title_app_bar.dart';
import 'package:kumas_topu/utilities/constants/app/enums.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_constants.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../line/global_providers.dart';

import '../../utilities/constants/extension/image_path.dart';
import 'current_barcode_info.dart';

class EncodeMain extends ConsumerStatefulWidget {
  const EncodeMain({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EncodeMainState();
}

class _EncodeMainState extends ConsumerState<EncodeMain> {
  @override
  void initState() {
    super.initState();
    barcodeModeOn(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        label: "Kodlama",
        leadingWidget: IconButton(
          icon: Icon(Icons.arrow_back, size: 4.h),
          onPressed: () {
            NavigationService.instance
                .navigateToPageClear(path: NavigationConstants.mainPage);
          },
        ),
      ),
      body: ref.watch(stateManagerProvider) != LoadingStates.loading
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomSvg(
                      imagepath: ImagePath.scanSvg,
                      width: 30.w,
                    ),
                    const SelectStandart(),
                    const CurrentBarcodeInfo()
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }

  Future<void> barcodeModeOn(WidgetRef ref) async {
    ref
        .read(currentTriggerModeProvider.notifier)
        .nativeManager
        .scanBarcode(ref, false);
  }
}
