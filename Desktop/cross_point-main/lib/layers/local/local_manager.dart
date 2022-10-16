import 'package:hive/hive.dart';

import 'local_base.dart';

enum PreferencesKeys { TOKEN, URL }

class LocaleService extends LocaleBase {
  @override
  Future<String?> getToken() async {
    try {
      var tokenBox = await Hive.openBox(PreferencesKeys.TOKEN.name);
      var token = tokenBox.get(PreferencesKeys.TOKEN.name);
      if (token != null) {
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveToken(String token) async {
    try {
      var tokenBox = await Hive.openBox(PreferencesKeys.TOKEN.name);
      await tokenBox.put(PreferencesKeys.TOKEN.name, token);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setURL(String url) async {
    try {
      var urlBox = await Hive.openBox(PreferencesKeys.URL.name);
      await urlBox.put(PreferencesKeys.URL.name, url);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getUrl() async {
    try {
      var urlBox = await Hive.openBox(PreferencesKeys.URL.name);
      var url = urlBox.get(PreferencesKeys.URL.name);
      if (url != null) {
        return url;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
