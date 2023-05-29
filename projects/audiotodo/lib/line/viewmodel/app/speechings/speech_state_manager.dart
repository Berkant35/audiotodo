import 'package:audiotodo/utilities/constants/enums/speech_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeechStateNotifier extends StateNotifier<SpeechStates> {
  SpeechStateNotifier(SpeechStates? state) : super(SpeechStates.idle);

  void changeStateOfSpeechState(SpeechStates value,WidgetRef ref)
  {
    state = value;
  }

}
