import 'package:flutter/widgets.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../models/cp_characteristic.dart';
import '../models/sensors/config/acc_config_model.dart';
import '../models/sensors/config/acc_interrupt_config_model.dart';
import '../models/sensors/config/dst_config_model.dart';

part 'config_consts.dart';

const Duration responseTimeMistakeMargin = Duration(milliseconds: 20);
const String defaultSeperator = '/';
const String subSeperator = ',';
const String defaultEmptyValue = '-1';

// #region main stuff

const List<String> serviceIds = [ledServiceId, adminServiceId, sensorServiceId];

List<Uuid> get serviceUuids => serviceIds.map(Uuid.parse).toList();

// #endregion

// #region new characteristics

// #region simulator only
const String simulatorServiceId = 'b3b7e8f4-9ab4-4d9b-80d4-bd61113a5017';

const CpCharacteristic simulatorCharacteristic = CpCharacteristic(
  id: '4fafc201-1fb5-459e-8fcc-c5c9c331914b',
  serviceId: simulatorServiceId,
);
// #endregion

// #region led
const String ledServiceId = '55cb9fe8-b2ab-11ec-b909-000000000000';

const CpCharacteristic ledCharacteristic = CpCharacteristic(
  id: '6412075e-b2ab-11ec-b909-000000000001',
  serviceId: ledServiceId,
);
const CpCharacteristic ledAllCharacteristic = CpCharacteristic(
  id: '6412075e-b2ab-11ec-b909-000000000111',
  serviceId: ledServiceId,
);
// #endregion

// #mp3start

const String mp3ServiceId = "23cb9fe8-b2ab-11ec-b909-AAAAAAAAAAAA";

// "beb5483e-36e1-4688-b7f5-ea07361b26a8"
const CpCharacteristic mp3transferCharacteristic = CpCharacteristic(
  id: 'beb5483e-36e1-4688-b7f5-ea07361b26a8',
  serviceId: mp3ServiceId,
);

// #mp3end


// #otastart

const String otaServiceId = 'c8659210-af91-4ad3-a995-a58d6fd26145';

const CpCharacteristic otaFwCharacteristic = CpCharacteristic(
  id: 'c8659211-af91-4ad3-a995-a58d6fd26145',
  serviceId: otaServiceId,
);

const CpCharacteristic otaHwVersion = CpCharacteristic(
  id: 'c8659212-af91-4ad3-a995-a58d6fd26145',
  serviceId: otaServiceId,
);

const CpCharacteristic otaSettings = CpCharacteristic(
  id: "c8659212-af91-4ad3-a995-a58d6fd20148",
  serviceId: otaServiceId,
);

// #otaend



// #region admin
const String adminServiceId = '23cb9fe8-b2ab-11ec-b909-DDDDDDDDDDDD';

const CpCharacteristic adminCharacteristic = CpCharacteristic(
  id: 'a4bf0dbb-b2ab-11ec-b909-00000000000A',
  serviceId: adminServiceId,
);
// #endregion

// #region sensors
const String sensorServiceId = '722d9150-b2ab-11ec-b909-000000000000';

const CpCharacteristic accCharacteristic = CpCharacteristic(
  id: '7af57456-b2ab-11ec-b909-000000000001',
  serviceId: sensorServiceId,
);

const CpCharacteristic dstCharacteristic = CpCharacteristic(
  id: '83e7f7e6-b2ab-11ec-b909-000000000002',
  serviceId: sensorServiceId,
);

const CpCharacteristic activateCharacteristic = CpCharacteristic(
  id: 'a4bf0dba-b2ab-11ec-b909-00000000000A',
  serviceId: sensorServiceId,
);

const CpCharacteristic configCharacteristic = CpCharacteristic(
  id: '8a19169a-b2ab-11ec-b909-00000000000C',
  serviceId: sensorServiceId,
);
// #endregion

// #region info
const String infoServiceId = '23cb9fe8-b2ab-11ec-b909-dddddddddddd';


const CpCharacteristic errorLog = CpCharacteristic(
  id: 'a4bf0dbb-b2ab-11ec-b909-DDDDDDDDDDD2',
  serviceId: infoServiceId,
);

const CpCharacteristic infoCharacteristic = CpCharacteristic(
  id: 'a4bf0dbb-b2ab-11ec-b909-DDDDDDDDDDD0',
  serviceId: infoServiceId,
);

const CpCharacteristic sleepCharacteristicAdminInfo = CpCharacteristic(
  id: 'a4bf0dbb-b2ab-11ec-b909-00000000000a',
  serviceId: infoServiceId,
);

const CpCharacteristic batteryCharacteristic = CpCharacteristic(
  id: 'a4bf0dbb-b2ab-11ec-b909-DDDDDDDDDDD1',
  serviceId: infoServiceId,
);

// #endregion
// #region audio
const String audioServiceId = '23cb9fe8-b2ab-11ec-b909-AAAAAAAAAAAA';

const CpCharacteristic audioCharacteristic = CpCharacteristic(
  id: 'a4bf0dbb-b2ab-11ec-b909-AAAAAAAAAAAA',
  serviceId: audioServiceId,
);


// #endregion
// #endregion

const String oldMainServiceId = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
const oldMainCharacteristicId = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';

Uuid get oldMainServiceUuid => Uuid.parse(oldMainServiceId);
Uuid get oldMainCharacteristicUuid => Uuid.parse(oldMainCharacteristicId);

const CpCharacteristic oldMainCharacteristic = CpCharacteristic(
  id: oldMainCharacteristicId,
  serviceId: oldMainServiceId,
);

abstract class PadConsts {
  static const Color errorColor = Color(0xFFF44336);
}
