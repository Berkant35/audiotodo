


import 'package:audiotodo/models/meet/word_match_time.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef CurrentWordMatchTimeMap = Map<String,WordMatchTime>;


class CurrentWordMatchTimeMapNotifier extends StateNotifier<CurrentWordMatchTimeMap> {
  CurrentWordMatchTimeMapNotifier(CurrentWordMatchTimeMap state) : super({});


}