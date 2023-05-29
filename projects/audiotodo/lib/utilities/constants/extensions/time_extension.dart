import 'package:intl/intl.dart';

extension CustomTimeFormat on DateTime {

  String get nowTimeTextddMMyyyyHHmm =>
      DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
}
