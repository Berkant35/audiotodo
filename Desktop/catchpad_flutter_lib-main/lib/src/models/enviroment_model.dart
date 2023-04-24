import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/enviroment_type.dart';

export '../enums/enviroment_type.dart';

part 'enviroment_model.freezed.dart';

@freezed
class EnviromentModel with _$EnviromentModel {
  const EnviromentModel._();

  factory EnviromentModel({
    required EnviromentType enviromentType,
    String? ip,
    String? port,
  }) = _EnviromentModel;

  String get wsUrl {
    assert(ip != null);
    assert(port != null);
    return 'ws://${ip!}:${port!}';
  }

  Uri get wsUri => Uri.parse(wsUrl);
}
