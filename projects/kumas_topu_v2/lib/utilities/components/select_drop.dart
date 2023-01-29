import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/utilities/components/seperate_padding.dart';
import 'package:kumas_topu/utilities/constants/extension/edge_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';

class SelectDrop extends ConsumerStatefulWidget {
  final Function(String value) onSaved;
  final List<String> getList;
  final String? defaultValue;
  final String title;
  final String dropTitle;

  const SelectDrop(
      {Key? key,
      required this.onSaved,
      required this.getList,
      required this.title,
      required this.dropTitle,
      this.defaultValue})
      : super(key: key);

  @override
  ConsumerState createState() => _SelectDropState();
}

class _SelectDropState extends ConsumerState<SelectDrop> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Padding(
        padding: seperatePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: seperatePadding(),
              child: Text(widget.title, style: ThemeValueExtension.headline6),
            ),
            widget.getList.isNotEmpty
                ? widget.getList.length > 1
                    ? GetExpansionStaticChooseList(
                        onSaved: widget.onSaved,
                        getList: widget.getList,
                        defaultValue: widget.defaultValue,
                        title: widget.dropTitle,
                      )
                    : Padding(
                        padding: seperatePadding(),
                        child: Text(widget.getList.first,
                            style: ThemeValueExtension.subtitle.copyWith(
                              color: CustomColors.primaryColor,
                            )),
                      )
                : Padding(
                    padding: seperatePadding(),
                    child: Text("Seçilecek bir standart bulunamadı",
                        style: ThemeValueExtension.subtitle
                            .copyWith(color: CustomColors.errorColor)),
                  ),
          ],
        ),
      ),
    );
  }
}

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
  State<GetExpansionStaticChooseList> createState() =>
      _GetExpansionStaticChooseListState();
}

class _GetExpansionStaticChooseListState
    extends State<GetExpansionStaticChooseList> {
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
        child: ListTileTheme(
          dense: true,
          child: ExpansionTile(
            tilePadding: seperatePadding(),
            textColor: CustomColors.midPurpleColor,
            iconColor: CustomColors.midPurpleColor,
            key: UniqueKey(),
            title: SizedBox(
              child: Text(chooseValue ?? widget.title,
                  style: ThemeValueExtension.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis)),
            ),
            children: [builder(widget.getList)],
          ),
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
      title: InkWell(
        onTap: () {
          chooseValue = list[index];
          widget.onSaved(chooseValue!);
          setState(() {});
        },
        child: SizedBox(
          width: double.infinity,
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80.w,
                child: Text(
                  list[index],
                  style: ThemeValueExtension.subtitle.copyWith(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
