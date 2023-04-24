import '../acc_gravity_model.dart';
import 'sensor_event.dart';

class MotionEvent extends SensorEvent {
  final AcceleremetorGravityModel motion;

  const MotionEvent(String deviceId, this.motion) : super(deviceId);

  Duration? get responseTime => motion.responseTime;

  @override
  bool get isValid => responseTime != null;
}
