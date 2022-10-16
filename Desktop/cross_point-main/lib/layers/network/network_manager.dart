import 'dart:io';

import 'package:cross_point/layers/local/local_manager.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utilities/common_widgets/flutter_toast_dialog.dart';
import '../../utilities/constants/url_constants.dart';
import '../../utilities/navigation/navigation_constants.dart';
import '../../utilities/navigation/navigation_service.dart';
import '../models/items.dart';
import '../models/location_model.dart';
import '../models/login_success.dart';
import '../repository/locator.dart';

part 'network_base.dart';

class NetworkManager extends NetworkManagerBase {
  static NetworkManager? _instance;

  final urlConstans = locator<UrlConstants>();
  final localService = locator<LocaleService>();

  static NetworkManager? get instance {
    _instance ??= NetworkManager._();
    return _instance;
  }

  NetworkManager._();

  @override
  Future<LoginSuccess?> login(String email,String password) async {
    try {
      return urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };
        debugPrint("Link ${'${value!}/user/login'}");
        debugPrint("Values|$email|+$password");

        final response = await _dio.post('$value/user/login',
            data: {'email': email, 'password': password});

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res");

        if (response.statusCode == 200) {
          debugPrint('200 OK!-> ${response.toString()}');
          debugPrint('200 OK!-> ${response.data}');
          final loginSuccess = LoginSuccess.fromJson(response.data);
          ("Login Success Result ${loginSuccess.toJson().toString()}");

          if(loginSuccess.code == 200){
            return loginSuccess;
          }else{
            Dialogs.showFailed(loginSuccess.err!.message!);
            return null;
          }
        }
      });
    } catch (e) {
      return null;
    }

    return null;
  }

  @override
  Future<Locations?> getLocations(String token) async {
    try {
      return urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };


        final response = await _dio.post('$value/location/getLocations/',
            data: {'access_token': token});

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res");

        if (response.statusCode == 200 && !response.data.toString().contains("TOKEN WRONG")) {
          debugPrint('200 OK!-> ${response.toString()}');
          debugPrint('200 OK!-> ${response.data}');
          debugPrint("<*<**<*<**code");



          final locations = Locations.fromJson(response.data);



          if(locations.code == 200){
            return locations;
          }else{
            Dialogs.showFailed(locations.err!.message!);
            return locations;
          }
        }else{
          if(response.data.toString().contains("TOKEN WRONG")){
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
  Future<Items?> getItems(String token, String locationID) async {
    try {
      return urlConstans.getUrl().then((value) async {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient dioClient) {
          dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };


        final response = await _dio.post('$value/items/getItems/',
            data: {'access_token': token,"location" : locationID});

        debugPrint("Response: ${response.toString()}");

        debugPrint("Res");

        if (response.statusCode == 200 && !response.data.toString().contains("TOKEN WRONG")) {

          final items = Items.fromJson(response.data);

          if(items.code == 200){
            return items;
          }else{
            Dialogs.showFailed("Something went wrong!");
            return items;
          }
        }else{
          if(response.data.toString().contains("TOKEN WRONG")){
            return null;
          }
        }
      });
    } catch (e) {
      debugPrint("Get locations error: $e");
      return null;
    }
  }

}
