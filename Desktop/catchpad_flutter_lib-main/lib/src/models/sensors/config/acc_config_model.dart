import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../enums/sensors/config/config_data_rate.dart';
import '../../../enums/sensors/config/config_mode.dart';
import '../../../enums/sensors/config/config_scale.dart';
import '../../../enums/sensors/config/sensor_type.dart';
import 'sensor_config_model.dart';

export '../../../enums/sensors/config/config_data_rate.dart';
export '../../../enums/sensors/config/config_mode.dart';
export '../../../enums/sensors/config/config_scale.dart';

part 'acc_config_model.freezed.dart';
part 'acc_config_model.g.dart';

@freezed
class AccConfigModel with _$AccConfigModel {
  const AccConfigModel._();

  const factory AccConfigModel({
    ConfigScale? scale,
    ConfigMode? mode,
    DataRate? dataRate,

    /// 0-127
    int? threshold,

    /// 0 - 99999 ms
    int? timeout,
  }) = _AccConfigModel;

  SensorConfigModel toSensorConfigModel() {
    return SensorConfigModel(
      sensorType: SensorType.acc,
      scale: scale,
      mode: mode,
      dataRate: dataRate,
      threshold: threshold,
      timeout: timeout,
    );
  }

  factory AccConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AccConfigModelFromJson(json);
}
