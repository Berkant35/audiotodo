import 'package:logger/logger.dart';

/// inspired from [Screen Util](https://github.com/OpenFlutter/flutter_screenutil/blob/master/lib/src/screenutil_init.dart)
abstract class CatchPadFlutterLibInit {
  static late Logger _logger;

  /// this is not kDebugMode, this indicates wether
  /// a developer is using the app or not, because
  /// we already distribute the app in debug mode
  /// to the business team, so we cannot depend
  /// on kDebugMode.
  static late bool _debugMode;
  static void init({
    required Logger logger,
    required bool debugMode,
  }) {
    _logger = logger;
    _debugMode = debugMode;
  }
}

Logger get logger {
  try {
    return CatchPadFlutterLibInit._logger;
  } catch (e) {
    assert(false, '''CatchPadFlutterLibInit not initialized.
        Please call CatchPadFlutterLibInit.init() and pass necessary arguments.''');

    // now in an impossible case, but... just in case,
    // if this breaks in production, we'll initialize a
    // default logger.
    CatchPadFlutterLibInit._logger = Logger();
    return CatchPadFlutterLibInit._logger;
  }
}

bool get debugMode {
  try {
    return CatchPadFlutterLibInit._debugMode;
  } catch (e) {
    assert(false, '''CatchPadFlutterLibInit not initialized.
        Please call CatchPadFlutterLibInit.init() and pass necessary arguments.''');

    // now in an impossible case, but... just in case,
    // if this breaks in production, we'll initialize a
    // default logger.
    CatchPadFlutterLibInit._debugMode = false;
    return CatchPadFlutterLibInit._debugMode;
  }
}
