import 'dart:ui' as ui;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../line/viewmodel/global_providers.dart';
import '../../../../../utilities/components/buttons/custom_play_stop_button.dart';

class RecordingControlWidget extends ConsumerStatefulWidget {
  const RecordingControlWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _RecordingControlWidgetState();
}

class _RecordingControlWidgetState
    extends ConsumerState<RecordingControlWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomPlayStopButton(
          onPressed: () => ref.read(currentMeetControllerManager.notifier).controlMeetingManageButton(ref),
          circleRadius: 20.w,
          iconSize: 3.h,
        ),
        _recordWaves(context)
      ],
    );
  }

  Widget _recordWaves(BuildContext context) {
    return ref.watch(currentRecorderControllerManager) != null
        ? AudioWaveforms(
            size: Size(40.w, 7.h),
            recorderController: ref.watch(currentRecorderControllerManager)!,
            enableGesture: true,
            waveStyle: WaveStyle(
              waveColor: Colors.white,
              showDurationLabel: true,
              spacing: 8.0,
              showBottom: false,
              extendWaveform: true,
              showMiddleLine: false,
              gradient: ui.Gradient.linear(
                const Offset(70, 50),
                Offset(MediaQuery.of(context).size.width / 2, 0),
                [Colors.red, Colors.green],
              ),
            ),
          )
        : const SizedBox();
  }


}
