import 'package:audiotodo/core/navigation/navigation_constants.dart';
import 'package:audiotodo/main.dart';
import 'package:audiotodo/ui/authentication/auth_login.dart';
import 'package:audiotodo/ui/authentication/auth_register.dart';
import 'package:audiotodo/ui/base/main_base.dart';
import 'package:flutter/material.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();

  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.authLoginPage:
        return normalNavigate(const AuthLogin());
      case NavigationConstants.authRegisterPage:
        return normalNavigate(const AuthRegisterPage());
      case NavigationConstants.mainBase:
        return normalNavigate(const MainBase());
      default:
        return MaterialPageRoute(
          builder: (context) => const AudioToDo(),
        );
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }
}
