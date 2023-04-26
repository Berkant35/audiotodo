
import 'dart:math';

import 'package:audiotodo/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../../../../utilities/constants/exceptions/firebase_exceptions.dart';
import '../fb_db/fb_db_manager.dart';


part 'auth_service.dart';

abstract class AuthManager {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> createCustomUserWithEmailAndPassword(
      String email, String password,UserModel userModel,WidgetRef ref);

  Future<UserModel?> currentUser(WidgetRef ref);

  Future<bool> signOut();

  Future<dynamic> signIn(String email, String password,WidgetRef ref);

  Future<void> forgotPassword(String email,WidgetRef ref);

  Future<void> updatePassword(String currentPassword,String newPassword,WidgetRef ref);

  Future<bool> updateEmail(String email,String password,WidgetRef ref);
}
