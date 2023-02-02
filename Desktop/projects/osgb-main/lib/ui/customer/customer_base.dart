import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:osgb/ui/customer/pages/add_worker.dart';
import 'package:osgb/ui/customer/pages/customer_crises.dart';
import 'package:osgb/ui/customer/pages/customer_dashboard.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/constants/extension/context_extensions.dart';
import '../../utilities/init/theme/custom_colors.dart';
import '../admin/admin_widgets/custom_drawer.dart';

class CustomerBase extends StatefulWidget {
  const CustomerBase({Key? key}) : super(key: key);

  @override
  State<CustomerBase> createState() => _CustomerBaseState();
}

class _CustomerBaseState extends State<CustomerBase> {
  late int _selectedItemPosition = 1;
  static const iconSize = 36.0;
  static const thickness = 3.0;
  late AdvancedDrawerController _advancedDrawerController;


  @override
  void initState() {
    super.initState();
    _advancedDrawerController = AdvancedDrawerController();
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
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: buildNavigationBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _floatingActionButton(),
        body: showPage(_selectedItemPosition),
      ),
    );
  }

  String appBarTitle() => "SU OSGB";

  Theme buildNavigationBar(BuildContext context) {
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
        unselectedLabelStyle: ThemeValueExtension.subtitle3
            .copyWith(fontWeight: FontWeight.w500),
        selectedLabelStyle: ThemeValueExtension.subtitle3
            .copyWith(fontWeight: FontWeight.bold),
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
      height: 8.8.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: CustomColors.primaryColor, width: thickness)),
      child: FloatingActionButton(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        backgroundColor:
            _selectedItemPosition == 1 ? CustomColors.pinkColor : Colors.white,
        elevation: 0,
        onPressed: changeToMainState,
        child: Icon(
          Icons.business,
          color: _selectedItemPosition == 1 ? Colors.white : Colors.pink,
          size: 32,
        ),
      ),
    );
  }

  void changeToMainState() {
    setState(() {
      _selectedItemPosition = 1;
    });
  }

  showPage(int selectedItemPosition) {
    switch (selectedItemPosition) {
      case 0:
        return const AddWorker();
      case 1:
        return const CustomerDashboard();
      case 2:
        return const CustomerCrises();
      default:
        break;
    }
  }

  List<BottomNavigationBarItem> items() {
    return [
      bottomNavigationBarItem(Icons.add_circle_outline, 'Talep Bildir'),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.5.h),
            child: const Icon(
              Icons.abc_outlined,
              color: Colors.transparent,
            ),
          ),
          label: 'Yönetim'),
      bottomNavigationBarItem(Icons.crisis_alert, 'Olay Bildir'),
    ];
  }

  BottomNavigationBarItem bottomNavigationBarItem(
      IconData iconData, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: Icon(iconData),
        ),
        label: label);
  }
}
