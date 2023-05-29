import 'dart:io';
import 'dart:typed_data';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audiotodo/core/navigation/navigation_constants.dart';
import 'package:audiotodo/core/navigation/navigation_service.dart';
import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/main.dart';
import 'package:audiotodo/utilities/constants/enums/record_states.dart';
import 'package:audiotodo/utilities/constants/exceptions/record_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../utilities/constants/extensions/time_extension.dart';

enum SoundFileTypes { m4a }

class RecorderControllerNotifier extends StateNotifier<RecorderController?> {
  RecorderControllerNotifier(RecorderController? state) : super(null);

  Map<String, String> currentMeetRecords = {};

  /// [sampleRate]: Ne kadar ayrıntılı ses kaydı alalım 44.1 hertz gibi bir defaul değeri var.
  /// [bitRate]: Saniyede kaç bit alabiliyoruz kaydedebiliyoruz data verişi oluyor gibi*

  Future<void> initializeRecorderController(WidgetRef ref) async {
    try {
      logger.i("Recording initialize...");
      state = RecorderController()
          //..iosEncoder = IosEncoder.kAudioFormatLinearPCM
          //..androidEncoder = AndroidEncoder.aac
          //..androidOutputFormat = AndroidOutputFormat.mpeg4
          ;
    } catch (e) {
      logger.e("InitalizeRecordController $e");
      RecordExceptions.handleRecordException("Not initialized", ref);
    }
  }

  //TODO THIS FUNCTION START RECORDING
  Future<void> startRecord(WidgetRef ref) async {
    try {
      if (state == null) {
        await initializeRecorderController(ref);
      }

      ref
          .read(currentRecordStateManager.notifier)
          .changeRecordState(RecordStates.recording);

      final hasPermission = await state!.checkPermission();

      if (!hasPermission) {
        await ref
            .read(currentPermissionControllerManager.notifier)
            .giveGrantedToAllPermissions();
      }
      final recordName = DateTime.now().nowTimeTextddMMyyyyHHmm;
      final mainPath = await _localPath;
      final path = "$mainPath/$recordName.${SoundFileTypes.m4a}";

      currentMeetRecords
          .addAll({ref.read(currentMeetControllerManager)!.meetId!: path});


      await state!.record(path: path);
    } catch (e) {
      logger.e(state != null);
      logger.e(e);
    }
  }

  Future<void> pause(WidgetRef ref) async {
    ref
        .read(currentRecordStateManager.notifier)
        .changeRecordState(RecordStates.stopped);
    await state!.pause();
  }

  Future<void> stop(WidgetRef ref) async {
    ref
        .read(currentRecordStateManager.notifier)
        .changeRecordState(RecordStates.idle);
    await state!.stop();

    // TODO ARADA MEET MODELIMIZI GUZEL BIR SEKİLDE GUNCELLEYELİM
  }

  Future<void> resume(WidgetRef ref) async {
    ref
        .read(currentRecordStateManager.notifier)
        .changeRecordState(RecordStates.recording);

    if (ref.read(currentMeetControllerManager) != null) {
      await state!.record(
          path: currentMeetRecords[
              ref.read(currentMeetControllerManager)!.meetId]);
    } else {
      startRecord(ref);
    }
  }

  Future<void> disposeRecord(WidgetRef ref) async {
    ref
        .read(currentRecordStateManager.notifier)
        .changeRecordState(RecordStates.idle);
    state!.dispose();
  }

  Future<String> get _localPath async {
    logger.i("Local Path created!");
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
