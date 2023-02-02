import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/accountant_view_models/accountant_work_manager.dart';
import 'package:osgb/line/viewmodel/admin_view_models/admin_work_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import 'package:osgb/line/viewmodel/app_view_models/button_loading_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/loading_base_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/percent_loading_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/tabBar_managers/add_user_tab_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/tabBar_managers/admin_dashboard_tab_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/tabBar_managers/customer_details_tab_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/tabBar_managers/customer_visit_tab_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/tabBar_managers/expert_tab_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/tabBar_managers/visit_tab_manager.dart';
import 'package:osgb/line/viewmodel/app_view_models/user_role_manager.dart';
import 'package:osgb/line/viewmodel/expert_view_models/current_inspection_manager.dart';
import 'package:osgb/line/viewmodel/expert_view_models/expert_work_manager.dart';
import 'package:osgb/line/viewmodel/settings_view_models/notification_view_model.dart';
import 'package:osgb/line/viewmodel/userModel.dart';
import 'package:osgb/models/accident_case.dart';
import 'package:osgb/models/base_user_model.dart';
import 'package:osgb/models/inspection.dart';
import 'package:osgb/models/payment.dart';
import 'package:osgb/utilities/constants/app/enums.dart';

import 'app_view_models/appBar_managers/flexible_content_manager.dart';
import 'app_view_models/tabBar_managers/customer_dashboard_tabbar_manager.dart';
import 'customer_view_models/current_crisis_manager.dart';
import 'customer_view_models/customer_works.dart';
import 'files_view_models/file_view_model.dart';

final currentRole = StateNotifierProvider<UserRoleManager, Roles>((ref) {
  return UserRoleManager(Roles.none);
});

final currentLoadingState =
    StateNotifierProvider<LoadingStateManager, LoadingStates>((ref) {
  return LoadingStateManager(LoadingStates.idle);
});


final currentButtonLoadingState =
StateNotifierProvider<ButtonLoadingManager, LoadingStates>((ref) {
  return ButtonLoadingManager(LoadingStates.idle);
});


final currentInspectionState = StateNotifierProvider<CurrentInspectionManager, Inspection?>((ref) {
  return CurrentInspectionManager(null);
});

final currentCrisisState = StateNotifierProvider<CurrentCrisisManager, AccidentCase?>((ref) {
  return CurrentCrisisManager(null);
});



final currentCustomFlexibleAppBarState = StateNotifierProvider<FlexibleAppBarContentManager, CustomFlexibleModel>((ref) {
  return FlexibleAppBarContentManager(CustomFlexibleModel());
});


final currentAccountantManagerState = StateNotifierProvider<AccountantWorkManager,Payment>((ref){
  return AccountantWorkManager(Payment());
});

final currentBaseModelState =
    StateNotifierProvider<UserModelManager, BaseUserModel>((ref) =>
        UserModelManager(BaseUserModel(
            admin: null, expert: null, customer: null, accountant: null)));

final currentAddUserIndexState = StateNotifierProvider<AddUserTabManager, int>(
    (ref) => AddUserTabManager(0));

final currentVisitTabIndexState = StateNotifierProvider<VisitTabManager, int>(
        (ref) => VisitTabManager(0));

final currentCustomerVisitTabIndexState = StateNotifierProvider<CustomerVisitsTabManager, int>(
        (ref) => CustomerVisitsTabManager(0));

final currentCustomerDetailsTabIndexState = StateNotifierProvider<CustomerDetailsTabBarManager, int>(
        (ref) => CustomerDetailsTabBarManager(0));

final currentAdminDashboardTabManager = StateNotifierProvider<AdminDashboardTabManager, int>(
        (ref) => AdminDashboardTabManager(0));

final currentAddUserCustomerIndexState = StateNotifierProvider<CustomerDashboardTabBarManager, int>(
        (ref) => CustomerDashboardTabBarManager(1));

final currentAdminWorksState = StateNotifierProvider<AdminWorkManager, int>(
        (ref) => AdminWorkManager(0));

final currentExpertWorksState = StateNotifierProvider<ExpertWorkManager, int>(
        (ref) => ExpertWorkManager(0));

final currentCustomerWorksState = StateNotifierProvider<CustomerWorkManager, int>(
        (ref) => CustomerWorkManager(0));

final currentExpertTabState = StateNotifierProvider<ExpertTabManager, int>(
        (ref) => ExpertTabManager(0));

final currentPercentLoadingState = StateNotifierProvider<PercentLoadingManager, int>(
        (ref) => PercentLoadingManager(0));

final currentFileState = StateNotifierProvider<FileViewModel, String?>(
        (ref) => FileViewModel(""));
final currentPushNotificationState = StateNotifierProvider<NotificationManager, String?>(
        (ref) => NotificationManager(""));
