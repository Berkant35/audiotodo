import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/custom_functions.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/search_user.dart';
import 'package:osgb/ui/admin/pages/add_user_page.dart';
import 'package:osgb/ui/admin/pages/admin_dashboard.dart';
import 'package:osgb/ui/admin/pages/crisis.dart';
import 'package:osgb/ui/admin/pages/customer_requests.dart';
import 'package:osgb/ui/admin/pages/expert_visits.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/constants/extension/edge_extension.dart';
import 'package:osgb/utilities/init/navigation/navigation_constants.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:search_page/search_page.dart';

import '../../utilities/init/theme/custom_colors.dart';
import 'admin_widgets/custom_drawer.dart';

class AdminBase extends ConsumerStatefulWidget {
  const AdminBase({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AdminBaseState();
}

class _AdminBaseState extends ConsumerState<AdminBase> {
  late int _selectedItemPosition = 2;
  static const iconSize = 36.0;
  static const thickness = 3.0;
  static const radius = 200.0;

  List<SearchUser> searchUserList = [];
  late AdvancedDrawerController _advancedDrawerController;

  @override
  void initState() {
    super.initState();
    _advancedDrawerController = AdvancedDrawerController();

  }

  @override
  Widget build(BuildContext context) {
    return
         AdvancedDrawer(
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
              bottomNavigationBar: buildNavigationBar(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: _floatingActionButton(),
              body: showPage(_selectedItemPosition),
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
            onPressed: () async  {
              searchUserList = await ref.read(currentAdminWorksState.notifier).getSearchUsers();
              if(searchUserList.isNotEmpty){
                showSearch(
                  context: context,
                  delegate: SearchPage<SearchUser>(
                    items: searchUserList,
                    searchLabel: 'Ara',
                    suggestion: Center(
                      child: Padding(
                        padding: seperatePadding(),
                        child: Text(
                          'Müşteri,Uzman,Hekim veya Muhasebeci aratın',
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
                      searchUser.userName,
                    ],
                    builder: (searchUser) => ListTile(
                      title: Text(
                        searchUser.userName!,
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
                            .read(currentAdminWorksState.notifier)
                            .getUserAndThenGoDetail(
                            searchUser.rootUserID!, context, ref);
                      },
                    ),
                  ),
                );
              }else{
                Fluttertoast.showToast(msg: "Aranacak bir kullanıcı bulunmamaktadır");
              }
            },
            icon: const Icon(Icons.search)),
        IconButton(
            onPressed: () => NavigationService.instance
                .navigateToPage(path: NavigationConstants.addInspectionPage),
            icon: const Icon(Icons.add_location_outlined)),
      ],
    );
  }

  String appBarTitle() => "SU OSGB";

  Theme buildNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: CustomColors.primaryColor,
        selectedItemColor: CustomColors.pinkColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.white,
        unselectedLabelStyle:
            ThemeValueExtension.subtitle3.copyWith(fontWeight: FontWeight.w500),
        selectedLabelStyle:
            ThemeValueExtension.subtitle3.copyWith(fontWeight: FontWeight.bold),
        iconSize: iconSize,
        currentIndex: _selectedItemPosition,
        onTap: changeState,
        items: items(),
      ),
    );
  }

  void changeState(value) {
    setState(() {
      _selectedItemPosition = value;
    });
  }

  Container _floatingActionButton() {
    return Container(
      height: 7.5.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: CustomColors.primaryColor, width: thickness)),
      child: FloatingActionButton(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        backgroundColor:
            _selectedItemPosition == 2 ? CustomColors.pinkColor : Colors.white,
        elevation: 0,
        onPressed: changeToMainState,
        child: Icon(
          Icons.business,
          color: _selectedItemPosition == 2 ? Colors.white : Colors.pink,
          size: 32,
        ),
      ),
    );
  }

  void changeToMainState() {
    setState(() {
      _selectedItemPosition = 2;
    });
  }

  showPage(int selectedItemPosition) {
    switch (selectedItemPosition) {
      case 0:
        return const AddUserPage();
      case 1:
        return const CustomerRequests();
      case 2:
        return const AdminDashboard();
      case 3:
        return const Crisis();
      case 4:
        return const ExpertVisits();
      default:
        break;
    }
  }

  List<BottomNavigationBarItem> items() {
    return [
      bottomNavigationBarItem(Icons.add_circle_outline, 'Ekle'),
      bottomNavigationBarItem(Icons.circle_notifications_outlined, 'Talepler'),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.5.h),
            child:  Icon(
              Icons.abc_outlined,
              color: Colors.transparent,
              size: 4.h,
            ),
          ),
          label: 'Yönetim'),
      bottomNavigationBarItem(Icons.crisis_alert, 'Olaylar'),
      bottomNavigationBarItem(Icons.checklist_rtl_sharp, 'Ziyaretler'),
    ];
  }

  BottomNavigationBarItem bottomNavigationBarItem(
      IconData iconData, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: Icon(iconData,size: 4.h,),
        ),
        label: label);
  }


}
