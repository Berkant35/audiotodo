import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/utilities/components/buttons/custom_play_stop_button.dart';
import 'package:audiotodo/utilities/constants/enums/audio_steppers.dart';
import 'package:audiotodo/utilities/constants/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/custom_colors.dart';
import '../../../../generated/l10n.dart';

class AudioStepIdleOfMiddle extends ConsumerStatefulWidget {
  const AudioStepIdleOfMiddle({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AudioStepIdleOfMiddleState();
}

class _AudioStepIdleOfMiddleState extends ConsumerState<AudioStepIdleOfMiddle>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.slowMiddle,
      // İsteğe bağlı, geçiş eğrisini belirleyebilirsiniz
      width:
          ref.watch(currentAudioStepManager) == AudioToDoSteps.idle ? 100.w : 0,
      color: CustomColors.backGreyColor.withOpacity(0.3),
      child: Column(
        children: [
          CustomPlayStopButton(
            onPressed: () async {
              ref
                  .read(currentAudioStepManager.notifier)
                  .changeState(AudioToDoSteps.record);
            },
            circleRadius: 35.w,
            iconSize: 12.h,
          ),
          SizedBox(height: 4.h),
          Text(
            S.current.press_for_meet,
            style: ThemeValueExtension.titleTextStyle.copyWith(
                color: CustomColors.greyColor, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
