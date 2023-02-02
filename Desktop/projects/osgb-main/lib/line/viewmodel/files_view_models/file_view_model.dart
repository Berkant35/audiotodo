import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as wp;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:state_notifier/state_notifier.dart';
import '../../../models/custom_file.dart';
import '../../../models/inspection.dart';
import '../../../models/wait_fix.dart';
import '../../../utilities/constants/extension/context_extensions.dart';
import '../../../utilities/init/navigation/navigation_service.dart';
import '../../../utilities/init/theme/custom_colors.dart';
import '../../network/database/fb_db_manager.dart';
import '../../network/database/storage_db_base.dart';

class FileViewModel extends StateNotifier<String?> {
  FileViewModel(String? state) : super(null);
  final fb = FirebaseDbManager();
  final fireStorage = FirebaseStorageService();
  final pdf = pw.Document();

  Future<void> createPDFAndDownload(
      WidgetRef ref, Inspection currentInspection) async {
    debugPrint("JSON:${currentInspection.toJson()}");
    /*final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(currentInspection.toJson().toString());*/

    final font = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
    final font2 = await rootBundle.load("assets/fonts/Poppins-Bold.ttf");
    final ttf = pw.Font.ttf(font);
    final ttf2 = pw.Font.ttf(font2);

    //1.sayfayı oluştur
    List<pw.Widget> widgets = [];

    widgets.add(pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Header(
              text: "Denetim Raporu",
              textStyle: pw.TextStyle(
                fontSize: 26,
                font: ttf2,
              )),
          pw.SizedBox(height: 15),
          perRow("İş Yeri:", currentInspection.customerName!, ttf, ttf2),
          perRow("İnceleme ID:", currentInspection.inspectionID!.toUpperCase(),
              ttf, ttf2),
          perRow("Denetimi Gerçekleştiren:",
              currentInspection.expertName!.toUpperCase(), ttf, ttf2),
          perRow(
              "İnceleme Tarih:", currentInspection.inspectionDate!, ttf, ttf2),
          perRow("Toplam Düzeltilmesi Gereken Sayı:",
              currentInspection.waitFixList!.length.toString(), ttf, ttf2),
          perRow("Düzeltilmesi Gereken 'Çok Önemli' Durum Sayısı:",
              currentInspection.highDanger!.toString(), ttf, ttf2),
          perRow("Düzeltilmesi Gereken 'Önemli' Durum Sayısı:",
              currentInspection.normalDanger!.toString(), ttf, ttf2),
          perRow("Düzeltilmesi Gereken 'Yapılsa İyi Olur' Durum Sayısı:",
              currentInspection.lowDanger!.toString(), ttf, ttf2),
          perColumn(
              "Açıklama", currentInspection.inspectionExplain!, ttf, ttf2),
          columnList(currentInspection, ttf, ttf2)
        ]));
    for (int i = 0; i < currentInspection.waitFixList!.length; i++) {
      final waitFix = WaitFix.fromJson(currentInspection.waitFixList![i]);
      Response<Uint8List>? image;

      image = await Dio().get(
        "https://pixlr.com/images/index/filter-effect.webp",
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      widgets.add(
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.SizedBox(height: 10),
        perColumn("${i + 1}) ${(waitFix).waitFixTitle!}",
            waitFix.waitFixContent!, ttf, ttf2),
        pw.SizedBox(height: 5),
        perRow("Tehlike Derecesi:", waitFix.waitFixDegree!, ttf, ttf2),
        pw.SizedBox(height: 5),
        pw.Image(
          PdfImage(pdf.document,
              image: image.data!, width: 50, height: 50, jpeg: false),
        ),
        pw.SizedBox(height: 10),
      ]));
    }

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return widgets;
        }));

    final output = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();

    String filePath =
        "${Platform.isIOS ? output!.absolute.path : output!.path}/pdf/${currentInspection.inspectionID!}.pdf";

    try {
      final file = await File(filePath).create(recursive: true);

      var bytes = pdf.save();

      await file.writeAsBytes(bytes).then((value) {
        Fluttertoast.showToast(msg: "PDF Dosyası indirildi!");

        var currentContext =
            NavigationService.instance.navigatorKey.currentState!.context;
        Navigator.of(currentContext).push(MaterialPageRoute(
            builder: (_) => WillPopScope(
                  onWillPop: () async => false,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: CustomColors.primaryColor,
                      leading: IconButton(
                        onPressed: () {
                          pdf.document.pdfPageList.pages.clear();
                          NavigationService.instance.navigatePopUp();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Share.shareXFiles([XFile(filePath)],
                                  text:
                                      "${currentInspection.customerName} iş yerine ${currentInspection.inspectionDate!.substring(0, 16)} tarihinde yapılan denetim raporudur.");
                            },
                            icon: const Icon(Icons.share))
                      ],
                      centerTitle: false,
                      title: Text(
                        "${currentInspection.customerName}",
                        style: ThemeValueExtension.subtitle2,
                      ),
                    ),
                    body: Center(
                      child: SizedBox(
                        width: 95.w,
                        child: Card(
                          elevation: 5,
                          child: PdfView(path: value.path),
                        ),
                      ),
                    ),
                  ),
                )));
      });
    } catch (e) {
      debugPrint("PDF Creating error $e");
    }
  }

  pw.Padding perRow(String header, String content, wp.Font ttf, wp.Font ttf2) {
    return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 10),
        child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text(header,
                  style: pw.TextStyle(
                      fontSize: fontSize(),
                      font: ttf2,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(width: 5),
              pw.Text(content,
                  style: pw.TextStyle(
                      fontSize: fontSizeContent(),
                      font: ttf,
                      fontWeight: pw.FontWeight.normal))
            ]));
  }

  double fontSize() => 18;

  double fontSizeContent() => 17;

  pw.Column perColumn(
      String header, String content, wp.Font ttf, wp.Font ttf2) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.SizedBox(height: 10),
          pw.Text(header,
              style: pw.TextStyle(
                  fontSize: fontSize(),
                  font: ttf2,
                  fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Paragraph(
              text: content,
              style: pw.TextStyle(
                  fontSize: fontSizeContent(),
                  font: ttf,
                  fontWeight: pw.FontWeight.normal)),
          pw.SizedBox(height: 10),
        ]);
  }

  pw.Column contiuneList(Inspection currentInspection, wp.Font font,
      wp.Font font2, int startIndex) {
    return pw.Column(children: [
      for (int i = 0; i < 8; i++)
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          perColumn(
              "${i + 1}) ${(WaitFix.fromJson(currentInspection.waitFixList![0])).waitFixTitle!}",
              (WaitFix.fromJson(currentInspection.waitFixList![0]))
                  .waitFixContent!,
              font,
              font2),
          pw.SizedBox(height: 5),
          perRow(
              "Tehlike Derecesi:",
              (WaitFix.fromJson(currentInspection.waitFixList![0]))
                  .waitFixDegree!,
              font,
              font2),
        ])
    ]);
  }

  pw.Column columnList(
      Inspection currentInspection, wp.Font font, wp.Font font2) {
    return pw.Column(children: [
      perRow("Düzeltilmesi Gereken Durumlar", "", font, font2),
      pw.Container(
          height: 2, width: 10000, color: const PdfColor.fromInt(0xFF000000)),
    ]);
  }

  Future<List<CustomFile>> getCustomFileList(String rootUserID) async {
    try{
      var list = await fb.getFileListOfCustomer(rootUserID);
      list.sort((a, b) => b.uploadingDate!.compareTo(a.uploadingDate!));
      return list;
    }catch(e){
      debugPrint('$e<-err');
      return [];
    }

  }

  Future<bool> uploadCustomFile(
    CustomFile file,
    WidgetRef ref,
    File? localFile,
  ) async {
    try {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loading);
      return await fireStorage
          .getPhotoLink(localFile)
          .then((fileLinkFromFirebase) async {
        if(fileLinkFromFirebase != null){
          file.fileURL = fileLinkFromFirebase;
          return await fb.uploadFileToCustomer(file).then((value) {

            return value;
          });
        }else{
          return false;
        }

      });
    } finally {
      ref
          .read(currentButtonLoadingState.notifier)
          .changeState(LoadingStates.loaded);
    }
  }
}

/*if (currentInspection.waitFixList!.length > 2) {
      var currentIndex = -5;
      var partCount = (currentInspection.waitFixList!.length - 2) ~/ 7;
      var lastPart = (currentInspection.waitFixList!.length - 2) % 7;

      for (int i = 0; i < partCount; i++) {
        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              currentIndex = currentIndex + 7;
              return pw.Column(children: [
                for (int i = currentIndex; i < (currentIndex + 7); i++)
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        perColumn(
                            "${i + 1}) ${(WaitFix.fromJson(currentInspection.waitFixList![i])).waitFixTitle!}",
                            (WaitFix.fromJson(
                                    currentInspection.waitFixList![i]))
                                .waitFixContent!,
                            ttf,
                            ttf2),
                        pw.SizedBox(height: 5),
                        perRow(
                            "Tehlike Derecesi:",
                            (WaitFix.fromJson(
                                    currentInspection.waitFixList![i]))
                                .waitFixDegree!,
                            ttf,
                            ttf2),
                      ])
              ]);
            }));
      }

      debugPrint("Current1 $currentIndex");
      if (lastPart > 0) {

        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {

              currentIndex = currentIndex  + 7;
              return pw.Column(children: [
                for (int i = currentIndex; i < currentIndex + (lastPart); i++)
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        perColumn(
                            "${i + 1}) ${(WaitFix.fromJson(currentInspection.waitFixList![i])).waitFixTitle!}",
                            WaitFix.fromJson(currentInspection.waitFixList![i])
                                .waitFixContent!,
                            ttf,
                            ttf2),
                        pw.SizedBox(height: 5),
                        perRow(
                            "Tehlike Derecesi:",
                            (WaitFix.fromJson(
                                    currentInspection.waitFixList![i]))
                                .waitFixDegree!,
                            ttf,
                            ttf2),
                      ])
              ]);
            }));
      }
    }*/
