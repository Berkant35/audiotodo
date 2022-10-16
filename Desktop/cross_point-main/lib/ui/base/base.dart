import 'package:cross_point/layers/view_models/global_providers.dart';
import 'package:cross_point/ui/base/base_widgets/per_item_of_menu.dart';
import 'package:cross_point/utilities/constants/custom_colors.dart';
import 'package:cross_point/utilities/extensions/context_extension.dart';
import 'package:cross_point/utilities/extensions/font_theme.dart';
import 'package:cross_point/utilities/extensions/iconSizeExtension.dart';
import 'package:cross_point/utilities/navigation/navigation_constants.dart';
import 'package:cross_point/utilities/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utilities/constants/image_path.dart';
import '../../utilities/custom_functions.dart';

class BasePage extends ConsumerWidget {
  const BasePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.crossPointDark,
        centerTitle: true,
        toolbarHeight: context.height * 0.08,
        title: Image.asset(
          ImagePath.appBarBack,
          width: context.width,
          height: context.height
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(viewModelStateProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
            iconSize: IconSizeExtension.HIGH.sizeValue,
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              ImagePath.backPng,
              width: context.width,
              height: context.height * 0.3,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.height * 0.2),
              SizedBox(
                height: context.height * 0.6,
                child: GridView.count(
                  primary: false,
                  padding: EdgeInsets.all(AllFunc.isPhone()
                      ? context.normalValue
                      : context.mediumtoHighValue),
                  crossAxisSpacing: AllFunc.isPhone()
                      ? context.normalValue
                      : context.mediumtoHighValue,
                  mainAxisSpacing: AllFunc.isPhone()
                      ? context.normalValue
                      : context.mediumtoHighValue,
                  crossAxisCount: 2,
                  children: <Widget>[
                    PerItemOfMenu(
                        imagePath: ImagePath.addNewInventorySvg,
                        title: 'New Inventory',
                        onTap: () => NavigationService.instance.navigateToPage(
                            path: NavigationConstants.locationSearchPage)),
                    PerItemOfMenu(
                        imagePath: ImagePath.addNewInventorySvg,
                        title: 'New Inventory',
                        onTap: () => NavigationService.instance.navigateToPage(
                            path: NavigationConstants.locationSearchPage)),
                    PerItemOfMenu(
                        imagePath: ImagePath.addNewInventorySvg,
                        title: 'New Inventory',
                        onTap: () => NavigationService.instance.navigateToPage(
                            path: NavigationConstants.locationSearchPage)),
                    PerItemOfMenu(
                        imagePath: ImagePath.addNewInventorySvg,
                        title: 'New Inventory',
                        onTap: () => NavigationService.instance.navigateToPage(
                            path: NavigationConstants.locationSearchPage)),
                  ],
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: context.normalValue),
                child: Text(
                  'powered by uniqueid',
                  style: ThemeValueExtension.subtitle3.copyWith(
                      color: CustomColors.grimsi, fontWeight: FontWeight.w600),
                ),
              )),
        ],
      ),
    );
  }
}
