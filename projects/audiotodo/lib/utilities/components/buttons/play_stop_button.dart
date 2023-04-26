

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayStopButton extends ConsumerWidget {
  final VoidCallback onPressed;
  const PlayStopButton({
    Key? key,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NeumorphicButton(
      minDistance: -5.0,
      style: const NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
      ),
      onPressed: onPressed,
      padding: const EdgeInsets.all(18.0),
      child: Icon(Icons.play_arrow),
    );
  }
}
