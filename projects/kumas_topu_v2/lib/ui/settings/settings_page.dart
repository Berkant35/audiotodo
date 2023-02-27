import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/utilities/components/appbars/title_app_bar.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/constants/extension/context_extensions.dart';
import '../../utilities/init/theme/custom_colors.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final double maxValue;


  const SettingsPage({
    Key? key,
    required this.maxValue,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  double min = 0.0;


  bool isLoading = true;

  @override
  void initState() {

    ref
        .read(currentInventoryProvider.notifier)
        .nativeManager!
        .getPower()
        .then((value) {
          ref.read(currentPowerValueProvider.notifier).changeState(value);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        label: 'Ayarlar',
        onTap: () => NavigationService.instance.navigatePopUp(),
      ),
      body: isLoading != true
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Güç',
                    style: ThemeValueExtension.subtitle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        ref.watch(currentPowerValueProvider)
                            .truncate()
                            .toString(),
                        style: ThemeValueExtension.subtitle.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.orangeColor),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Text(
                        'dB',
                        style: ThemeValueExtension.subtitle
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              )),
          Slider(
            min: min,
            max: widget.maxValue,
            value: ref.watch(currentPowerValueProvider).toDouble(),
            activeColor: CustomColors.secondaryColor,
            inactiveColor: CustomColors.customGreyColor,
            onChanged: (double changedValue) {

              ref
                  .read(currentInventoryProvider.notifier)
                  .nativeManager!
                  .setPower(changedValue.toInt().toString()).then((value){
                ref.read(currentPowerValueProvider.notifier).changeState(
                    changedValue.toInt());
              });
            },
            onChangeEnd: (value) {

            },
          )
        ],
      )
          : const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
