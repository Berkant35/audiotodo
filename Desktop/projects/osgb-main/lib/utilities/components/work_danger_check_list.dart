

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';

import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';

class WorkDangerCheckList extends ConsumerStatefulWidget {
  final Function(String dangerValue)? onSaved;
  const WorkDangerCheckList({
    Key? key,
    required this.onSaved
  }) : super(key: key);

  @override
  ConsumerState createState() => _WorkDangerCheckListState();
}

class _WorkDangerCheckListState extends ConsumerState<WorkDangerCheckList> {
  final listOfDangerTitles = ["Yapılması Önerilir", "Önemli", "Çok Önemli"];
  var mapOfDangers = {"lowDanger": false, "danger": false, "highDanger": false};
  String? choosedDanger;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: seperatePadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tehlike Durumu",
            style: ThemeValueExtension.subtitle,
          ),
          Column(
            children: [
              perCheck(listOfDangerTitles[0], mapOfDangers['lowDanger']!,
                  "lowDanger"),
              perCheck(
                  listOfDangerTitles[1], mapOfDangers['danger']!, "danger"),
              perCheck(listOfDangerTitles[2], mapOfDangers['highDanger']!,
                  "highDanger"),
            ],
          ),
        ],
      ),
    );
  }

  Row perCheck(String title, bool currentValue, String key) {
    return Row(
      children: [
        Expanded(
          child: Checkbox(
              fillColor: CustomColors.secondaryColorM,
              value: currentValue,
              onChanged: (value) {

                mapOfDangers[key] = value!;
                mapOfDangers.forEach((perKey, value) {
                  if (perKey != key) {
                    mapOfDangers[perKey] = false;
                  }
                });
                switch(key)
                {
                  case "lowDanger":
                    choosedDanger = listOfDangerTitles[0];
                    break;
                  case "danger":
                    choosedDanger = listOfDangerTitles[1];
                    break;
                  case "highDanger":
                    choosedDanger = listOfDangerTitles[2];
                    break;
                }
                widget.onSaved!(choosedDanger!);
                setState(() {});
              }),
        ),
        Expanded(
          flex: 9,
          child: Text(
            title,
            style: ThemeValueExtension.subtitle3.copyWith(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}
