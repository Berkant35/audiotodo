part of 'auth_manager.dart';

class AuthService extends AuthManager {
  final _dataBase = FirebaseDbManager();

  @override
  Future<bool> createCustomUserWithEmailAndPassword(
      String email, String password, UserModel userModel, WidgetRef ref) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: userModel.email!, password: password);

      if (userCredential.user != null) {
        return await _dataBase.saveUser(
            userModel.copyWith(userId: userCredential.user!.uid),
            userCredential.user!.uid,
            ref);
      } else {
        return false;
      }
    } catch (e) {
      logger.e(e);
      FirebaseExceptions.handleFirebaseException(e.toString(), ref);
      return false;
    }
  }

  @override
  Future<UserModel?> currentUser(WidgetRef ref) async {
    var userCredential = firebaseAuth.currentUser;
    if (userCredential != null) {
      return await _dataBase.readUser(userCredential.uid, ref);
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> signIn(
      String email, String password, WidgetRef ref) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return await _dataBase.readUser(userCredential.user!.uid, ref);
    } catch (e) {
      logger.e("Error Message: ${e.toString()}");
      FirebaseExceptions.handleFirebaseException(e.toString(), ref,
          title: S.current.login_failed);
    }
    return null;
  }

  @override
  Future<void> forgotPassword(String email, WidgetRef ref) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<bool> updateEmail(String email, String password, WidgetRef ref) {
    // TODO: implement updateEmail
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(
      String currentPassword, String newPassword, WidgetRef ref) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }
}
