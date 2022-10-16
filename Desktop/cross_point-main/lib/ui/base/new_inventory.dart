import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:cross_point/utilities/common_widgets/custom_button.dart';
import 'package:cross_point/utilities/extensions/font_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_widgets/list_of_tags.dart';

class NewInventory extends ConsumerStatefulWidget {
  const NewInventory({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _NewInventoryState();
}

class _NewInventoryState extends ConsumerState<NewInventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    ref.read(inventoryTagsProvider.notifier).startScan(ref);
                  },
                  inButtonWidget: Text(
                    "Scan",
                    style: ThemeValueExtension.subtitle,
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () {
                    ref.read(inventoryTagsProvider.notifier).stopScan();
                  },
                  inButtonWidget: Text(
                    "Stop Scan",
                    style: ThemeValueExtension.subtitle,
                  ),
                ),
              ],
            ),
            Text('Length: ${ref.watch(inventoryTagsProvider).values.length}'),
            ref.watch(inventoryTagsProvider).isNotEmpty
                ? const ListOfTags()
                : const Text('Scan')
            /*StreamBuilder<List<UHFTagInfo>>(
                stream: ref.read(rfidStateProvider.notifier).getInventory(ref),
                builder: (context,snapshot){
              return Container();
            })*/
          ],
        ),
      ),
    );
  }
}
