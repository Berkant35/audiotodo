import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/utilities/constants/enums/audio_steppers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/theme/custom_colors.dart';
import '../../constants/enums/record_states.dart';

class PlayStopButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final double iconSize;
  const PlayStopButton(
      {Key? key, required this.onPressed,required this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NeumorphicButton(
      minDistance: -5.0,
      style: const NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
          color: CustomColors.fillWhiteColor),
      onPressed: onPressed,

      child: Center(
        child: Icon(
          ref.watch(currentRecordStateManager) != RecordStates.recording
              ? Icons.play_arrow
              : Icons.stop,
          color: CustomColors.primaryColor,
          size: iconSize,
        ),
      ),
    );
  }
}
