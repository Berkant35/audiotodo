//Flutter toast !!

import '../../../line/local/local_manager.dart';
import '../../../line/repository/repository/locator.dart';

class UrlConstants extends LocaleService {
  final localService = locator<LocaleService>();

  var baseURL = "https://connector.kumastopu.com/";

  Future<void> setUrl(String url) async {
    localService.setURL(url);
  }

  @override
  Future<String?> getUrl() async {
    return localService.getUrl().then((value) {
      if (value != null) {
        return value;
      } else {
        return baseURL;
      }
    });
  }

  Future<void> deleteEpcFromArea(String tailNumber, String seat) {
    // TODO: implement deleteEpcFromArea
    throw UnimplementedError();
  }
}
