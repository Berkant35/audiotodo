import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../catchpad_simulator.dart';
import '../enums/enviroment_type.dart';
import 'enviroment_prov.dart';

final bleProv = StateNotifierProvider<BleStateNotifier, FlutterReactiveBle>(
  (ref) => BleStateNotifier(
    ref,
    BleStateNotifier.instanceDependingOnEnv(
      ref,
      ref.watch(enviromentProv)?.enviromentType,
    ),
  ),
);

class BleStateNotifier extends StateNotifier<FlutterReactiveBle> {
  Ref ref;
  BleStateNotifier(this.ref, FlutterReactiveBle type) : super(type);

  /// if we're in a real enviroment, we wanna use the real ble manager,
  /// else we wanna use the simulator, which overrides the real ble manager's
  /// methods. however, we want the default to be the real ble manager.
  static instanceDependingOnEnv(Ref ref, EnviromentType? type) =>
      type == EnviromentType.simulated
          ? CatchpadSimulator(ref)
          : FlutterReactiveBle();
}
