
import 'package:flutter/material.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';

import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';

class GetExpansionStaticChooseList extends StatefulWidget {
  final Function(String value) onSaved;
  final List<String> getList;
  final String title;
  final String? defaultValue;

  const GetExpansionStaticChooseList(
      {Key? key,
        required this.onSaved,
        required this.getList,
        required this.title,

        this.defaultValue})
      : super(key: key);

  @override
  State<GetExpansionStaticChooseList> createState() => _GetExpansionStaticChooseListState();
}

class _GetExpansionStaticChooseListState extends State<GetExpansionStaticChooseList> {
  String? chooseValue;


  @override
  void initState() {
    super.initState();
    chooseValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(width: 1, color: CustomColors.customGreyColor)),
        child: ExpansionTile(
          tilePadding: seperatePadding(),
          key: UniqueKey(),
          title: Text(chooseValue ?? widget.title,
              style: ThemeValueExtension.subtitle2
                  .copyWith(fontWeight: FontWeight.w600)),
          children: [builder(widget.getList)],
        ),
      ),
    );
  }



  Widget builder(List<String> list) {

    return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return listTile(list, index);
        });

  }

  ListTile listTile(List<dynamic> list, int index) {
    return ListTile(
      title: GestureDetector(
        onTap: () {
          chooseValue = list[index];
          widget.onSaved(chooseValue!);
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              list[index],
              style: ThemeValueExtension.subtitle3,
            ),
            const Icon(
              Icons.add_box_outlined,
              color: CustomColors.secondaryColor,
            )
          ],
        ),
      ),
    );
  }
}