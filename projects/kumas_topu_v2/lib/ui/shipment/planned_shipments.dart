

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';

import '../../utilities/components/appbars/add_inventory_app_bar.dart';
import '../inventory/add_inventory_action.dart';


class PlannedShipments extends ConsumerStatefulWidget {
  const PlannedShipments({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _PlannedShipmentsState();
}

class _PlannedShipmentsState extends ConsumerState<PlannedShipments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddInventoryAppBar(
        onTapTitle: ()=>NavigationService.instance.navigatePopUp(),
        label: 'Sayım',
        addAction: () => showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return const AddInventoryAction(isShipment: false,);
            }).then((value) {
          setState(() {});
        }),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
