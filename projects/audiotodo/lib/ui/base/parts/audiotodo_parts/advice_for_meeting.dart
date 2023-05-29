import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audiotodo/utilities/constants/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/custom_colors.dart';
import '../../../../line/viewmodel/global_providers.dart';
import '../../../../utilities/constants/enums/audio_steppers.dart';

class AdviceForMeeting extends ConsumerStatefulWidget {
  const AdviceForMeeting({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AdviceForMeetingState();
}

class _AdviceForMeetingState extends ConsumerState<AdviceForMeeting> {
  List<String> demoExamples = [
    "This is a advice for meeting",
    "Maybe you should remember last meeting",
    "Maybe we define a date for next meet right now"
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, customRef, child) {
        final audioStep = customRef.watch(currentAudioStepManager);

        return Container(
          width: 100.w,
          color: CustomColors.backGreyColor.withOpacity(0.3),
          child: audioStep == AudioToDoSteps.record
              ? Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      for (int i = 0; i < demoExamples.length; i++)
                        RotateAnimatedText(
                          "“${demoExamples[i]}”",
                          textStyle: ThemeValueExtension.subtitle
                              .copyWith(fontStyle: FontStyle.italic),
                          duration: const Duration(milliseconds: 4000),
                        ),
                    ],
                    totalRepeatCount: 1,
                    repeatForever: true,
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
