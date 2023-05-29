import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/ui/base/parts/audiotodo_parts/advice_for_meeting.dart';
import 'package:audiotodo/ui/base/parts/audiotodo_parts/control_record.dart';
import 'package:audiotodo/ui/base/parts/audiotodo_parts/middle_text_of_speech.dart';
import 'package:audiotodo/ui/base/parts/audiotodo_parts/top_record_control.dart';
import 'package:audiotodo/utilities/components/containers/custom_bar_container.dart';
import 'package:audiotodo/utilities/constants/enums/audio_steppers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../core/theme/custom_colors.dart';
import '../../generated/l10n.dart';

class AudioToDoPage extends ConsumerStatefulWidget {
  const AudioToDoPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AudioToDoPageState();
}

class _AudioToDoPageState extends ConsumerState<AudioToDoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(flex: 8, child: TopRecordControl()),
        const Expanded(flex: 2, child: AdviceForMeeting()),
        const Expanded(flex: 15, child: MiddleTextOfSpeech()),
        Expanded(
            flex: 2,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 200), // Animasyon süresi (milisaniye cinsinden)
                curve: Curves.easeInOut,
                color: ref.watch(currentAudioStepManager) == AudioToDoSteps.idle
                    ? CustomColors.backGreyColor.withOpacity(0.3)
                    : CustomColors.fillWhiteColor))
      ],
    );
  }
}
