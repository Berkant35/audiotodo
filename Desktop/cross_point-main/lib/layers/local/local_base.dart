abstract class LocaleBase {
  Future<bool> saveToken(String token);
  Future<String?> getToken();

  //Future<void> deleteEpcFromArea(String tailNumber,String seat);
}
