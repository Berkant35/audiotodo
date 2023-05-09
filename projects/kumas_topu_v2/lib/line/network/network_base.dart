part of 'network_manager.dart';

abstract class NetworkManagerBase {
  late Dio _dio;

  Dio get manager => _dio;

  late DeviceInfoPlugin _deviceInfo;

  DeviceInfoPlugin get deviceInfoPlugin => _deviceInfo;


  NetworkManagerBase();

  init(String baseUrl, Map<String, dynamic>? headers)  {
    final localBase = LocaleService();
    _deviceInfo = DeviceInfoPlugin();
    _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: headers));

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    _dio.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      if (e.response.toString().toLowerCase().contains("token expired")) {
        localBase.saveToken('').then((value) {
          NavigationService.instance
              .navigateToPageClear(path: NavigationConstants.loginPage);
        });
      }

      handler.next(e);
    }));
  }

  Future<LoginSuccess?> login(String email, String password);

  Future<EncodeStandarts?> getEncodeStandartList(String accessToken);

  Future<CreateResultEPC?> createEPCForMatch(
      String barcode, PerStandart? standart, String accessToken);

  Future<EncodeStatus?> encodeStatusOK(
      String? epc,
      String? encodeStatus,
      String accessToken,
      String? tid,

      );

  Future<SerialNumber?> getSerialFromDatabase(String accessToken);

  Future<CreateSuccess?> addInventory(String title,String accessToken,bool isShipment);


  Future<InventoryList?> getInventories(String accessToken,bool isShipment);

  Future<void> sendTags(
      String accessToken,
      Inventory inventory,
      List<dynamic> readEpcList,bool saveAndClose,bool isShipment);

  Future<List<ReadEpc>> getReadList({String? accessToken,
    String? shipmentId});
}
