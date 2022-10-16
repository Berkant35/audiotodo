//Flutter toast !!

import '../../layers/local/local_manager.dart';
import '../../layers/repository/locator.dart';

class UrlConstants extends LocaleService {
  final localService = locator<LocaleService>();

  var baseURL = "https://crosspoint.uniqueid.nl/connector";

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

  @override
  Future<void> deleteEpcFromArea(String tailNumber, String seat) {
    // TODO: implement deleteEpcFromArea
    throw UnimplementedError();
  }
}
