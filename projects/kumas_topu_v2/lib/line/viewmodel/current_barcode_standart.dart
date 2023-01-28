




import 'package:kumas_topu/models/encode_standarts.dart';
import 'package:state_notifier/state_notifier.dart';

class CurrentBarcodeStandartManager extends StateNotifier<PerStandart?>{
  CurrentBarcodeStandartManager(PerStandart? state) : super(null);

  changeState(PerStandart? value){
    state = value;
  }
}