part of 'auth_manager.dart';

class AuthService extends AuthManager {
  final _dataBase = FirebaseDbManager();
  final _localManager = LocaleManager();

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password,
      String? logoPhotoUrl, Roles role, SearchUser searchUser) async {
    try {
      var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      dynamic userMap;

      if (role == Roles.admin) {
        userMap =
            Admin(typeOfUser: "admin", rootUserID: userCredential.user!.uid);

        await _dataBase.saveUser(userMap, userCredential.user!.uid,
            logoPhotoUrl, role, null, searchUser);
      }

      return await signOut().then((value) async {
        var email = await _localManager.getEmail();
        var password = await _localManager.getPassword();
        return await signIn(email, password).then((value) {
          return userCredential.user;
        });
      });
    } catch (e) {
      if (e.toString().contains("email-already-in-use")) {
        Fluttertoast.showToast(msg: "Böyle bir kullanıcı zaten bulunmaktadır");
      } else if (e.toString().contains("invalid-email")) {
        Fluttertoast.showToast(msg: "E-mail formatında değil");
      } else if (e.toString().contains("weak-password")) {
        Fluttertoast.showToast(msg: "Lütfen güçlü bir şifre girin");
      } else {
        debugPrint('$e<-error');
      }
      return null;
    }
  }

  @override
  Future<dynamic> currentUser() async {
    var userCredential = _firebaseAuth.currentUser;
    if (userCredential != null) {
      var readUserMap = await _dataBase.readUser(userCredential.uid);
      return getCurrentUserModel(readUserMap);
    } else {
      return null;
    }
  }

  Future<dynamic> getUser(String userID) async {
    var readUserMap = await _dataBase.readUser(userID);
    debugPrint("getUser ${readUserMap.toString()}");
    return getCurrentUserModel(readUserMap);
  }

  @override
  Future<bool> signOut() async {
    try {
      return await _firebaseAuth.signOut().then((value) {
        return true;
      });
    } catch (e) {
      debugPrint('${e}SIGN_OUT');
      Fluttertoast.showToast(msg: "Something went wrong!");
      return false;
    }
  }

  @override
  Future<dynamic> signIn(String email, String password) async {
    try {
      var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      var map = await _dataBase.readUser(userCredential.user!.uid);

      if (map != null) {
        return getCurrentUserModel(map);
      } else {
        Fluttertoast.showToast(
            msg:
                "Böyle bir kayıt bulunamadı.Sadece yeni bir kullanıcıyı admin ekleyebilir!",
            toastLength: Toast.LENGTH_LONG);
      }
    } catch (e) {
      debugPrint('${e}SIGN_IN');
      if (e.toString().contains("user-not-found")) {
        Fluttertoast.showToast(
            msg: "Böyle bir kayıt bulunamadı", toastLength: Toast.LENGTH_LONG);
      } else if (e.toString().contains("password")) {
        Fluttertoast.showToast(
            msg: "Şifre yanlış girildi", toastLength: Toast.LENGTH_LONG);
      } else {
        debugPrint('$e<---');
      }
      return null;
    }
  }

  dynamic getCurrentUserModel(Map<String, dynamic> map) {
    switch (map[mapKeyOfRoleAtFirebase()].toString().toLowerCase()) {
      case 'admin':
        return Admin.fromJson(map);
      case 'expert':
        return Expert.fromJson(map);
      case 'customer':
        return Customer.fromJson(map);
      case 'doctor':
        return Doctor.fromJson(map);
      case 'accountant':
        return Accountant.fromJson(map);
      case 'worker':
        return Worker.fromJson(map);
      default:
        return Customer.fromJson(map);
    }

    return;
  }

  String mapKeyOfRoleAtFirebase() => 'typeOfUser';

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        Fluttertoast.showToast(
            msg: "Please check email!", toastLength: Toast.LENGTH_LONG);
      });
    } catch (e) {
      if (e.toString().contains("user-not-found")) {
        Fluttertoast.showToast(
            msg:
                "Böyle bir kayıt bulunamadı.Sadece yeni bir kullanıcıyı admin ekleyebilir!",
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        Fluttertoast.showToast(msg: "Başarılı bir şekilde güncellendi");
        NavigationService.instance.navigatePopUp();
      }).catchError((error) {
        Fluttertoast.showToast(msg: "Bir şeyler ters gitti!");
      });
    }).catchError((err) {
      Fluttertoast.showToast(msg: "Bir şeyler ters gitti!");
    });
  }

  @override
  Future<Admin?> getAdminToken() async {
    try {
      return await _dataBase.getAdmin();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Expert?> getExpert(String rootUserID) async {
    try {
      return await _dataBase.getExpert(rootUserID);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Customer?> getCustomer(String rootUserID) async {
    try {
      return await _dataBase.getCustomer(rootUserID);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<bool> updateEmail(String email, String password) async {
    try {


      await _firebaseAuth.signOut();

      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);



      await _firebaseAuth.currentUser!.updateEmail(email);



      await _firebaseAuth.signOut();

      await _firebaseAuth.signInWithEmailAndPassword(
          email: "admin@gmail.com", password: "1234567");

      return true;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String rootUserID) async {
    return false;
  }
}
