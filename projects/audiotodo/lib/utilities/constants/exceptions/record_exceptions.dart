

import 'dart:io';

import 'package:audiotodo/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordExceptions {
  static handleRecordException(String errorMessage, WidgetRef ref,{String? title}) {
    final recordErrorMessage = "Title: $title, Error Message: $errorMessage";
    //File('error_logs.txt').writeAsStringSync(recordErrorMessage);
    logger.e(recordErrorMessage);
    throw Exception(recordErrorMessage);
  }
}