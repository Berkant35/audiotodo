import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:mime/mime.dart';

import 'package:flutter/material.dart';
import 'package:osgb/utilities/constants/app/enums.dart';

class CustomFunctions {
  static bool isPhone() {
    bool isPhone;

    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isPhone = false;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isPhone = false;
    } else {
      isPhone = true;
    }
    return isPhone;
  }
  static getIconDataByFileName(String fileName){
   if(fileName.contains("pdf")){
     return Icons.picture_as_pdf;
   }else if(fileName.contains("jpg") || fileName.contains("png") || fileName.contains("jpeg")){
     return Icons.image;
   }else{
     return Icons.file_copy_outlined;
   }

  }

  static getFileSize(File file, int decimals) {
    int bytes = file.lengthSync();
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();

    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
  static double customScale(MediaQueryData query) {
    return isPhone() ? 1 : 2.25;
  }

  static String getKeyForDangerInspections(String value) {
    switch (value) {
      case "Yapılması Önerilir":
        return "lowDanger";
      case "Önemli":
        return "normalDanger";
      case "Çok Önemli":
        return "highDanger";
      default:
        return "normalDanger";
    }
  }

  static Roles getTypeFromString(String name) {

    switch(name)
    {
      case "expert":
        return Roles.expert;
      case "accountant":
        return Roles.accountant;
      case "customer":
        return Roles.customer;
      case  "doctor":
        return Roles.doctor;
      case  "worker":
        return Roles.worker;
      default:
        return Roles.none;
    }

  }

  static String getNameOfType(Roles roles) {
    switch (roles) {
      case Roles.none:
        return "TANIMSIZ";
      case Roles.admin:
        return "Admin";
      case Roles.accountant:
        return "Muhasebeci";
      case Roles.customer:
        return "Müşteri";
      case Roles.expert:
        return "Uzman";
      case Roles.doctor:
        return "Doktor";
      case Roles.worker:
        return "Çalışan";
    }
  }

  static String getFileExtension(String fileName) {

    var result = ".${fileName.split('.').last}";

    if(result.contains("pdf")){
      return ".pdf";
    }else if(result.contains("jpg")){
      return ".jph";
    }else if(result.contains("jpeg")){
      return ".jpeg";
    }else if(result.contains("png")){
      return ".png";
    }else if(result.contains(".doc")){
      return ".doc";
    }else{
      return result;
    }
  }

}
