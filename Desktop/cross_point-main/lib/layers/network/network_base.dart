part of 'network_manager.dart';

abstract class NetworkManagerBase {
  late Dio _dio;

  Dio get manager => _dio;

  NetworkManagerBase();

  void init(String baseUrl, Map<String, dynamic>? headers) {
    final localBase = LocaleService();

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
              .navigateToPageClear(path: NavigationConstants.landingPage);
        });
      }

      handler.next(e);
    }));
  }
  Future<LoginSuccess?> login(String email,String password);
  Future<Locations?> getLocations(String token);
  Future<Items?> getItems(String token,String locationID);
}
