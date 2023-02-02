import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import 'package:osgb/ui/details/customer/customer_tab_views/customer_alerts.dart';
import 'package:osgb/ui/details/customer/customer_tab_views/customer_payments.dart';
import 'package:osgb/ui/details/customer/customer_tab_views/wishes.dart';
import 'package:osgb/ui/details/customer/customer_tab_views/company_of_workers.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../custom_functions.dart';
import '../../../line/viewmodel/global_providers.dart';
import '../../../models/customer.dart';
import '../../../utilities/components/custom_flexible_bar.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/init/theme/custom_colors.dart';
import 'customer_tab_views/details_of_customer.dart';
import 'customer_tab_views/files_of_customers.dart';

class CustomerDetails extends ConsumerStatefulWidget {
  final Customer customer;
  final Function(String value) onSaved;
  const CustomerDetails({
    Key? key,
    required this.customer,
    required this.onSaved,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends ConsumerState<CustomerDetails>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 6,
        vsync: this,
        initialIndex: ref.read(currentCustomerDetailsTabIndexState));
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentAppBar = ref.watch(currentCustomFlexibleAppBarState);

    return  Scaffold(
            appBar: AppBar(
              leading: const SizedBox(),
              toolbarHeight: 25.h,
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              elevation: 0,
              flexibleSpace: CustomFlexibleBar(
                appBarTitle: currentAppBar.backAppBarTitle!,
                headerPhoto: currentAppBar.photoUrl,
                firstHeader: currentAppBar.header1,
                firstInfo: currentAppBar.content1,
                secondHeader: currentAppBar.header2,
                secondInfo: currentAppBar.content2,
                thirdHeader: currentAppBar.header3,
                thirdInfo: currentAppBar.content3,
                fourHeader: currentAppBar.header4,
                fourInfo: currentAppBar.content4,
                fiveHeader: currentAppBar.header5,
                fiveInfo: currentAppBar.content5,
                role: Roles.customer,

              ),
            ),
            body: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(2.0),
                    child: SizedBox(
                      child: TabBar(
                        isScrollable: true,
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.transparent,
                        indicatorWeight: CustomFunctions.isPhone() ? 1 : 5,
                        tabs: [
                          Tab(
                            child: Text(
                              'Detay',
                              style: ThemeValueExtension.subtitle3.copyWith(
                                  color: ref.watch(
                                              currentCustomerDetailsTabIndexState) ==
                                          0
                                      ? CustomColors.secondaryColor
                                      : Colors.black,
                                  fontWeight: ref.watch(
                                              currentCustomerDetailsTabIndexState) ==
                                          0
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: ref.watch(
                                              currentCustomerDetailsTabIndexState) ==
                                          0
                                      ? ThemeValueExtension.subtitle2.fontSize
                                      : ThemeValueExtension.subtitle3.fontSize),
                            ),
                          ),
                          Tab(
                            child: Text('Talepler',
                                style: ThemeValueExtension.subtitle3.copyWith(
                                    color: ref.watch(
                                                currentCustomerDetailsTabIndexState) ==
                                            1
                                        ? CustomColors.secondaryColor
                                        : Colors.black,
                                    fontWeight: ref.watch(
                                                currentCustomerDetailsTabIndexState) ==
                                            1
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: ref.watch(
                                                currentCustomerDetailsTabIndexState) ==
                                            1
                                        ? ThemeValueExtension.subtitle2.fontSize
                                        : ThemeValueExtension
                                            .subtitle3.fontSize)),
                          ),
                          Tab(
                            child: Text('Olaylar',
                                style: ThemeValueExtension.subtitle3.copyWith(
                                    color: ref.watch(
                                                currentCustomerDetailsTabIndexState) ==
                                            2
                                        ? CustomColors.secondaryColor
                                        : Colors.black,
                                    fontWeight: ref.watch(
                                                currentCustomerDetailsTabIndexState) ==
                                            2
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: ref.watch(
                                                currentCustomerDetailsTabIndexState) ==
                                            2
                                        ? ThemeValueExtension.subtitle2.fontSize
                                        : ThemeValueExtension
                                            .subtitle3.fontSize)),
                          ),
                          Tab(
                            child: Text('Muhasebe',
                                style: ThemeValueExtension.subtitle3.copyWith(
                                    color: ref.watch(
                                                currentCustomerDetailsTabIndexState) ==
                                            3
                                        ? CustomColors.secondaryColor
                                        : Colors.black,
                                    fontWeight: ref.watch(
                                                currentCustomerDetailsTabIndexState) ==
                                            3
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: ref.watch(
                                                currentCustomerDetailsTabIndexState) ==
                                            3
                                        ? ThemeValueExtension.subtitle2.fontSize
                                        : ThemeValueExtension
                                            .subtitle3.fontSize)),
                          ),
                          Tab(
                            child: Text('Çalışanlar',
                                style: ThemeValueExtension.subtitle3.copyWith(
                                    color: ref.watch(
                                        currentCustomerDetailsTabIndexState) ==
                                        4
                                        ? CustomColors.secondaryColor
                                        : Colors.black,
                                    fontWeight: ref.watch(
                                        currentCustomerDetailsTabIndexState) ==
                                        4
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: ref.watch(
                                        currentCustomerDetailsTabIndexState) ==
                                        4
                                        ? ThemeValueExtension.subtitle2.fontSize
                                        : ThemeValueExtension
                                        .subtitle3.fontSize)),
                          ),
                          Tab(
                            child: Text('Dosyalar',
                                style: ThemeValueExtension.subtitle3.copyWith(
                                    color: ref.watch(
                                        currentCustomerDetailsTabIndexState) ==
                                        5
                                        ? CustomColors.secondaryColor
                                        : Colors.black,
                                    fontWeight: ref.watch(
                                        currentCustomerDetailsTabIndexState) ==
                                        5
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: ref.watch(
                                        currentCustomerDetailsTabIndexState) ==
                                        5
                                        ? ThemeValueExtension.subtitle2.fontSize
                                        : ThemeValueExtension
                                        .subtitle3.fontSize)),
                          ),
                        ],
                      ),
                    )),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              body: TabBarView(
                controller: tabController,
                children: [
                  DetailsOfCustomer(
                    customer: widget.customer,
                    onSaved: widget.onSaved,
                  ),
                  const Wishes(),
                  const CustomerAlerts(),
                  CustomerPayments(customer: widget.customer),
                  WorkersOfCompany(customer: widget.customer),
                  FilesOfCustomers(customer: widget.customer,),
                ],
              ),
            ),
          );
  }

  void _handleTabSelection() {
    ref
        .read(currentCustomerDetailsTabIndexState.notifier)
        .changeState(tabController.index);
  }
}
