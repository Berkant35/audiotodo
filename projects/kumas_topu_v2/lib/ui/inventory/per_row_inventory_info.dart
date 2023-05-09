import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/line/global_providers.dart';
import 'package:kumas_topu/models/current_inventory.dart';
import 'package:kumas_topu/models/inventory_list.dart';
import 'package:kumas_topu/utilities/constants/extension/context_extensions.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_constants.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/constants/extension/edge_extension.dart';
import '../../utilities/init/theme/custom_colors.dart';

class PerRowInventoryInfo extends ConsumerWidget {
  final Inventory perInventory;
  final bool isShipment;
  const PerRowInventoryInfo({Key? key, required this.perInventory,required this.isShipment})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        //Mevcut Saıyımı Ayarla
        ref.read(currentInventoryProvider.notifier).changeState(
            CurrentInventory(inventory: perInventory, readEpcList: [],readEpcMap: {}));


        if(isShipment){
          ref
              .read(currentInventoryProvider.notifier)
              .getReadListAndSet(perInventory.iD);
        }

        ref.read(inventoryTagsProvider.notifier).listen(ref);

        NavigationService.instance
            .navigateToPage(path: NavigationConstants.doInventoryPage);
      },
      child: SizedBox(
        height: 15.h,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 68.w,
                          child: Text(
                            perInventory.inventoryName!,
                            style: ThemeValueExtension.subtitle
                                .copyWith(fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 25.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                          color: CustomColors.darkPurpleColor,
                          borderRadius: BorderRadius.all(Radius.circular(
                              EdgeExtension.lowEdge.edgeValue))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Seç',
                            style: ThemeValueExtension.subtitle.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: context.lowValue,
                          ),
                          Icon(
                            Icons.arrow_right_alt_sharp,
                            color: Colors.white,
                            size: 4.h,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*Container(
        width: 100.w,
        height: 10.h,
        color: Colors.red,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 2.w,
                    ),
                    Icon(
                      Icons.confirmation_num_outlined,
                      color: CustomColors.darkPurpleColor,
                      size: 4.h,
                    ),
                    SizedBox(
                      width: context.lowValue,
                    ),
                    Flexible(
                      child: Text(
                        perInventory.inventoryName!,
                        style: ThemeValueExtension.subtitle2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(
                      width: context.lowValue,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 2.8.w),
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                        color: CustomColors.darkPurpleColor,
                        borderRadius: BorderRadius.all(Radius.circular(
                            EdgeExtension.lowEdge.edgeValue))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Seç',
                          style: ThemeValueExtension.subtitle3.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: context.lowValue,
                        ),
                        Icon(
                          Icons.arrow_right_alt_sharp,
                          color: Colors.white,
                          size: 4.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      )*/
