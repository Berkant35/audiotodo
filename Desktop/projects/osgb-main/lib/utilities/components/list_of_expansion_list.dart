import 'package:flutter/material.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../init/theme/custom_colors.dart';

class GetExpansionChooseList extends StatefulWidget {
  final Function(String? value, String? userID) onSaved;
  final Future<List<dynamic>> getFutureList;
  final String title;
  final String keyOfMap;
  final String? defaultValue;
  final bool? showRemove;


  const GetExpansionChooseList(
      {Key? key,
      required this.onSaved,
      required this.getFutureList,
      required this.title,
      required this.keyOfMap,
      this.showRemove,
      this.defaultValue})
      : super(key: key);

  @override
  State<GetExpansionChooseList> createState() => _GetExpansionChooseListState();
}

class _GetExpansionChooseListState extends State<GetExpansionChooseList> {
  String? chooseValue;
  String? choosedUserID;

  @override
  void initState() {
    chooseValue = widget.defaultValue;
    super.initState();
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
          children: [buildFutureBuilder()],
        ),
      ),
    );
  }

  FutureBuilder<List<dynamic>> buildFutureBuilder() {
    return FutureBuilder<List<dynamic>>(
        future: widget.getFutureList, builder: builder);
  }

  Widget builder(context, snapshot) {
    var list = snapshot.data;
    return snapshot.connectionState == ConnectionState.done
        ? null != list && list.isNotEmpty
            ? Column(
                children: [
                  (widget.showRemove != null && widget.showRemove!)
                      ? removeListTile()
                      : const SizedBox(),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return listTile(list, index);
                      }),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text(
                  "Tanımlanılmış bir hesap yok",
                  style: ThemeValueExtension.subtitle3,
                ),
              )
        : const Center(
            child: CircularProgressIndicator.adaptive(),
          );
  }

  ListTile listTile(List<dynamic> list, int index) {
    return ListTile(
      title: GestureDetector(
        onTap: () {
          chooseValue = list[index][widget.keyOfMap];
          choosedUserID = list[index]['rootUserID'];
          widget.onSaved(chooseValue!, choosedUserID!);
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              list[index][widget.keyOfMap],
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

  removeListTile() {
    return ListTile(
      title: GestureDetector(
        onTap: () {
          chooseValue = null;
          choosedUserID = null;
          widget.onSaved(chooseValue, choosedUserID);
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hiç birisini seçme",
              style: ThemeValueExtension.subtitle2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Icon(
              Icons.delete,
              color: CustomColors.secondaryColor,
            )
          ],
        ),
      ),
    );
  }
}
