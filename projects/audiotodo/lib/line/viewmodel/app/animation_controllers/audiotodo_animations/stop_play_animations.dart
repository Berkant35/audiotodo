import 'package:flutter/animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonPositionNotifier extends StateNotifier<Tween?> {
  ButtonPositionNotifier() : super(null);
  /*_animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _offsetAnimation = Tween<Offset>(
      begin: ani  ?  Offset(0, 0) : Offset(-0.36, -1.08),
      end: ani  ?  Offset(-0.36, -1.08) : Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));*/

}
