// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Meeting`
  String get meeting {
    return Intl.message(
      'Meeting',
      name: 'meeting',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message(
      'Sign Up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message(
      'Sign In',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Welcome To AudioToDo`
  String get welcome_to_audiotodo {
    return Intl.message(
      'Welcome To AudioToDo',
      name: 'welcome_to_audiotodo',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Surname`
  String get surname {
    return Intl.message(
      'Surname',
      name: 'surname',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `You can not blank empty`
  String get blank_empty {
    return Intl.message(
      'You can not blank empty',
      name: 'blank_empty',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Password Again`
  String get again_password {
    return Intl.message(
      'Password Again',
      name: 'again_password',
      desc: '',
      args: [],
    );
  }

  /// `You can enter a password with a minimum of 8 characters`
  String get password_min_eight_character {
    return Intl.message(
      'You can enter a password with a minimum of 8 characters',
      name: 'password_min_eight_character',
      desc: '',
      args: [],
    );
  }

  /// `Passwords not same`
  String get passwords_not_same {
    return Intl.message(
      'Passwords not same',
      name: 'passwords_not_same',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Created!`
  String get create_user_success_dialog_title {
    return Intl.message(
      'Successfully Created!',
      name: 'create_user_success_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Welcome, You can enter with login!`
  String get welcome_please_enter_with_login {
    return Intl.message(
      'Welcome, You can enter with login!',
      name: 'welcome_please_enter_with_login',
      desc: '',
      args: [],
    );
  }

  /// `User Creation Failed!`
  String get user_creation_failed {
    return Intl.message(
      'User Creation Failed!',
      name: 'user_creation_failed',
      desc: '',
      args: [],
    );
  }

  /// `This email is already in use`
  String get email_already_in_use {
    return Intl.message(
      'This email is already in use',
      name: 'email_already_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get invalid_email_format {
    return Intl.message(
      'Invalid email format',
      name: 'invalid_email_format',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a strong password`
  String get please_enter_a_strong_password {
    return Intl.message(
      'Please enter a strong password',
      name: 'please_enter_a_strong_password',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred!`
  String get an_error_occurred {
    return Intl.message(
      'An error occurred!',
      name: 'an_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Password!`
  String get wrong_password {
    return Intl.message(
      'Wrong Password!',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `Login Failed!`
  String get login_failed {
    return Intl.message(
      'Login Failed!',
      name: 'login_failed',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
