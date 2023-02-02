import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/yearly.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/edge_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';

class ChooseYear extends ConsumerStatefulWidget {
  final String? choosedYear;
  List<String> allYears = [];
  final Function(String year) onSavedForYear;

  ChooseYear({Key? key, required this.onSavedForYear,
    this.choosedYear,
    required this.allYears,
  })
      : super(key: key);

  @override
  ConsumerState createState() => _ChooseYearState();
}

class _ChooseYearState extends ConsumerState<ChooseYear> {
  late String choosedYearLocal;

  @override
  void initState() {
    super.initState();
    choosedYearLocal = widget.choosedYear ?? widget.allYears.first;
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
            Padding(
              padding:  EdgeInsets.only(left: 0.w),
              child: Text(
                "YIL",
                style: ThemeValueExtension.subtitle,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            widget.allYears.isNotEmpty
                ? DropdownButton<String>(
              value: widget.choosedYear ?? widget.allYears.first,
              iconEnabledColor: CustomColors.secondaryColor,
              hint: hintText(""),
              isDense: false,
              icon: dropIcon(),
              elevation: 0,
              underline: underLine(),
              style: ThemeValueExtension.subtitle,
              onChanged: onChangedPeriodDrop,
              items: periodListDropDownMenu(),
            )
                : IconButton(
                onPressed: () {}, icon: const Icon(Icons.add))
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> periodListDropDownMenu() {
    return widget.allYears.map<DropdownMenuItem<String>>((String value) {
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
    choosedYearLocal = value!;
    widget.onSavedForYear(choosedYearLocal);
    setState(() {});
  }

  Padding dropIcon() => Padding(
    padding:  EdgeInsets.only(left: 2.w),
    child: const Icon(Icons.arrow_circle_down_outlined),
  );

  Text hintText(String text) {
    return Text(
      text,
      style: ThemeValueExtension.subtitle2,
    );
  }
}
