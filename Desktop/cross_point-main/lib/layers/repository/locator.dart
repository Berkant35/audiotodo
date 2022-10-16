import 'package:cross_point/layers/repository/repository_base.dart';
import 'package:get_it/get_it.dart';

import '../../utilities/constants/url_constants.dart';
import '../local/local_manager.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Repository());
  locator.registerLazySingleton(() => LocaleService());
  locator.registerLazySingleton(() => UrlConstants());
}
