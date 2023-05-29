import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/utilities/constants/enums/audio_steppers.dart';
import 'package:audiotodo/utilities/constants/enums/record_states.dart';
import 'package:audiotodo/utilities/constants/enums/speech_states.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../../models/meet/meet_model.dart';
import '../../../utilities/constants/exceptions/record_exceptions.dart';

class CurrentMeetManagerNotifier extends StateNotifier<Meet?> {
  CurrentMeetManagerNotifier(Meet? state) : super(null);
  Meet? lastMeet;

  void initialize(WidgetRef ref) {
    if (state != null) {
      state = null;
    }
    final uniqueId = ref.read(currentUUIDManager.notifier).getV1UUID(ref);
    state = Meet(meetId: uniqueId);
  }

  void addContent(String content) {

    state = state!.copyWith(meetContent: content);
  }

  Future<void> controlMeetingManageButton(WidgetRef pRef) async {
    if (pRef.read(currentSpeechToTextManager) == null ||
        pRef.read(currentRecorderControllerManager) == null) {
      logger.i("initializing...");
      await initializeAudioToDo(pRef);
    }

    final currentRecordState = pRef.read(currentRecordStateManager);
    final currentSpeechState = pRef.read(currentSpeechStateManager);

    //This case mean not started any meet yet
    if (currentRecordState == RecordStates.idle &&
        currentSpeechState == SpeechStates.idle) {
      pRef.read(currentMeetControllerManager.notifier).initialize(pRef);
      pRef.read(currentMeetControllerManager.notifier).startMeeting(pRef);

      //We have already started a meeting
    } else if (currentRecordState == RecordStates.recording &&
        currentSpeechState == SpeechStates.listening) {
      pRef.read(currentRecorderControllerManager.notifier).pause(pRef);
      pRef.read(currentSpeechToTextManager.notifier).stopListening(pRef);

      //We have a meeting but stop case
    } else if (currentRecordState == RecordStates.stopped &&
        currentSpeechState == SpeechStates.stopping) {
      pRef.read(currentRecorderControllerManager.notifier).resume(pRef);
      pRef.read(currentSpeechToTextManager.notifier).startListening(pRef);
    } else {
      //Shit!

      logger.i(
          "Current Record State: $currentRecordState \n Current Speech State: $currentSpeechState");

      RecordExceptions.handleRecordException(
          "Unsupported case i guess we have a big logic mistake!", pRef);
    }
  }

  Future<void> initializeAudioToDo(WidgetRef pref) async {
    pref.read(currentMeetControllerManager.notifier).initialize(pref);
    pref.read(currentSpeechToTextManager.notifier).initSpeechToText(pref);
    pref
        .read(currentRecorderControllerManager.notifier)
        .initializeRecorderController(pref);
  }

  Future<void> startMeeting(WidgetRef ref) async {
    logger.i("Start Meeting.");

    final tempTitle = DateTime.now().toString().substring(0, 16);
    ref
        .read(currentAudioStepManager.notifier)
        .changeState(AudioToDoSteps.record);
    state = state!.copyWith(meetTitle: tempTitle,meetContent: "");
    List<Future> list = [
      ref.read(currentSpeechToTextManager.notifier).startListening(ref),
      ref.read(currentRecorderControllerManager.notifier).startRecord(ref)
    ];

    await Future.wait(list);
  }

  Future<void> stopMeeting(WidgetRef ref) async {
    if (state != null) {
      //TODO YOU MUST CHANGE

      ref
          .read(currentAudioStepManager.notifier)
          .changeState(AudioToDoSteps.idle);

      await ref.read(currentSpeechToTextManager.notifier).stopListening(ref);

      ref.read(currentRecorderControllerManager.notifier).stop(ref);

      ref
          .read(currentRecordStateManager.notifier)
          .changeRecordState(RecordStates.idle);
      ref
          .read(currentSpeechStateManager.notifier)
          .changeStateOfSpeechState(SpeechStates.idle, ref);

      //record last meet to this state
      lastMeet = state;
      state = null;
    } else {
      logger.i("Already stopped!");
    }
  }
}
