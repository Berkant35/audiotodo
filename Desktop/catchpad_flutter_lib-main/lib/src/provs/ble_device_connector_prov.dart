import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ble_device_connector.dart';

final bleDeviceConnectorProv =
    StateProvider<BleDeviceConnector>(BleDeviceConnector.new);
