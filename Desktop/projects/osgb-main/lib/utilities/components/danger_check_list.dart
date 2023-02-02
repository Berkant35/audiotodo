import 'package:flutter/material.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';

import '../init/theme/custom_colors.dart';

class DangerCheckList extends StatefulWidget {
  final String? currentChoosedDangerLevel;
  final Function(String dangerValue)? onSaved;

  const DangerCheckList({
    Key? key,
    required this.onSaved,
    this.currentChoosedDangerLevel
  }) : super(key: key);

  @override
  State<DangerCheckList> createState() => _DangerCheckListState();
}

class _DangerCheckListState extends State<DangerCheckList> {
  final listOfDangerTitles = ["Az Tehlikeli", "Tehlikeli", "Çok Tehlikeli"];
  var mapOfDangers = {"lowDanger": false, "danger": false, "highDanger": false};
  String? choosedDanger;

  @override
  void initState() {
    choosedDanger = widget.currentChoosedDangerLevel;
    if(widget.currentChoosedDangerLevel != null){
      for (int i=0;i<listOfDangerTitles.length;i++) {
        if(listOfDangerTitles[i] == widget.currentChoosedDangerLevel){
           switch(i){
             case 0:
               mapOfDangers["lowDanger"] = true;
               break;
             case 1:
               mapOfDangers["danger"] = true;
               break;
             case 2:
               mapOfDangers["highDanger"] = true;
               break;
           }
        }
      }
    }
    super.initState();
  }

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
