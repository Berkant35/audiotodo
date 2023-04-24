import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ble_status_monitor.dart';
import 'ble_prov.dart';

final bleStatusMonitorProv = StateProvider<BleStatusMonitor>(
  (ref) {
    final ble = ref.watch(bleProv);
    return BleStatusMonitor(ble);
  },
);
