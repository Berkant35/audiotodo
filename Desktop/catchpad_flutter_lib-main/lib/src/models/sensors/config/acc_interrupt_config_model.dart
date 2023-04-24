import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../enums/sensors/config/config_data_rate.dart';
import '../../../enums/sensors/config/config_mode.dart';
import '../../../enums/sensors/config/config_scale.dart';
import '../../../enums/sensors/config/sensor_type.dart';
import 'sensor_config_model.dart';

export '../../../enums/sensors/config/config_data_rate.dart';
export '../../../enums/sensors/config/config_mode.dart';
export '../../../enums/sensors/config/config_scale.dart';

part 'acc_interrupt_config_model.freezed.dart';
part 'acc_interrupt_config_model.g.dart';

/// this sets settings for the accelerometer
/// interrupt (sleep)
@freezed
class AccInterruptConfigModel with _$AccInterruptConfigModel {
  const AccInterruptConfigModel._();

  const factory AccInterruptConfigModel({
    ConfigScale? scale,
    ConfigMode? mode,
    DataRate? dataRate,

    /// 0-127
    int? threshold,

    /// ms
    /// 0 - 20 ms
    /// how long to wait for an interrupt
    int? duration,

    /// MINUTE
    /// 0 - 60 minutes
    /// after how long of inactivity to go to sleep
    int? timeout,

    /// wether to enable sleep mode
    bool? sleepEnable,
  }) = _AccInterruptConfigModel;

  SensorConfigModel toSensorConfigModel() {
    return SensorConfigModel(
      sensorType: SensorType.acc,
      intScale: scale,
      intMode: mode,
      intDataRate: dataRate,
      intThreshold: threshold,
      intTimeout: timeout,
      intDuration: duration,
      intSleepEnable: sleepEnable,
    );
  }

  factory AccInterruptConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AccInterruptConfigModelFromJson(json);
}
