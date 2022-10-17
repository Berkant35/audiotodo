import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:cross_point/utilities/extensions/font_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../layers/view_models/global_providers.dart';
import '../../utilities/constants/custom_colors.dart';
import '../../utilities/extensions/iconSizeExtension.dart';

class InventoryListOfLocationPage extends ConsumerWidget {
  final String locationName;
  final String locationID;

  const InventoryListOfLocationPage(
      {Key? key, required this.locationName, required this.locationID})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: IconSizeExtension.HIGH.sizeValue,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            ref.read(inventoryTagsProvider.notifier).clearTagList(true);
          },
        ),
        centerTitle: true,
        toolbarHeight: context.height * 0.08,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: CustomColors.crossPointDark,
        title: Text(
          locationName,
          style: ThemeValueExtension.subtitle,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Not created any inventory yet",
              style: ThemeValueExtension.subtitle,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
