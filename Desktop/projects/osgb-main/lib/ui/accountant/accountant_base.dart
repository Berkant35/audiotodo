import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/models/customer.dart';
import 'package:search_page/search_page.dart';

import '../../custom_functions.dart';
import '../../line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import '../../line/viewmodel/global_providers.dart';
import '../../utilities/components/seperate_padding.dart';
import '../../utilities/constants/extension/context_extensions.dart';
import '../../utilities/constants/extension/edge_extension.dart';
import '../../utilities/init/navigation/navigation_constants.dart';
import '../../utilities/init/navigation/navigation_service.dart';
import '../../utilities/init/theme/custom_colors.dart';
import '../admin/admin_widgets/custom_drawer.dart';
import 'customer_accountant_detail.dart';
import 'customer_for_accountant.dart';

class AccountantBase extends ConsumerStatefulWidget {
  const AccountantBase({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AccountantBaseState();
}

class _AccountantBaseState extends ConsumerState<AccountantBase> {
  List<Customer> customerList = [];
  late AdvancedDrawerController _advancedDrawerController;

  @override
  void initState() {
    super.initState();
    _advancedDrawerController = AdvancedDrawerController();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      openRatio: 0.62,
      backdropColor: CustomColors.secondaryColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(EdgeExtension.normalEdge.edgeValue)),
      ),
      drawer: const CustomDrawer(),
      child: Scaffold(
        appBar: buildAppBar(),
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: const ConsumerForAccountant(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        appBarTitle(),
        style:
            ThemeValueExtension.headline6.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        onPressed: () {
          _advancedDrawerController.showDrawer();
        },
        icon: const Icon(Icons.menu),
      ),
      actions: [
        IconButton(
            onPressed: () async {
              customerList = await ref
                  .read(currentAdminWorksState.notifier)
                  .getCustomerList(ref);
              if (customerList.isNotEmpty) {
                showSearch(
                  context: context,
                  delegate: SearchPage<Customer>(
                    items: customerList,
                    searchLabel: 'Ara',
                    suggestion: Center(
                      child: Padding(
                        padding: seperatePadding(),
                        child: Text(
                          'Müşteri Arayın',
                          style: ThemeValueExtension.subtitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    failure: Center(
                      child: Text(
                        'Sonuç bulunamadı',
                        style: ThemeValueExtension.subtitle,
                      ),
                    ),
                    filter: (searchUser) => [
                      searchUser.customerName,
                    ],
                    builder: (searchUser) => ListTile(
                      title: Text(
                        searchUser.customerName!,
                        style: ThemeValueExtension.subtitle,
                      ),
                      subtitle: Text(
                        CustomFunctions.getNameOfType(
                            CustomFunctions.getTypeFromString(
                                searchUser.typeOfUser)),
                        style: ThemeValueExtension.subtitle2
                            .copyWith(color: CustomColors.customGreyColor),
                      ),
                      onTap: () {
                        ref
                            .read(currentCustomFlexibleAppBarState.notifier)
                            .changeContentFlexibleManager(CustomFlexibleModel(
                                header1: "İş Yeri",
                                content1: searchUser.customerName,
                                header2: "Çalışan Sayı",
                                content2: searchUser.workerList != null
                                    ? searchUser.workerList!.length.toString()
                                    : "0",
                                header3: "Periyodu",
                                content3: searchUser.dailyPeriod,
                                photoUrl: searchUser.photoURL,
                                backAppBarTitle: "Muhasebe Detay"));
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomerAccountantDetail(
                                        customer:
                                        searchUser)));
                      },
                    ),
                  ),
                );
              } else {
                Fluttertoast.showToast(
                    msg: "Aranacak bir kullanıcı bulunmamaktadır");
              }
            },
            icon: const Icon(Icons.search)),
      ],
    );
  }

  String appBarTitle() => "SU OSGB";
}
