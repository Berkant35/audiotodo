


import 'package:osgb/models/accident_case.dart';
import 'package:state_notifier/state_notifier.dart';

class CurrentCrisisManager extends StateNotifier<AccidentCase?> {
  CurrentCrisisManager(AccidentCase? state) : super(null);


  void changeCurrentInspection(AccidentCase accidentCase) {
    state = accidentCase;
  }

}