



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/app_view_models/appBar_managers/custom_flexible_model.dart';
import 'package:osgb/utilities/components/custom_flexible_bar.dart';

class FlexibleAppBarContentManager extends StateNotifier<CustomFlexibleModel>{
  FlexibleAppBarContentManager(CustomFlexibleModel state) : super(CustomFlexibleModel());

  changeContentFlexibleManager(CustomFlexibleModel customFlexibleBar){
    state = customFlexibleBar;
  }

}