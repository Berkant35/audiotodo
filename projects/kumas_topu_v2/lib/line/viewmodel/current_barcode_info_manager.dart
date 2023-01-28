



import 'package:state_notifier/state_notifier.dart';

import '../../models/barcode_info.dart';
import '../../utilities/init/navigation/navigation_service.dart';

class CurrentBarcodeInfoManager extends StateNotifier<BarcodeInfo>{
  CurrentBarcodeInfoManager(BarcodeInfo state) : super(BarcodeInfo());

  changeState(BarcodeInfo value){
    state = value;

  }
}
