import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/admin/pages/dashboard_tab_bar_views/customers.dart';
import 'package:osgb/ui/expert/pages/done_missions.dart';
import 'package:osgb/ui/expert/pages/expert_missions.dart';

import '../../custom_functions.dart';
import '../../utilities/constants/extension/context_extensions.dart';
import '../../utilities/init/navigation/navigation_constants.dart';
import '../../utilities/init/navigation/navigation_service.dart';
import '../../utilities/init/theme/custom_colors.dart';
import '../admin/admin_widgets/custom_drawer.dart';

class ExpertBase extends ConsumerStatefulWidget {
  const ExpertBase({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ExpertBaseState();
}

class _ExpertBaseState extends ConsumerState<ExpertBase>
    with TickerProviderStateMixin {
  late TabController tabController;
  late AdvancedDrawerController _advancedDrawerController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 3, vsync: this, initialIndex: ref.read(currentExpertTabState));
    tabController.addListener(_handleTabSelection);
    _advancedDrawerController = AdvancedDrawerController();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: CustomColors.secondaryColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: const CustomDrawer(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle(),
            style: ThemeValueExtension.headline6
                .copyWith(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              _advancedDrawerController.showDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          actions: [
            IconButton(
                onPressed: () => NavigationService.instance
                    .navigateToPage(path: NavigationConstants.addInspectionPage),
                icon: const Icon(Icons.add_location_outlined)),
          ],
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Scaffold(
          appBar: buildAppBar(context),
          body: TabBarView(
            controller: tabController,
            children: const [
              ExpertMissions(),
              DoneMissions(),
              Customers()
            ],
          ),
        ),
      ),
    );
  }

  String appBarTitle() => "SU OSGB";

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      toolbarHeight: context.height * 0.07,
      elevation: 0,
      centerTitle: false,

      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: SizedBox(
            child: TabBar(
              isScrollable: true,
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
              indicatorWeight: CustomFunctions.isPhone() ? 1 : 5,
              tabs: [
                Tab(
                  child: Text(
                    'Görevler',
                    style: ThemeValueExtension.subtitle2.copyWith(
                        color: ref.watch(currentExpertTabState) == 0
                            ? CustomColors.secondaryColor
                            : Colors.black,
                        fontWeight: ref.watch(currentExpertTabState) == 0
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: ref.watch(currentExpertTabState) == 0
                            ? ThemeValueExtension.subtitle.fontSize
                            : ThemeValueExtension.subtitle2.fontSize),
                  ),
                ),
                Tab(
                  child: Text('Tamamlanan Ziyaretler',
                      style: ThemeValueExtension.subtitle2.copyWith(
                          color: ref.watch(currentExpertTabState) == 1
                              ? CustomColors.secondaryColor
                              : Colors.black,
                          fontWeight: ref.watch(currentExpertTabState) == 1
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: ref.watch(currentExpertTabState) == 1
                              ? ThemeValueExtension.subtitle.fontSize
                              : ThemeValueExtension.subtitle2.fontSize)),
                ),
                Tab(
                  child: Text('Müşteriler',
                      style: ThemeValueExtension.subtitle2.copyWith(
                          color: ref.watch(currentExpertTabState) == 2
                              ? CustomColors.secondaryColor
                              : Colors.black,
                          fontWeight: ref.watch(currentExpertTabState) == 2
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: ref.watch(currentExpertTabState) == 2
                              ? ThemeValueExtension.subtitle.fontSize
                              : ThemeValueExtension.subtitle2.fontSize)),
                ),
              ],
            ),
          )),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  void _handleTabSelection() {
    ref.read(currentExpertTabState.notifier).changeState(tabController.index);
  }
}
