import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../enums/sensors/config/config_data_rate.dart';
import '../../../enums/sensors/config/config_mode.dart';
import '../../../enums/sensors/config/config_scale.dart';
import '../../../enums/sensors/config/sensor_type.dart';

part 'sensor_config_model.freezed.dart';

/// the ones that start with int
/// represent interrupt configs
@freezed
class SensorConfigModel with _$SensorConfigModel {
  const factory SensorConfigModel({
    required SensorType sensorType,
    final ConfigScale? scale,
    final ConfigMode? mode,
    final DataRate? dataRate,
    @Default(6) final int? limitValue,

    /// ACC: 0-127
    /// DST: 0-2000
    final int? threshold,

    /// 0 - 99999 ms
    final int? timeout,
    final ConfigScale? intScale,
    final ConfigMode? intMode,
    final DataRate? intDataRate,

    /// ACC: 0-127
    /// DST: 0-2000
    final int? intThreshold,

    /// 0 - 99999 ms
    final int? intTimeout,

    /// ms
    /// 0 - 20 ms
    /// how long to wait for an interrupt
    final int? intDuration,

    /// wether to enable sleep mode
    final bool? intSleepEnable,
  }) = _SensorConfigModel;
}
