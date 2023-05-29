import 'package:audiotodo/utilities/constants/enums/audio_steppers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentAudioStepManagerNotifier extends StateNotifier<AudioToDoSteps> {
  CurrentAudioStepManagerNotifier(AudioToDoSteps state) : super(AudioToDoSteps.idle);

  void changeState(AudioToDoSteps step) => state = step;

}
