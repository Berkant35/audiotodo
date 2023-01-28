import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/utilities/components/seperate_padding.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/constants/extension/context_extensions.dart';
import '../../utilities/init/theme/custom_colors.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  static const min = 0.0;
  static const max = 30.0;
  double currentValue = 15;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar",
            style: ThemeValueExtension.subtitle),
        automaticallyImplyLeading: true,
        leadingWidth: 8.w,
      ),
      body: Column(
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
                        currentValue.truncate().toString(),
                        style: ThemeValueExtension.subtitle
                            .copyWith(
                            fontWeight: FontWeight.w500,
                           color: CustomColors.orangeColor
                        ),
                      ),
                      SizedBox(width: 1.w,),
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
            max: max,
            value: currentValue,
            activeColor: CustomColors.secondaryColor,
            inactiveColor: CustomColors.customGreyColor,
            onChanged: (double value) {
              currentValue = value;
              setState(() {});
            },
            onChangeEnd: (value) async {},
          )
        ],
      ),
    );
  }
}
