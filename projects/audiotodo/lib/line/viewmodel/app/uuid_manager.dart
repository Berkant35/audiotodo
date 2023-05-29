import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class UUIDManagerNotifier extends StateNotifier<Uuid?> {
  UUIDManagerNotifier(Uuid? state) : super(null);



  void initialize(WidgetRef ref) {
    state = const Uuid();
  }
  /// Generate a v1 (time-based) id
  String getV1UUID(WidgetRef ref) {
    if (state == null) {
      initialize(ref);
    }
    return state!.v1();
  }

  /// Generate a v1 (random) id
  String getV4UUID(WidgetRef ref) {
    if (state == null) {
      initialize(ref);
    }
    return state!.v4();
  }
}
