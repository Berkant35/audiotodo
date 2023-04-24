import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../enums/sensors/config/config_data_rate.dart';
import '../../../enums/sensors/config/config_mode.dart';
import '../../../enums/sensors/config/config_scale.dart';
import '../../../enums/sensors/config/sensor_type.dart';
import 'sensor_config_model.dart';

part 'dst_config_model.freezed.dart';
part 'dst_config_model.g.dart';

@freezed
class DstConfigModel with _$DstConfigModel {
  const DstConfigModel._();

  const factory DstConfigModel({
    ///  0-2000, mm
    int? threshold,

    /// 0 - 99999 ms
    int? timeout,

    ///
    @Default(3)int? limitValue,
  }) = _DstConfigModel;

  int? get thresholdCm {
    if (threshold == null) {
      return null;
    }

    return threshold! ~/ 10;
  }

  SensorConfigModel toSensorConfigModel() {
    return SensorConfigModel(
        sensorType: SensorType.dst,
        threshold: threshold,
        timeout: timeout,
        // TODO: temporarily, the hardware does not parse
        // -1's for the following values for DST, so we can
        // only send 0 or 1 for now.
        scale: ConfigScale.values[0],
        mode: ConfigMode.values[1],
        dataRate: DataRate.values[0],
        limitValue: limitValue);
  }

  factory DstConfigModel.fromJson(Map<String, dynamic> json) =>
      _$DstConfigModelFromJson(json);
}
