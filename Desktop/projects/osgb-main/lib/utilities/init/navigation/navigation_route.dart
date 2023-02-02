import 'package:flutter/material.dart';
import 'package:osgb/models/wait_fix.dart';
import 'package:osgb/ui/accountant/customer_accountant_detail.dart';
import 'package:osgb/ui/admin/admin_base.dart';
import 'package:osgb/ui/admin/pages/directions/add_inspection.dart';
import 'package:osgb/ui/auth/choose_role.dart';
import 'package:osgb/ui/auth/login_page.dart';
import 'package:osgb/ui/customer/customer_base.dart';
import 'package:osgb/ui/details/commons/crisis_detail.dart';
import 'package:osgb/ui/details/commons/waiting_inspection_details.dart';
import 'package:osgb/ui/error/not_found.dart';
import 'package:osgb/ui/expert/expert_base.dart';
import 'package:osgb/ui/expert/pages/directions/add_wait_fix.dart';
import 'package:osgb/ui/expert/pages/directions/do_audit.dart';
import 'package:osgb/ui/expert/pages/directions/wait_fix_detail.dart';
import 'package:osgb/ui/landing_page.dart';
import '../../../models/customer.dart';
import '../../../models/inspection.dart';
import '../../../ui/accountant/accountant_base.dart';
import '../../../ui/common/update_password.dart';
import '../../../ui/customer/pages/crisis_pages/add_crises.dart';
import '../../../ui/details/commons/done_inspection_details.dart';
import 'navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();

  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.loginPage:
        return normalNavigate(const LoginPage());
      case NavigationConstants.adminBasePage:
        return normalNavigate(const AdminBase());
      case NavigationConstants.chooseRolePage:
        return normalNavigate(const ChooseRole());
      case NavigationConstants.landingPage:
        return normalNavigate(const LandingPage());
      case NavigationConstants.addCrisesPage:
        return normalNavigate(const AddCrises());
      case NavigationConstants.customerBasePage:
        return normalNavigate(const CustomerBase());
      case NavigationConstants.expertBasePage:
        return normalNavigate(const ExpertBase());
      case NavigationConstants.accountantBasePage:
        return normalNavigate(const AccountantBase());
      case NavigationConstants.updatePasswordPage:
        return normalNavigate(const UpdatePassword());
      case NavigationConstants.customerAccountantDetailPage:
        Map<String, dynamic> argument = args.arguments as Map<String, dynamic>;

        return normalNavigate(CustomerAccountantDetail(
          customer: Customer.fromJson(argument),
        ));
      case NavigationConstants.crisisDetailPage:
        return normalNavigate(const CrisisDetail());
      case NavigationConstants.waitingInspectionDetails:
        Map<String, dynamic> argument = args.arguments as Map<String, dynamic>;

        return normalNavigate(WaitingInspectionDetails(
          showDeleteButton: argument['showDeleteButton'],
        ));
      case NavigationConstants.doneInspectionDetails:
        return normalNavigate(const DoneInspectionDetails());
      case NavigationConstants.doAuditPage:
        return normalNavigate(const DoAudit());
      case NavigationConstants.addWaitFix:
        Map<String, dynamic> argument = args.arguments as Map<String, dynamic>;

        return normalNavigate(
            AddWaitFix(inspection: Inspection.fromJson(argument)));
      case NavigationConstants.waitFixDetailPage:
        Map<String, dynamic> argument = args.arguments as Map<String, dynamic>;
        return normalNavigate(WaitFixDetail(
          waitFix: WaitFix.fromJson(argument["waitFix"]),
          inspection: Inspection.fromJson(
            argument["inspection"],
          ),
          showDeleteButton: argument['showDeleteButton'],
        ));
      case NavigationConstants.addInspectionPage:
        return normalNavigate(const AddInspection());
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFound(),
        );
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }
}
