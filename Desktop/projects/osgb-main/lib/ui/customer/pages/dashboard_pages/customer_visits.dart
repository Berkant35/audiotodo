import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/customer/pages/dashboard_pages/customer_visits_tab_views/customer_done_visits.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';

import '../../../../custom_functions.dart';
import '../../../../utilities/init/theme/custom_colors.dart';
import 'customer_visits_tab_views/customer_wait_visits.dart';

class CustomerVisits extends ConsumerStatefulWidget {
  const CustomerVisits({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomerVisitsState();
}

class _CustomerVisitsState extends ConsumerState<CustomerVisits>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: ref.read(currentCustomerVisitTabIndexState));
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
      body: TabBarView(controller: tabController, children: const [
        CustomerWaitVisits(),
        CustomerDoneVisits(),
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
              indicator: const BoxDecoration(
                color: CustomColors.orangeColor
              ),
              indicatorColor: Colors.transparent,
              indicatorWeight: CustomFunctions.isPhone() ? 1 : 5,
              tabs: [
                Tab(
                  child: Text(
                    'Yapılacak Ziyaretler',
                    style: ThemeValueExtension.subtitle3.copyWith(
                        color: ref.watch(currentCustomerVisitTabIndexState) == 0
                            ? Colors.white
                            : Colors.black,
                        fontWeight:
                            ref.watch(currentCustomerVisitTabIndexState) == 0
                                ? FontWeight.bold
                                : FontWeight.w500,
                        fontSize:
                            ref.watch(currentCustomerVisitTabIndexState) == 0
                                ? ThemeValueExtension.subtitle2.fontSize
                                : ThemeValueExtension.subtitle3.fontSize),
                  ),
                ),
                Tab(
                  child: Text('Yapılan Ziyaretler',
                      style: ThemeValueExtension.subtitle3.copyWith(
                          color:
                              ref.watch(currentCustomerVisitTabIndexState) == 1
                                  ? Colors.white
                                  : Colors.black,
                          fontWeight:
                              ref.watch(currentCustomerVisitTabIndexState) == 1
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                          fontSize:
                              ref.watch(currentCustomerVisitTabIndexState) == 1
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
        .read(currentCustomerVisitTabIndexState.notifier)
        .changeState(tabController.index);
  }
}
