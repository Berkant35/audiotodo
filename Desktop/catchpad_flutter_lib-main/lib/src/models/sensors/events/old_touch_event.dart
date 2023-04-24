import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provs/ble_connection_state_prov.dart';
import '../../device_model.dart';
import '../acc_tap_model.dart';
import 'touch_event.dart';

class OldTouchEvent {
  final String deviceNameId;
  final Duration responseTime;

  const OldTouchEvent._(this.deviceNameId, this.responseTime);

  factory OldTouchEvent.fromBytes(List<int> bytes) {
    final str = String.fromCharCodes(bytes);
    // str's format is: '/[deviceId]/[responseTime]/'
    // [responseTime] is the time it took to respond to the touch
    // calculated in ms
    final split = str.split('/').where((element) => element.isNotEmpty);

    final deviceId = split.elementAt(0);
    final responseTime = int.parse(split.elementAt(1));
    final responseDuration = Duration(milliseconds: responseTime);

    return OldTouchEvent._(deviceId, responseDuration);
  }

  TouchEvent toTouchEvent(WidgetRef ref) {
    final devs = ref.read(bleConPr).keys;
    return TouchEvent(
      devs.firstWhere((e) => e.deviceNameId == deviceNameId).id,
      AcceleremetorTapModel(
        actionTime: responseTime.inMilliseconds - 1,
        commandTime: 1,
        isValid: isValid,
        tapCounter: 1,
      ),
    );
  }

  static const Duration responseTimeMistakeMargin = Duration(milliseconds: 20);

  /// the pads may calculate mistakenly and return like 10ms off result
  /// so we wanna put [responseTimeMistakeMargin] mistake margin
  bool get isValid => responseTime >= responseTimeMistakeMargin;

  @override
  String toString() {
    return 'OldTouchEvent{deviceId: $deviceNameId, responseTime: $responseTime, isValid: $isValid}';
  }

  bool equalsDevice(DeviceModel device) {
    try {
      final devId = device.name.split(' ').first;
      return devId == deviceNameId;
    } catch (e) {
      assert(false);

      return false;
    }
  }
}
