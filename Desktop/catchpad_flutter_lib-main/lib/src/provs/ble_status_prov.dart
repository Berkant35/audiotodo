import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ble_status_monitor_prov.dart';

final bleStatusProv = StreamProvider<BleStatus?>(
  (ref) {
    final monitor = ref.watch(bleStatusMonitorProv);

    return monitor.state;
  },
);
