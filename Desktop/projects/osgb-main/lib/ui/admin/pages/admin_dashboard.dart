


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/admin/pages/dashboard_tab_bar_views/accountants.dart';
import 'package:osgb/ui/admin/pages/dashboard_tab_bar_views/doctors.dart';

import '../../../custom_functions.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/init/theme/custom_colors.dart';
import 'dashboard_tab_bar_views/customers.dart';
import 'dashboard_tab_bar_views/experts.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 4,
        vsync: this,
        initialIndex: ref.read(currentAddUserIndexState));
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: false,
      body: TabBarView(
          controller: tabController,
          children:  const [
            Customers(),
            Experts(),
            Doctors(),
            Accountants()
          ]),
    );
  }

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
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
              indicatorWeight: CustomFunctions.isPhone() ? 1 : 5,
              tabs: [
                Tab(
                  child: Text(
                    'İş Yeri',
                    style: ThemeValueExtension.subtitle3.copyWith(
                        color: ref.watch(currentAdminDashboardTabManager) == 0
                            ? CustomColors.secondaryColor
                            : Colors.black,
                        fontWeight: ref.watch(currentAdminDashboardTabManager) == 0
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: ref.watch(currentAdminDashboardTabManager) == 0
                            ? ThemeValueExtension.subtitle2.fontSize
                            : ThemeValueExtension.subtitle3.fontSize
                    ),
                  ),
                ),
                Tab(
                  child: Text('Uzman',
                      style: ThemeValueExtension.subtitle3.copyWith(
                          color: ref.watch(currentAdminDashboardTabManager) == 1
                              ? CustomColors.secondaryColor
                              : Colors.black,
                          fontWeight: ref.watch(currentAdminDashboardTabManager) == 1
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: ref.watch(currentAdminDashboardTabManager) == 1
                              ? ThemeValueExtension.subtitle2.fontSize
                              : ThemeValueExtension.subtitle3.fontSize
                      )),
                ),
                Tab(
                  child: Text('Hekim',
                      style: ThemeValueExtension.subtitle3.copyWith(
                          color: ref.watch(currentAdminDashboardTabManager) == 2
                              ? CustomColors.secondaryColor
                              : Colors.black,
                          fontWeight: ref.watch(currentAdminDashboardTabManager) == 2
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: ref.watch(currentAdminDashboardTabManager) == 2
                              ? ThemeValueExtension.subtitle2.fontSize
                              : ThemeValueExtension.subtitle3.fontSize
                      )),
                ),
                Tab(
                  child: Text('Muhasebe',
                      style: ThemeValueExtension.subtitle3.copyWith(
                          color: ref.watch(currentAdminDashboardTabManager) == 3
                              ? CustomColors.secondaryColor
                              : Colors.black,
                          fontWeight: ref.watch(currentAdminDashboardTabManager) == 3
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: ref.watch(currentAdminDashboardTabManager) == 3
                              ? ThemeValueExtension.subtitle2.fontSize
                              : ThemeValueExtension.subtitle3.fontSize
                      )),
                ),
              ],
            ),
          )),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  void _handleTabSelection() {
    ref
        .read(currentAdminDashboardTabManager.notifier)
        .changeState(tabController.index);
  }
}
