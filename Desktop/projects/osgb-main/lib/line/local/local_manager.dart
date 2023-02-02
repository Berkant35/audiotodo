


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:osgb/line/local/local_base.dart';



enum PreferencesKeys{
  emailBoxHive,
  passwordBoxHive
}
class LocaleManager extends LocaleBase{



  @override
  Future<String> getEmail() async {
    try {
      var emailBox =
          await Hive.openBox(PreferencesKeys.emailBoxHive.name);
      var email = await emailBox.get(
          PreferencesKeys.emailBoxHive.name);
      return email;
    } catch (e) {
      return "";
    }
  }

  @override
  Future<String> getPassword() async {
    try {
      var passwordBox =
          await Hive.openBox(PreferencesKeys.passwordBoxHive.name);
      var password = await passwordBox.get(
          PreferencesKeys.passwordBoxHive.name);
      return password;
    } catch (e) {
      return "";
    }
  }

  @override
  Future<void> setEmail(String email) async {
    try {
      var passwordBox =
          await Hive.openBox(PreferencesKeys.emailBoxHive.name);
      await passwordBox.put(
          PreferencesKeys.emailBoxHive.name,email);

    } catch (e) {
      debugPrint("Local set Email error $e");
    }
  }

  @override
  Future<void> setPassword(String password) async  {
    try {
      var passwordBox =
          await Hive.openBox(PreferencesKeys.passwordBoxHive.name);
      await passwordBox.put(
          PreferencesKeys.passwordBoxHive.name,password);

    } catch (e) {
      debugPrint("Local set Password error $e");
    }
  }

}