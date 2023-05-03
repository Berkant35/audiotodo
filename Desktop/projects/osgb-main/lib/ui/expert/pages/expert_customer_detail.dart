import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/ui/details/customer/customer_details.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../custom_functions.dart';
import '../../../models/customer.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/init/theme/custom_colors.dart';
import '../../details/customer/customer_tab_views/details_of_customer.dart';
import '../../details/customer/customer_tab_views/files_of_customers.dart';

class ExpertCustomerDetail extends ConsumerStatefulWidget {
  final Customer customer;

  const ExpertCustomerDetail({Key? key, required this.customer})
      : super(key: key);

  @override
  ConsumerState createState() => _ExpertCustomerDetailState();
}

class _ExpertCustomerDetailState extends ConsumerState<ExpertCustomerDetail>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: ref.read(currentExpertCustomerDetailTabBarManager));
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
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: true,
        backgroundColor:Colors.transparent,
        toolbarHeight: context.height*0.1,
        leading: IconButton(
          onPressed: () => NavigationService.instance.navigatePopUp(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        title: Text(
          "İş yeri detaylar",
          style: ThemeValueExtension.subtitle.copyWith(
            color: Colors.black
          ),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: SizedBox(

              child: TabBar(
                isScrollable: true,
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: CustomColors.secondaryColor,
                indicatorWeight: CustomFunctions.isPhone() ? 1 : 5,

                tabs: [
                  Tab(
                    child: Text(
                      'Müşteri Detay',
                      style: ThemeValueExtension.subtitle2.copyWith(
                          color: ref.watch(currentExpertCustomerDetailTabBarManager) == 0
                              ? CustomColors.secondaryColor
                              : Colors.black,
                          fontWeight: ref.watch(currentExpertCustomerDetailTabBarManager) == 0
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: ref.watch(currentExpertCustomerDetailTabBarManager) == 0
                              ? ThemeValueExtension.subtitle.fontSize
                              : ThemeValueExtension.subtitle2.fontSize),
                    ),
                  ),
                  Tab(
                    child: Text('Dosyalar',
                        style: ThemeValueExtension.subtitle2.copyWith(
                            color: ref.watch(currentExpertCustomerDetailTabBarManager) == 1
                                ? CustomColors.secondaryColor
                                : Colors.black,
                            fontWeight: ref.watch(currentExpertCustomerDetailTabBarManager) == 1
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: ref.watch(currentExpertCustomerDetailTabBarManager) == 1
                                ? ThemeValueExtension.subtitle.fontSize
                                : ThemeValueExtension.subtitle2.fontSize)),
                  ),
                ],
              ),
            )),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          DetailsOfCustomer(
            customer: widget.customer,
            onSaved: (text) => null,
          ),
          FilesOfCustomers(customer: widget.customer),
        ],
      ),
    );
  }

  void _handleTabSelection() {
    ref
        .read(currentExpertCustomerDetailTabBarManager.notifier)
        .changeState(tabController.index);
  }
}
