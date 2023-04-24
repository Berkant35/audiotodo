import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ble_scanner.dart';
import 'ble_scanner_prov.dart';

final bleScanStreamProv = StreamProvider<BleScannerState>(
  (ref) {
    final scanner = ref.watch(bleScannerProv);
    return scanner.state;
  },
);
