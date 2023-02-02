import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/edge_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';

class ChoosePeriod extends ConsumerStatefulWidget {
  final String? choosedPeriod;
  final Function(String dailyPeriod) onSavedForDaily;

  const ChoosePeriod(
      {Key? key, required this.onSavedForDaily, this.choosedPeriod})
      : super(key: key);

  @override
  ConsumerState createState() => _ChoosePeriodState();
}

class _ChoosePeriodState extends ConsumerState<ChoosePeriod> {
  String choosedPeriod = "Haftada 1";
  List<String> periods = [
    "15 Günde 1",
    "Haftada 1",
    "Haftada 2",
    "Haftada 3",
    "Haftada 4",
    "Ayda 1",
    "2 Ayda 1",
    "3 Ayda 1"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.choosedPeriod != null) {
      choosedPeriod = widget.choosedPeriod!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 1.h),
      child: Container(
        padding: seperatePadding(),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(EdgeExtension.tinyEdge.edgeValue)),
            border: Border.all(color: CustomColors.customGreyColor)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ziyaret Periyodu",
              style: ThemeValueExtension.subtitle,
            ),
            SizedBox(
              width: 5.w,
            ),
            DropdownButton<String>(
              value: choosedPeriod,
              iconEnabledColor: CustomColors.secondaryColor,
              hint: hintText("Period"),
              isDense: false,
              icon: dropIcon(),
              elevation: 0,
              underline: underLine(),
              style: ThemeValueExtension.subtitle,
              onChanged: onChangedPeriodDrop,
              items: periodListDropDownMenu(),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> periodListDropDownMenu() {
    return periods.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: ThemeValueExtension.subtitle.copyWith(color: Colors.black),
        ),
      );
    }).toList();
  }

  Container underLine() {
    return Container(
      width: context.width,
      height: 0,
      color: CustomColors.secondaryColor,
    );
  }

  void onChangedPeriodDrop(String? value) {
    choosedPeriod = value!;
    widget.onSavedForDaily(choosedPeriod);
    setState(() {});
  }

  Icon dropIcon() => const Icon(Icons.arrow_circle_down_outlined);

  Text hintText(String text) {
    return Text(
      text,
      style: ThemeValueExtension.subtitle2,
    );
  }
}
