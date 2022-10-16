import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:cross_point/utilities/constants/custom_colors.dart';
import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:cross_point/utilities/extensions/font_theme.dart';
import 'package:cross_point/utilities/extensions/iconSizeExtension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../layers/models/items.dart';
import 'base_widgets/buttons_of_panel.dart';

class InventoryOfItems extends ConsumerStatefulWidget {
  final String locationName;
  final String locationID;

  const InventoryOfItems(
      {Key? key, required this.locationName, required this.locationID})
      : super(key: key);

  @override
  ConsumerState createState() => _InventoryOfItemsState();
}

class _InventoryOfItemsState extends ConsumerState<InventoryOfItems> {
  Future<Items?>? _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = ref
        .read(viewModelStateProvider.notifier)
        .getItems(widget.locationID, ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: IconSizeExtension.HIGH.sizeValue,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();

            ref.read(inventoryTagsProvider.notifier).clearTagList();
          },
        ),
        centerTitle: true,
        toolbarHeight: context.height * 0.08,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: CustomColors.crossPointDark,
        title: Text(
          widget.locationName,
          style: ThemeValueExtension.subtitle,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          ref.watch(inventoryTagsProvider.notifier).expectedEpcList.isNotEmpty
              ? FloatingActionButton.extended(
                  backgroundColor: CustomColors.crossPointDark,
                  onPressed: () {},
                  label: Text(
                    "Save",
                    style: ThemeValueExtension.subtitle,
                  ))
              : const SizedBox(),
      body: SizedBox(
        height: context.height,
        child: FutureBuilder<Items?>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Items? items = snapshot.data;

            List<Item>? itemList = items?.data;

            return snapshot.connectionState == ConnectionState.done &&
                    items != null
                ? Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 1.5,
                                  color: CustomColors.crossPointDark),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildTable(context, itemList!),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 3),
                                child: ButtonsOfPanel(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 16,
                          child: itemList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: itemList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: context.lowValue),
                                      child: SizedBox(
                                        height: context.height * 0.17,
                                        child: Card(
                                          color: !ref
                                                  .watch(inventoryTagsProvider)
                                                  .containsKey(
                                                      itemList[index].epc)
                                              ? CustomColors.acikGri
                                              : CustomColors.crossPointLight
                                                  .withOpacity(0.75),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                context.lowValue),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    height: 200,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 4,
                                                            color: !ref
                                                                .watch(
                                                                inventoryTagsProvider)
                                                                .containsKey(
                                                                itemList[index]
                                                                    .epc)
                                                                ? CustomColors.crossPointDark
                                                                : Colors.white)),
                                                    child: Center(
                                                      child: Text(
                                                        itemList[index].label!,
                                                        style: ThemeValueExtension
                                                            .subtitle
                                                            .copyWith(
                                                          color: !ref
                                                              .watch(
                                                              inventoryTagsProvider)
                                                              .containsKey(
                                                              itemList[index]
                                                                  .epc)
                                                              ? Colors.black
                                                              : Colors.white
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 8,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: context.lowValue),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          itemList[index].ean!,
                                                          style: ThemeValueExtension
                                                              .subtitle
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                              color: !ref
                                                                  .watch(
                                                                  inventoryTagsProvider)
                                                                  .containsKey(
                                                                  itemList[index]
                                                                      .epc)
                                                                  ? CustomColors.crossPointDark
                                                                  : Colors.white
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                 Icon(
                                                                  Icons
                                                                      .color_lens,
                                                                  color: !ref
                                                                      .watch(
                                                                      inventoryTagsProvider)
                                                                      .containsKey(
                                                                      itemList[index]
                                                                          .epc)
                                                                      ? CustomColors.crossPointDark
                                                                      : Colors.white,
                                                                ),
                                                                SizedBox(width: context.lowValue,),

                                                                Text(
                                                                  itemList[
                                                                          index]
                                                                      .color!,
                                                                  style: ThemeValueExtension
                                                                      .subtitle
                                                                      .copyWith(
                                                                      color: !ref
                                                                          .watch(
                                                                          inventoryTagsProvider)
                                                                          .containsKey(
                                                                          itemList[index]
                                                                              .epc)
                                                                          ? CustomColors.crossPointDark
                                                                          : Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: context
                                                                  .normalValue,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.leaderboard,
                                                                  color: !ref
                                                                      .watch(
                                                                      inventoryTagsProvider)
                                                                      .containsKey(
                                                                      itemList[index]
                                                                          .epc)
                                                                      ? CustomColors.crossPointDark
                                                                      : Colors.white,
                                                                ),
                                                                SizedBox(width: context.lowValue,),
                                                                Text(
                                                                  itemList[
                                                                          index]
                                                                      .sizes!,
                                                                  style: ThemeValueExtension
                                                                      .subtitle
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                      color: !ref
                                                                          .watch(
                                                                          inventoryTagsProvider)
                                                                          .containsKey(
                                                                          itemList[index]
                                                                              .epc)
                                                                          ? CustomColors.crossPointDark
                                                                          : Colors.white),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          itemList[index].epc!,
                                                          style: ThemeValueExtension
                                                              .subtitle2
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                            color: !ref
                                                                .watch(
                                                                inventoryTagsProvider)
                                                                .containsKey(
                                                                itemList[index]
                                                                    .epc)
                                                                ? CustomColors.crossPointDark
                                                                : Colors.white
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Text(
                                    "Not found any item",
                                    style: ThemeValueExtension.subtitle,
                                  ),
                                )),
                    ],
                  )
                : Center(
                    child: SizedBox(
                      width: context.width * 0.1,
                      height: context.width * 0.1,
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                  );
          },
        ),
      ),
    );
  }

  /*perInfo("Epc: ",
                                                    itemList[index].epc ?? "-"),
                                                perInfo("ID: ",
                                                    itemList[index].id ?? "-"),
                                                perInfo(
                                                    "Color: ",
                                                    itemList[index].color ??
                                                        "-"),
                                                perInfo(
                                                    "Size: ",
                                                    itemList[index].sizes ??
                                                        "-"),
                                                perInfo(
                                                    "Notes: ",
                                                    itemList[index].notes ??
                                                        "-"),
                                                perInfo(
                                                    "Created At: ",
                                                    itemList[index].createdAt ??
                                                        "-"),
                                                perInfo(
                                                    "Updated At: ",
                                                    itemList[index].updatedAt ??
                                                        "-"),*/
  Table buildTable(BuildContext context, List<Item?> itemList) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
      },
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            SizedBox(
              height: buildHeight(context),
              child: Center(
                child: Text(
                  "Expected",
                  style: ThemeValueExtension.subtitle2
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: buildHeight(context),
              child: Center(
                child: Text(
                  "Read",
                  style: ThemeValueExtension.subtitle2
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            SizedBox(
              height: buildHeight(context),
              child: Center(
                child: Text(
                  "${ref.read(inventoryTagsProvider.notifier).waitingEpcList.length}",
                  style: ThemeValueExtension.subtitle
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: buildHeight(context),
              child: Center(
                child: Text(
                  "${ref.read(inventoryTagsProvider.notifier).expectedEpcList.length}",
                  style: ThemeValueExtension.subtitle
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  double buildHeight(BuildContext context) => context.height * 0.05;

  Row perInfo(String header, String content) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            header,
            style: ThemeValueExtension.subtitle3
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Expanded(
            flex: 7, child: Text(content, style: ThemeValueExtension.subtitle3))
      ],
    );
  }
}
