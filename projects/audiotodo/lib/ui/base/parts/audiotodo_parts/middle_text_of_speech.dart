import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audiotodo/core/theme/custom_colors.dart';
import 'package:audiotodo/utilities/constants/extensions/context_extension.dart';
import 'package:audiotodo/utilities/constants/extensions/edge_extension.dart';
import 'package:audiotodo/utilities/constants/extensions/ui_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../line/viewmodel/global_providers.dart';
import '../../../../main.dart';
import '../../../../utilities/components/buttons/neu_text_button.dart';
import '../../../../utilities/constants/enums/audio_steppers.dart';
import 'audio_step_idle_of_middle.dart';

class MiddleTextOfSpeech extends ConsumerStatefulWidget {
  const MiddleTextOfSpeech({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MiddleTextOfSpeechState();
}

class _MiddleTextOfSpeechState extends ConsumerState<MiddleTextOfSpeech>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, customRef, child) {
        final audioStep = customRef.watch(currentAudioStepManager);

        switch (audioStep) {
          case AudioToDoSteps.idle:
            _animationController.reverse();
            break;
          case AudioToDoSteps.record:
            _animationController.forward();
            break;
          case AudioToDoSteps.waitingResponse:
            // TODO: Handle this case.
            break;
          case AudioToDoSteps.results:
            // TODO: Handle this case.
            break;
          case AudioToDoSteps.shareWith:
            // TODO: Handle this case.
            break;
          case AudioToDoSteps.endOfAudio:
            // TODO: Handle this case.
            break;
        }

        return audioStep == AudioToDoSteps.idle
            ? const AudioStepIdleOfMiddle()
            : Stack(
                children: [
                  Container(
                    height: 47.h,
                    decoration: BoxDecoration(
                      color: CustomColors.backGreyColor.withOpacity(0.3),
                      borderRadius: CustomBorder.onlyBottomHugeRadius,
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.backGreyColor.withOpacity(0.3),
                          spreadRadius: -6,
                          blurRadius: 25,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: EdgeExtension.hugeEdge.edgeValue,
                          left: EdgeExtension.customNormal1.edgeValue,
                          right: EdgeExtension.customNormal1.edgeValue,
                        ),
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.fillWhiteColor,
                              borderRadius: CustomBorder.allHighRadius,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: -2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    EdgeExtension.mediumEdge.edgeValue),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                      TypewriterAnimatedText(
                                        ref
                                                .watch(
                                                    currentMeetControllerManager)
                                                ?.meetContent ??
                                            "",
                                        textStyle: ThemeValueExtension.subtitle
                                            .copyWith(
                                                fontStyle: FontStyle.italic),
                                        speed: const Duration(milliseconds: 25)
                                      ),
                                  ],
                                  totalRepeatCount: 1,
                                  repeatForever: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: NeuTextButton(
                        text: 'Bitir',
                        onPressed: () => ref
                            .read(currentMeetControllerManager.notifier)
                            .stopMeeting(ref),
                      ),
                    ),
                  )
                ],
              );
      },
    );
  }
}
