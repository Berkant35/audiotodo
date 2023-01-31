

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumas_topu/utilities/components/appbars/title_app_bar.dart';
import 'package:kumas_topu/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/components/per_item_of_menu.dart';
import '../../utilities/constants/extension/image_path.dart';

class ShipmentMain extends ConsumerStatefulWidget {
  const ShipmentMain({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ShipmentMainState();
}

class _ShipmentMainState extends ConsumerState<ShipmentMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        onTap: ()=>NavigationService.instance.navigatePopUp(),
        label: 'Sevk',
      ),
      body: Column(
        children: [
          SizedBox(height: 4.h,),
          SizedBox(
            height: 60.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: GridView.count(
                primary: false,
                crossAxisSpacing: 2.h,
                mainAxisSpacing: 0,
                crossAxisCount: 2,
                children: <Widget>[


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
