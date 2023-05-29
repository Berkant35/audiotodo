import 'package:audiotodo/utilities/constants/enums/record_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class RecordStateManagerNotifier extends StateNotifier<RecordStates> {
  RecordStateManagerNotifier(RecordStates states) : super(RecordStates.idle);

  void changeRecordState(RecordStates newState) {
    state = newState;
  }


}
