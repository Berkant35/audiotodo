// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "again_password":
            MessageLookupByLibrary.simpleMessage("Password Again"),
        "an_error_occurred":
            MessageLookupByLibrary.simpleMessage("An error occurred!"),
        "blank_empty":
            MessageLookupByLibrary.simpleMessage("You can not blank empty"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "create_user_success_dialog_title":
            MessageLookupByLibrary.simpleMessage("Successfully Created!"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "email_already_in_use": MessageLookupByLibrary.simpleMessage(
            "This email is already in use"),
        "invalid_email_format":
            MessageLookupByLibrary.simpleMessage("Invalid email format"),
        "login_failed": MessageLookupByLibrary.simpleMessage("Login Failed!"),
        "meeting": MessageLookupByLibrary.simpleMessage("Meeting"),
        "or": MessageLookupByLibrary.simpleMessage("or"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "password_min_eight_character": MessageLookupByLibrary.simpleMessage(
            "You can enter a password with a minimum of 8 characters"),
        "passwords_not_same":
            MessageLookupByLibrary.simpleMessage("Passwords not same"),
        "please_enter_a_strong_password": MessageLookupByLibrary.simpleMessage(
            "Please enter a strong password"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Sign In"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "surname": MessageLookupByLibrary.simpleMessage("Surname"),
        "user_creation_failed":
            MessageLookupByLibrary.simpleMessage("User Creation Failed!"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "welcome_please_enter_with_login": MessageLookupByLibrary.simpleMessage(
            "Welcome, You can enter with login!"),
        "welcome_to_audiotodo":
            MessageLookupByLibrary.simpleMessage("Welcome To AudioToDo"),
        "wrong_password":
            MessageLookupByLibrary.simpleMessage("Wrong Password!")
      };
}
