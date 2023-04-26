import 'package:audiotodo/line/db/firebase/fb_db/fb_db_manager.dart';
import 'package:audiotodo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class FirebaseDbBase {
  FirebaseDbBase();

  final FirebaseFirestore _dbBase = FirebaseFirestore.instance;

  FirebaseFirestore get dbBase => _dbBase;

  Future<UserModel?> readUser(String userID,WidgetRef ref);

  Future<bool> saveUser(
    UserModel user,
    String? userID,
    WidgetRef ref
  );
}
