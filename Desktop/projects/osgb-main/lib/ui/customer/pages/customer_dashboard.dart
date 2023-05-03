import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/customer/pages/dashboard_pages/customer_accountant.dart';
import 'package:osgb/ui/customer/pages/dashboard_pages/customer_visits.dart';

import '../../../custom_functions.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/init/theme/custom_colors.dart';
import '../../details/customer/customer_tab_views/files_of_customers.dart';

class CustomerDashboard extends ConsumerStatefulWidget {
  const CustomerDashboard({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends ConsumerState<CustomerDashboard>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: ref.read(currentAddUserCustomerIndexState)
    );
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
          children:  [
            const CustomerVisits(),
            const CustomerAccountant(),
            FilesOfCustomers(customer: ref.read(currentBaseModelState).customer!)
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
              isScrollable: true,
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
              indicatorWeight: CustomFunctions.isPhone() ? 1 : 5,
              tabs: [

                Tab(
                  child: Text('Ziyaretlerim',
                      style: ThemeValueExtension.subtitle3.copyWith(
                          color:
                              ref.watch(currentAddUserCustomerIndexState) == 0
                                  ? CustomColors.secondaryColor
                                  : Colors.black,
                          fontWeight:
                              ref.watch(currentAddUserCustomerIndexState) == 0
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                          fontSize:
                              ref.read(currentAddUserCustomerIndexState) == 0
                                  ? ThemeValueExtension.subtitle2.fontSize
                                  : ThemeValueExtension.subtitle3.fontSize)),
                ),
                Tab(
                  child: Text('Muhasebe',
                      style: ThemeValueExtension.subtitle3.copyWith(
                          color:
                              ref.watch(currentAddUserCustomerIndexState) == 1
                                  ? CustomColors.secondaryColor
                                  : Colors.black,
                          fontWeight:
                              ref.watch(currentAddUserCustomerIndexState) == 1
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                          fontSize:
                              ref.read(currentAddUserCustomerIndexState) == 1
                                  ? ThemeValueExtension.subtitle2.fontSize
                                  : ThemeValueExtension.subtitle3.fontSize)),
                ),
                Tab(
                  child: Text('Dosyalar',
                      style: ThemeValueExtension.subtitle3.copyWith(
                          color:
                          ref.watch(currentAddUserCustomerIndexState) == 2
                              ? CustomColors.secondaryColor
                              : Colors.black,
                          fontWeight:
                          ref.watch(currentAddUserCustomerIndexState) == 2
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize:
                          ref.read(currentAddUserCustomerIndexState) == 2
                              ? ThemeValueExtension.subtitle2.fontSize
                              : ThemeValueExtension.subtitle3.fontSize)),
                ),
              ],
            ),
          )),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  void _handleTabSelection() {
    ref
        .read(currentAddUserCustomerIndexState.notifier)
        .changeState(tabController.index);
  }
}
