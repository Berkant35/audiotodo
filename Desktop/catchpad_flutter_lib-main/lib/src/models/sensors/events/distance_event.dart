import '../dst_model.dart';
import 'sensor_event.dart';

class DistanceEvent extends SensorEvent {
  final DistanceModel distance;

  const DistanceEvent(String deviceId, this.distance) : super(deviceId);

  Duration? get responseTime => distance.responseTime;

  @override
  bool get isValid => responseTime != null;
}
