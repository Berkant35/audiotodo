import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:kumas_topu/models/create_success.dart';
import 'package:kumas_topu/models/epc_detail.dart';
import 'package:kumas_topu/models/read_epc.dart';

import '../../models/create_result_epc.dart';
import '../../models/encode_status.dart';
import '../../models/inventory_list.dart';
import '../../models/login_success.dart';

import '../../models/encode_standarts.dart';
import '../../models/read_list.dart';
import '../../models/serial_number.dart';
import '../../models/version.dart';
import '../../utilities/components/dialogs.dart';
import '../../utilities/constants/app/url_constants.dart';
import '../../utilities/init/navigation/navigation_constants.dart';
import '../../utilities/init/navigation/navigation_service.dart';

import '../local/local_manager.dart';
import '../repository/repository/locator.dart';

part 'network_base.dart';

class NetworkManager extends NetworkManagerBase {
  static NetworkManager? _instance;

  static NetworkManager? get instance {
    _instance ??= NetworkManager._();
    return _instance;
  }

  NetworkManager._();

  final urlConstans = locator<UrlConstants>();
  final localService = locator<LocaleService>();

  @override
  Future<LoginSuccess?> login(String email, String password) async {
    try {
      return urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };

        final response = await _dio.post('$value/user/login',
            data: {'email': email, 'password': password});

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res");

        if (response.statusCode == 200) {
          debugPrint('200 OK!-> ${response.toString()}');
          debugPrint('200 OK!-> ${response.data}');
          final loginSuccess = LoginSuccess.fromJson(response.data);
          ("Login Success Result ${loginSuccess.toJson().toString()}");

          if (loginSuccess.code == 200) {
            return loginSuccess;
          } else {
            Dialogs.showFailed(loginSuccess.err!.message!);
            return null;
          }
        }
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Future<EncodeStandarts?> getEncodeStandartList(String accessToken) async {
    try {
      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };

        final response = await _dio.post('$value/encode/encode_standards_list',
            data: {'access_token': accessToken});

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res");

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          final items = EncodeStandarts.fromJson(response.data);

          if (items.code == 200) {
            return items;
          } else {
            Dialogs.showFailed("Bir şeyler ters gitti");
            return items;
          }
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
            return null;
          }
        }
      });
    } catch (e) {
      debugPrint("Get locations error: $e");
      return null;
    }
  }

  @override
  Future<CreateResultEPC?> createEPCForMatch(
      String barcode, PerStandart? standart, String accessToken) async {
    try {
      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };

        debugPrint("Barcode: $barcode");
        debugPrint("Standart ID: ${standart?.id.toString()}");

        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        final response = await _dio.post('$value/encode/encode_epc', data: {
          "access_token": accessToken,
          "barcode_identifier": barcode,
          "encode_standards_id": standart?.id,
          "device_id": androidInfo.id,
          "device_name": androidInfo.device
        });

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          final resultOfEpc = CreateResultEPC.fromJson(response.data);

          if (resultOfEpc.code == 200) {
            return resultOfEpc;
          } else {
            Dialogs.showFailed(resultOfEpc.err!.message!);
            return resultOfEpc;
          }
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
            return null;
          }
        }
      });
    } catch (e) {
      debugPrint("Get locations error: $e");
      return null;
    }
  }

  Future<void> _tokenExpiredLogout() {
    return localService.saveToken("").then((value) {
      NavigationService.instance
          .navigateToPageClear(path: NavigationConstants.loginPage);
      return null;
    });
  }

  @override
  Future<EncodeStatus?> encodeStatusOK(String? epc, String? encodeStatus,
      String accessToken, String? tid) async {
    try {
      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };

        debugPrint("epc: $epc");

        final response = await _dio.post('$value/encode/encode_status', data: {
          "access_token": accessToken,
          "epc": epc,
          "tid": tid,
          "encode_status": encodeStatus
        });

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res:${response.statusCode}");

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          final encodeStatus = EncodeStatus.fromJson(response.data);

          if (encodeStatus.code == 200) {
            Dialogs.showSuccess("Başarılı Bir Şekilde Kaydedildi!");
            return encodeStatus;
          } else {
            Dialogs.showFailed(encodeStatus.err!.message!);
            return encodeStatus;
          }
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
            return null;
          }
        }
      });
    } catch (e) {
      debugPrint("Get locations error: $e");
      return null;
    }
  }

  @override
  Future<SerialNumber?> getSerialFromDatabase(String accessToken) async {
    try {
      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };

        final response = await _dio.post('$value/encode/encode_serial', data: {
          "access_token": accessToken,
        });

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res:${response.statusCode}");

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          final serialNumber = SerialNumber.fromJson(response.data);

          if (serialNumber.code == 200) {
            return serialNumber;
          } else {
            Dialogs.showFailed(serialNumber.err!.message!);
            return serialNumber;
          }
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
            return null;
          }
        }
      });
    } catch (e) {
      debugPrint("Get locations error: $e");
      return null;
    }
  }

  //You can create web server snippet for http request with dio
  @override
  Future<CreateSuccess?> addInventory(
      String title, String accessToken, bool isShipment) async {
    try {
      debugPrint("Shipment State $isShipment");

      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        final response = await _dio.post(
            '$value/${isShipment ? "shipment" : "inventories"}/create',
            data: {
              "access_token": accessToken,
              isShipment ? "shipment_name" : "inventory_name": title,
              "device_id": androidInfo.id,
              "device_name": androidInfo.device
            });

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res:${response.statusCode}");

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          final createResult = CreateSuccess.fromJson(response.data);

          if (createResult.code == 200) {
            if (createResult.data!) {
              Dialogs.showSuccess("Başarılı bir şekilde oluşturuldu");
            } else {
              Dialogs.showFailed("Bir şeyler ters gitti!");
            }

            return createResult;
          } else {
            Dialogs.showFailed(createResult.err!.message!);
            return createResult;
          }
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
            return null;
          }
        }
      });
    } catch (e) {
      debugPrint("addInventory error: $e");
      return null;
    }
  }

  @override
  Future<InventoryList?> getInventories(
      String accessToken, bool isShipment) async {
    try {
      debugPrint("Shıpment: $isShipment}");

      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };

        final response = await _dio.post(
            '$value/${isShipment ? "shipment" : "inventories"}/list',
            data: {
              "access_token": accessToken,
            });

        debugPrint("Response Data: ${response.data.toString()}");

        debugPrint("Res:${response.statusCode}");

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          final inventoryListResult =
              InventoryList.fromJson(response.data, isShipment);

          if (inventoryListResult.code == 200) {
            return inventoryListResult;
          } else {
            Dialogs.showFailed(inventoryListResult.err!.message!);
            return inventoryListResult;
          }
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
            return null;
          }
        }
      });
    } catch (e) {
      debugPrint("addInventory error: $e");
      return null;
    }
  }

/*{
    "access_token"  : "{{access_token}}",
    "inventories_id"      : "8",
    "device_id":"1111",
    "device_name":"test_zebra",
    "inventories_close":"0",
    "tag_list" : [
        {
            "epc" : "9080000000072FEB42C98E220001E240",
            "read_date": "2022-12-04 21:32:43"
        },
        {
            "epc" : "9080000000072FEB42C98E230001E240",
            "read_date": "2022-12-04 21:32:43"
        },
         {
            "epc" : "9080000000072FEB42C98E240001E240",
            "read_date": "2022-12-04 21:32:43"
        }
    ]
}*/
  @override
  Future<void> sendTags(String accessToken, Inventory inventory,
      List<dynamic> readEpcList, bool saveAndClose, bool isShipment) async {
    try {
      debugPrint("--${readEpcList.toList()}");

      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        Map<String, dynamic> data = {
          "access_token": accessToken,
          isShipment ? "shipment_id" : "inventories_id": inventory.iD,
          "device_id": androidInfo.id,
          "device_name": androidInfo.device,
          isShipment ? "shipment_close" : "inventories_close":
              saveAndClose ? "1" : "0",
          "tag_list": readEpcList
        };
        debugPrint(data.toString());
        final response = await _dio.post(
            '$value/${isShipment ? "shipment" : "inventories"}/record',
            data: data);

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res:${response.statusCode}");

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          Dialogs.showSuccess("Başarılı bir şekilde kaydedildi!");
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
          }
        }
      });
    } catch (e) {
      debugPrint("addInventory error: $e");
    }
  }

  Future<EpcDetail?> getEpcDetail(String accessToken, String epc) async {
    try {
      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };

        Map<String, dynamic> data = {"access_token": accessToken, "epc": epc};

        final response =
            await _dio.post('$value/encode/encode_checker', data: data);

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res:${response.statusCode}");

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          var epcDetail = EpcDetail.fromJson(response.data);

          if (epcDetail.code == 200) {
            return epcDetail;
          } else {
            return null;
          }
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
          }
          return null;
        }
      });
    } catch (e) {
      debugPrint("addInventory error: $e");
    }
    return null;
  }

  @override
  Future<List<ReadEpc>> getReadList(
      {String? accessToken, String? shipmentId, required bool isShipment}) async {
    try {
      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };

        final response = await _dio.post('$value/${isShipment ? 'shipment':'inventories'}/details',
            data: {"access_token": accessToken, isShipment ? 'shipment_id':'inventories_id': shipmentId});

        debugPrint("Response Data: ${response.data.toString()}");

        debugPrint("Res:${response.statusCode}");

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          final readList = ReadList.fromJson(response.data);

          return readList.data!;
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
            return [];
          }
        }
        return [];
      });
    } catch (e) {
      debugPrint("readEpcList error: $e");
      return [];
    }
  }

  @override
  Future<Version?> getVersion() async {
    try {
      return await urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };

        final response = await _dio.get('$value/server/version');

        debugPrint("Response Data: ${response.data.toString()}");

        debugPrint("Res:${response.statusCode}");

        if (response.statusCode == 200 &&
            !response.data.toString().contains("TOKEN WRONG")) {
          final version = Version.fromJson(response.data);

          return version;
        } else {
          if (response.data.toString().contains("TOKEN WRONG")) {
            _tokenExpiredLogout();
            return null;
          }
        }
        return null;
      });
    } catch (e) {
      debugPrint("readEpcList error: $e");
      return null;
    }
  }
}
