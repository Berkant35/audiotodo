import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audiotodo/line/viewmodel/app/record/record_state_manager.dart';
import 'package:audiotodo/line/viewmodel/app/speechings/speech_controller_manager.dart';
import 'package:audiotodo/line/viewmodel/app/speechings/speech_state_manager.dart';
import 'package:audiotodo/line/viewmodel/audiotodo/current_meet_manager.dart';
import 'package:audiotodo/line/viewmodel/audiotodo/word_match_times.dart';
import 'package:audiotodo/line/viewmodel/permission/permission_manager.dart';
import 'package:audiotodo/models/meet/word_match_time.dart';
import 'package:audiotodo/models/user_model.dart';
import 'package:audiotodo/utilities/constants/enums/audio_steppers.dart';
import 'package:audiotodo/utilities/constants/enums/loading_states.dart';
import 'package:audiotodo/utilities/constants/enums/speech_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';

import '../../models/meet/meet_model.dart';
import '../../utilities/constants/enums/record_states.dart';
import 'app/a_loading_manager.dart';
import 'app/all_loading_managers.dart';
import 'app/current_navigation_index.dart';
import 'app/record/recorder_controller_manager.dart';
import 'app/uuid_manager.dart';
import 'audiotodo/current_audio_step_manager.dart';
import 'auth/auth_manager.dart';

typedef LoadingStateKeyStatusMap = Map<String, LoadingState>;

//You can handle all authentication bussiniess logics
final authManager =
StateNotifierProvider<AuthManagerProvider, UserModel?>((ref) {
  return AuthManagerProvider(null);
});

final currentLoadingStateManager =
StateNotifierProvider<AllLoadingManagers, LoadingStateKeyStatusMap>((ref) {
  return AllLoadingManagers({});
});
final aLoadingStateManager =
StateNotifierProvider<ALoadingManager, LoadingState>((ref) {
  return ALoadingManager(LoadingState.idle);
});

final currentNavigationIndex =
StateNotifierProvider<CurrentNavigationIndex, int>((ref) {
  return CurrentNavigationIndex(0);
});

final currentRecordStateManager =
StateNotifierProvider<RecordStateManagerNotifier, RecordStates>(
        (ref) {
      return RecordStateManagerNotifier(RecordStates.idle);
    });

final currentRecorderControllerManager = StateNotifierProvider.autoDispose<
    RecorderControllerNotifier,
    RecorderController?>((ref) {
  return RecorderControllerNotifier(null);
});

final currentSpeechToTextManager =
StateNotifierProvider<SpeechToTextNotifier, SpeechToText?>(
        (ref) {
      return SpeechToTextNotifier(null);
    });

final currentSpeechStateManager =
StateNotifierProvider<SpeechStateNotifier, SpeechStates>((ref) {
  return SpeechStateNotifier(SpeechStates.idle);
});

final currentPermissionControllerManager = StateNotifierProvider.autoDispose<
    PermissionHandlerNotifier,
    CustomPermissionHandler>((ref) {
  return PermissionHandlerNotifier({});
});

final currentMeetControllerManager =
StateNotifierProvider<CurrentMeetManagerNotifier, Meet?>((ref) {
  return CurrentMeetManagerNotifier(null);
});

final currentWordMatchTimeMapManager = StateNotifierProvider<
    CurrentWordMatchTimeMapNotifier,
    CurrentWordMatchTimeMap>((ref) {
  return CurrentWordMatchTimeMapNotifier({});
});

final currentUUIDManager =
StateNotifierProvider<UUIDManagerNotifier, Uuid?>((ref) {
  return UUIDManagerNotifier(null);
});

final currentAudioStepManager = StateNotifierProvider<
    CurrentAudioStepManagerNotifier,
    AudioToDoSteps>((ref) =>
    CurrentAudioStepManagerNotifier(AudioToDoSteps.idle));
