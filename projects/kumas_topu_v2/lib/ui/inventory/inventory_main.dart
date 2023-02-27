import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/models/inventory_list.dart';
import 'package:kumas_topu/ui/inventory/per_row_inventory_info.dart';
import 'package:kumas_topu/utilities/components/appbars/add_inventory_app_bar.dart';
import 'package:kumas_topu/utilities/constants/extension/context_extensions.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/constants/extension/edge_extension.dart';
import '../../utilities/init/theme/custom_colors.dart';
import 'add_inventory_action.dart';

class InventoryMain extends ConsumerStatefulWidget {
  const InventoryMain({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _InventoryMainState();
}

class _InventoryMainState extends ConsumerState<InventoryMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddInventoryAppBar(
        onTapTitle: ()=>NavigationService.instance.navigatePopUp(),
        label: ref.read(currentIsShipmentProvider) ? 'Sevk' : 'Sayım',
        addAction: () => showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return const AddInventoryAction(isShipment: false,);
            }).then((value) {
          setState(() {});
        }),
      ),
      body: FutureBuilder<InventoryList?>(
        future: ref.read(viewModelStateProvider.notifier).getInventoryList(ref.read(currentIsShipmentProvider)),
        builder: (context, snapshot) {
          var inventoryList = snapshot.data;
          return snapshot.connectionState == ConnectionState.done
              ? inventoryList != null && inventoryList.data!.isNotEmpty
                  ? Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: ListView.builder(
                        itemCount: inventoryList.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Inventory perInventory = inventoryList.data![index];
                          return PerRowInventoryInfo(
                            perInventory: perInventory,
                          );
                        }),
                  )
                  : Center(
                      child: Text(
                        "Henüz oluşturulmuş bir sayım yok.",
                        style: ThemeValueExtension.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
        },
      ),
    );
  }
}
