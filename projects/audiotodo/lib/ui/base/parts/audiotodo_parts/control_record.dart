import 'dart:ui' as ui;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audiotodo/line/viewmodel/global_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


import '../../../../utilities/components/buttons/neu_text_button.dart';
import '../../../../utilities/constants/enums/record_states.dart';

class ControlRecord extends ConsumerStatefulWidget {
  const ControlRecord({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ControlRecordState();
}

class _ControlRecordState extends ConsumerState<ControlRecord> {
  @override
  Widget build(BuildContext context) {
    return NeuTextButton(
      text: 'Bitir',
      onPressed: () => ref
          .read(currentMeetControllerManager.notifier)
          .stopMeeting(ref),
    );
  }

  Widget _recordWaves(BuildContext context) {
    return ref.watch(currentRecorderControllerManager) != null
        ? AudioWaveforms(
            size: Size(MediaQuery.of(context).size.width, 200.0),
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
