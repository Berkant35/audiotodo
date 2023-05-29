import 'package:audiotodo/line/viewmodel/global_providers.dart';
import 'package:audiotodo/main.dart';
import 'package:audiotodo/ui/base/parts/audiotodo_parts/top_record_widgets/recording_control_widget.dart';
import 'package:audiotodo/utilities/constants/enums/audio_steppers.dart';
import 'package:audiotodo/utilities/constants/extensions/ui_extensions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/custom_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../../utilities/components/containers/custom_bar_container.dart';
import 'top_record_widgets/sub_content.dart';

class TopRecordControl extends ConsumerStatefulWidget {
  const TopRecordControl({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _TopRecordControlState();
}

class _TopRecordControlState extends ConsumerState<TopRecordControl>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
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
    return Consumer(builder: (context, customRef, child) {
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

      logger.i("Changin Auido Step $audioStep");

      return Container(
        color: CustomColors.backGreyColor.withOpacity(0.3),
        child: Stack(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Stack(
                children: [
                  Container(
                    width: 100.w,
                    height: 23.5.h,
                    decoration: CustomBoxDecoration.customType2BoxDecoration,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 85.w,
                      height: 8.h,
                      color: Colors.white,
                      child: const RecordingControlWidget(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 60.w,
                      height: 8.h,
                      decoration: CustomBoxDecoration.customType1BoxDecoration,
                      child: const SubContent(),
                    ),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: CustomBarContainer(text: S.current.record)),

          ],
        ),
      );
    });
  }
}

