import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ble_scanner.dart';

final bleScannerProv = StateProvider(BleScanner.new);
