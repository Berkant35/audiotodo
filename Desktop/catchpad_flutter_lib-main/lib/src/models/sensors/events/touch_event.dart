import '../acc_tap_model.dart';
import 'sensor_event.dart';

class TouchEvent extends SensorEvent {
  final AcceleremetorTapModel tap;

  const TouchEvent(String deviceId, this.tap) : super(deviceId);

  Duration? get responseTime => tap.responseTime;

  @override
  bool get isValid => responseTime != null;
}
