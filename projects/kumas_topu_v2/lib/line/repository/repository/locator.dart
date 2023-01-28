

import 'package:get_it/get_it.dart';
import 'package:kumas_topu/line/repository/repository/repository_base.dart';

import '../../../utilities/constants/app/url_constants.dart';
import '../../local/local_manager.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Repository());
  locator.registerLazySingleton(() => LocaleService());
  locator.registerLazySingleton(() => UrlConstants());
}
