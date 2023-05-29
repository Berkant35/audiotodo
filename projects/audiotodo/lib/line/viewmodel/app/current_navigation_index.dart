


import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentNavigationIndex extends StateNotifier<int> {
  CurrentNavigationIndex(int state) : super(1);

  changeState(int currentIndex) {
    state = currentIndex;
  }

}