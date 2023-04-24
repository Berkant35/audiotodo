import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class CpCharacteristic {
  final String id;
  final String serviceId;
  const CpCharacteristic({
    required this.id,
    required this.serviceId,
  });

  Uuid get uuid => Uuid.parse(id);
  Uuid get serviceUuid => Uuid.parse(serviceId);

  QualifiedCharacteristic qualCharacteristic(String deviceId) =>
      QualifiedCharacteristic(
        characteristicId: uuid,
        deviceId: deviceId,
        serviceId: serviceUuid,
      );
}
