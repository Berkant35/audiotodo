import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FirebaseStorageService {
  Future<String?> createQRLink(String userID,String companyName) async {
    try{

      ByteData? qrBytes = await QrPainter(
          data: userID,
          gapless: true,
          version: QrVersions.auto,
          emptyColor: Colors.white
      ).toImageData(878);

      if (qrBytes != null) {
        File qrFile = await saveImage(qrBytes, companyName); //<--- see below for this function

        final firebaseStorageRef = FirebaseStorage.instance.ref(qrFile.path);
        UploadTask uploadTask = firebaseStorageRef.putFile(qrFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        var createdUrl = await taskSnapshot.ref.getDownloadURL();
        return createdUrl;
      } else {
        return null;
      }
    }catch(e){
      debugPrint('$e<-err');
      return null;
    }
  }
  Future<String?> getPhotoLink(File? photo) async {
    try{
      final firebaseStorageRef = FirebaseStorage.instance.ref(photo?.path);
      if (photo != null) {
        UploadTask uploadTask = firebaseStorageRef.putFile(photo);
        TaskSnapshot taskSnapshot = await uploadTask;
        var createdUrl = await taskSnapshot.ref.getDownloadURL();
        return createdUrl;
      } else {
        return null;
       }
    }catch(e){
      debugPrint('$e<-err');
      return null;
    }
  }

  Future<File> saveImage(ByteData data, String name) async {

    var path = await _localPath; //<-- see below function

    final buffer = data.buffer;
    return File('$path/$name.png')
        .writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }


  Future<File> saveFile(ByteData data, String name,String type) async {

    var path = await _localPath; //<-- see below function

    final buffer = data.buffer;
    return File('$path/$name.$type')
        .writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }


  Future<String?> getFileLink(File? file) async {
    try{
      final firebaseStorageRef = FirebaseStorage.instance.ref(file?.path);
      if (file != null) {
        UploadTask uploadTask = firebaseStorageRef.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;
        var createdUrl = await taskSnapshot.ref.getDownloadURL();
        return createdUrl;
      } else {
        return null;
      }
    }catch(e){
      debugPrint('$e<-err');
      return null;
    }
  }






}
