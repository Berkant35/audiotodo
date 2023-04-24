import '../../device_model.dart';

abstract class SensorEvent {
  final String deviceId;

  const SensorEvent(this.deviceId);

  bool equalsDevice(DeviceModel dev) => deviceId == dev.id;

  bool get isValid;
}
