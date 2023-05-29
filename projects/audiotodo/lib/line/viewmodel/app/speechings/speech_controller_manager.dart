import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/main.dart';
import 'package:audiotodo/utilities/components/dialogs/record_dialogs.dart';
import 'package:audiotodo/utilities/constants/exceptions/record_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../utilities/constants/enums/speech_states.dart';

// A StateNotifier class that wraps the SpeechToText class provided by the speech_to_text package
// It allows you to handle the state of the SpeechToText class with a StateNotifier
// In this case, it also has some extra functionality that is specific to the app
class SpeechToTextNotifier extends StateNotifier<SpeechToText?> {
  // Constructor for the SpeechToTextNotifier class
  // Initializes the state to null since the SpeechToText class hasn't been created yet
  SpeechToTextNotifier(SpeechToText? state) : super(null);

  // A constant duration for the final timeout of the speech recognition process
  final finalTimeOut = const Duration(seconds: 5);

  // A method to initialize the SpeechToText class
  // It checks if the state is null and then creates a new SpeechToText object
  // It also initializes the speech recognition options and error listeners
  Future<void> initSpeechToText(WidgetRef ref) async {
    if (state == null) {
      logger.i("Initialize");

      state = SpeechToText();

      await state!.initialize(
          onError: (sR) => initializeErrorListener(sR, ref),
          options: [],
          debugLogging: kDebugMode,
          finalTimeout: finalTimeOut,
          onStatus: (sListener) => speechStatusListener(sListener, ref));
    }
  }

  // A method to stop listening for speech input
  // It uses the stop() method provided by the SpeechToText class
  // It also handles any exceptions that may occur during the process
  Future<void> stopListening(WidgetRef ref) async {
    try {
      await state!.stop();
      ref
          .read(currentSpeechStateManager.notifier)
          .changeStateOfSpeechState(SpeechStates.stopping, ref);
    } catch (e) {
      RecordExceptions.handleRecordException(e.toString(), ref,
          title: "Stop Listening For Speech To Text Notifier");
    }
  }

  // A method to cancel the speech recognition process
  // It uses the cancel() method provided by the SpeechToText class
  // It also handles any exceptions that may occur during the process
  Future<void> cancelFromSpeechToText(WidgetRef ref) async {
    try {
      await state!.cancel();
    } catch (e) {
      RecordExceptions.handleRecordException(e.toString(), ref,
          title: "Cancel From Speech To Text For Speech To Text Notifier");
    }
  }

  // A method to get a list of available locales for speech recognition
  // It uses the locales() method provided by the SpeechToText class
  // It also handles any exceptions that may occur during the process
  Future<List<LocaleName>> getLocales(WidgetRef ref) async {
    try {
      return await state!.locales();
    } catch (e) {
      RecordExceptions.handleRecordException(e.toString(), ref);
      return [];
    }
  }

  // A method to get the system's current locale for speech recognition
  // It uses the systemLocale() method provided by the SpeechToText class
  // It also handles any exceptions that may occur during the process
  Future<LocaleName?> getSystemLocaleName(WidgetRef ref) async {
    try {
      return await state!.systemLocale();
    } catch (e) {
      RecordExceptions.handleRecordException(e.toString(), ref);
      return null;
    }
  }

  // A method to start listening for speech input
  // It checks if the user has the necessary permission and if the SpeechToText class is available
  // If so, it starts the speech recognition process and registers callbacks for sound level change, device availability, and speech recognition result
  // If not, it displays appropriate dialogs or requests permission
  Future<void> startListening(WidgetRef ref) async {
    try {
      final hasPermission = await state!.hasPermission;

      if (hasPermission) {
        ref
            .read(currentSpeechStateManager.notifier)
            .changeStateOfSpeechState(SpeechStates.listening, ref);

        await state!.listen(
          onSoundLevelChange: (val) => onSoundLevelChange(ref),
          //onDevice: (val) => onDevice(ref),
          onResult: (val) => onResult(val, ref),
        );
      } else {
        ref
            .read(currentPermissionControllerManager.notifier)
            .giveGrantedToAllPermissions();
      }
    } on Exception catch (e) {
      RecordExceptions.handleRecordException(e.toString(), ref,
          title: "Start Listening For Speech To Text Notifier");
    }
  }

  // A callback method for the speech recognition result
  // It is invoked when a speech recognition result is available
  // In this case, it logs the recognition result
  onResult(SpeechRecognitionResult recognitionResult, WidgetRef ref) {
    ref
        .read(currentMeetControllerManager.notifier)
        .addContent(recognitionResult.recognizedWords);
  }

  // A callback method for the device availability
  // It is invoked when the availability of the speech recognition device changes
  // In this case, it logs the device availability value
  onDevice(WidgetRef ref) {}

  // A callback method for the sound level change
  // It is invoked when the sound level changes during speech recognition
  // In this case, it logs the sound level value
  onSoundLevelChange(WidgetRef ref) {}

  // A method to handle the speech recognition status reported by the library
  // It is invoked when the speech recognition status changes
  // In this case, it logs the speech status and performs specific actions based on the status
  speechStatusListener(String sListener, WidgetRef ref) {
    switch (sListener) {
      case 'listening':
        break;
      case 'notListening':
        break;
      case 'done':
        break;
      default:
    }
  }

  void initializeErrorListener(
      SpeechRecognitionError speechRecognitionError, WidgetRef ref) {
    logger.e(speechRecognitionError.errorMsg);
    RecordExceptions.handleRecordException(
        speechRecognitionError.errorMsg, ref);
  }
}
