import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enviroment_model.dart';

final enviromentProv =
    StateNotifierProvider<EnviromentNotifier, EnviromentModel?>(
  (_) => EnviromentNotifier(),
);

class EnviromentNotifier extends StateNotifier<EnviromentModel?> {
  EnviromentNotifier() : super(null);

  void setEnviroment(EnviromentModel enviroment) => state = enviroment;

  void deleteEnviroment() => state = null;

  void setEnviromentType(EnviromentType type) {
    setEnviroment(
      EnviromentModel(enviromentType: type),
    );
  }
}
