import 'package:state_notifier/state_notifier.dart';

import '../../models/barcode_info.dart';

class CurrentBarcodeInfoManager extends StateNotifier<BarcodeInfo>{
  CurrentBarcodeInfoManager(BarcodeInfo state) : super(BarcodeInfo());

  changeState(BarcodeInfo value)
  {
    state = value;
  }

}
