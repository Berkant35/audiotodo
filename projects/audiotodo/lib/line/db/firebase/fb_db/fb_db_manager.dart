import 'package:audiotodo/main.dart';
import 'package:audiotodo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utilities/constants/exceptions/firebase_exceptions.dart';
import 'fb_db_base.dart';

class FirebaseDbManager extends FirebaseDbBase {
  @override
  Future<UserModel?> readUser(String userID, WidgetRef ref) async {
    try {
      final docSnap = await dbBase.collection("users").doc(userID).get();
      return UserModel.fromJson(docSnap.data()!);
    } on Exception catch (e) {
      FirebaseExceptions.handleFirebaseException(e.toString(), ref);
    }
    return null;
  }

  @override
  Future<bool> saveUser(UserModel user, String? userID, WidgetRef ref) async {
    try {
      await dbBase.collection("users").doc(userID).set(user.toJson());
      return true;
    } catch (e) {
      logger.e("Error $e");

      throw FirebaseException(plugin: "save_user");
    }
  }
}
