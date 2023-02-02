


enum Roles {none,admin,accountant,customer,expert,doctor,worker}
enum LoadingStates {idle,loading,loaded}

enum Months {
  ocak("Ocak"),
  subat("Şubat"),
  mart("Mart"),
  nisan("Nisan"),
  mayis("Mayıs"),
  haziran("Haziran"),
  temmuz("Temmuz"),
  agustos("Ağustos"),
  eylul("Eylül"),
  ekim("Ekim"),
  kasim("Kasım"),
  aralik("Aralik");

  const Months(this.text);
  final String text;
}

