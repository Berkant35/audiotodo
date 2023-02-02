
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/line/network/database/fb_db_manager.dart';
import 'package:osgb/models/accountant.dart';
import 'package:osgb/models/admin.dart';
import 'package:osgb/models/customer.dart';
import 'package:osgb/models/doctor.dart';
import 'package:osgb/models/expert.dart';
import 'package:osgb/models/search_user.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/init/navigation/navigation_service.dart';

import '../../../models/worker.dart';
import '../../local/local_manager.dart';

part 'auth_service.dart';

abstract class AuthManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, String? logoPhotoUrl,Roles role,SearchUser searchUser);

  Future<dynamic> currentUser();

  Future<bool> signOut();

  Future<dynamic> signIn(String email, String password);

  Future<void> forgotPassword(String email);

  Future<void> updatePassword(String currentPassword,String newPassword);

  Future<Admin?> getAdminToken();
}
