part of 'fb_db_manager.dart';
abstract class FirebaseDbBase {

  late Dio _dio;

  Dio get manager => _dio;



  void init(String baseUrl,Map<String, dynamic>? headers){


    _dio = Dio(BaseOptions(baseUrl: baseUrl,headers: headers));



  }
  FirebaseDbBase();
  final FirebaseFirestore dbBase = FirebaseFirestore.instance;



  Future<dynamic> readUser(String userID);

  Future<bool> saveUser(
    RootUser user,
    String? userID,
    String photoURL,
    Roles role,
    Admin? currentAdmin,
    SearchUser searchUser,
  );

  Future<bool> saveWorker(
    RootUser user,
    String? userID,
    String photoURL,
    Roles role,
    String? companyName,
  );

  Future<bool> createInspection(Inspection inspection);

  Future<List<Inspection>?> getInspections(
      bool filterIsDone, String? filterUserID, Roles? roles);

  Future<List<AccidentCase>?> getAccidentCases(bool filterIsDone, String? filterUserID, Roles? roles);

  Future<bool> createDemand(DemandWorker demandWorker);

  Future<bool> createCrises(AccidentCase accidentCase);

  Future<bool> deleteCrises(String accidentCaseID);

  Future<bool> confirmDemand(DemandWorker demandWorker);

  Future<bool> updateExpert(Expert updateExpert);

  Future<bool> updateDoctor(Doctor updateDoctor);

  Future<void> deleteDoctor(String rootUserID);

  Future<List<SearchUser>> getSearchUsers();

  Future<void> updatePushToken(String pushToken,String rootUserID);

  Future<void> sendPush(NotificationModel notificationModel);

  Future<bool> uploadFileToCustomer(CustomFile customFile);

  Future<List<CustomFile>> getFileListOfCustomer(String rootUserID);

}
