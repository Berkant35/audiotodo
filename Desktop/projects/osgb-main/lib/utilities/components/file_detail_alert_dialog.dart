import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_filex/open_filex.dart';
import 'package:osgb/models/custom_file.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../custom_functions.dart';
import '../../line/viewmodel/global_providers.dart';
import '../constants/app/enums.dart';
import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';

class FileDetailAlertDialog extends ConsumerStatefulWidget {
  final CustomFile customFile;
  final String? customerName;

  const FileDetailAlertDialog({
    Key? key,
    required this.customFile,
    required this.customerName,
  }) : super(key: key);

  @override
  ConsumerState createState() => _FileDetailAlertDialogState();
}

class _FileDetailAlertDialogState extends ConsumerState<FileDetailAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.customFile.fileName!,
          style: ThemeValueExtension.headline6
              .copyWith(fontWeight: FontWeight.bold)),
      insetPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            buildRow("Dosya Açıklama", widget.customFile.fileExplain!),
            SizedBox(
              height: 2.h,
            ),
            buildRow("Dosya Boyut", widget.customFile.fileSize!),
            SizedBox(
              height: 2.h,
            ),
            buildRow("Dosya ID", widget.customFile.fileID!),
            SizedBox(
              height: 2.h,
            ),
            ref.watch(currentButtonLoadingState) != LoadingStates.loading ? CustomElevatedButton(
              onPressed: () => downloadAndOpen(widget.customFile),
              inButtonText: null,
              primaryColor: CustomColors.secondaryColorM,
              inButtonWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download,
                    size: 3.h,
                  ),
                  SizedBox(width: 2.w,),
                  Text(
                    "İndir",
                    style: ThemeValueExtension.subtitle,
                  )
                ],
              ),
            ) : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator.adaptive(),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "İndiriliyor %${ref.watch(currentPercentLoadingState)}",
                    style: ThemeValueExtension.subtitle,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> downloadAndOpen(CustomFile file) async {
    ref
        .read(currentButtonLoadingState.notifier)
        .changeState(LoadingStates.loading);
    final output = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
    var type = CustomFunctions.getFileExtension(file.fileURL!);
    String filePath =
        "${Platform.isIOS ? output!.absolute.path : output!.path}/${widget.customerName}/${type.substring(1, type.length)}$type";

    try {
      await Dio().download(file.fileURL!, filePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          debugPrint((received / total * 100).toInt().toString());
          ref
              .read(currentPercentLoadingState.notifier)
              .changeState((received / total * 100).toInt());
        }
      }).then((value) {
        Future.delayed(const Duration(milliseconds: 500),(){
          Fluttertoast.showToast(msg: "Dosya Başarılı bir şekilde indirildi!");
          ref
              .read(currentButtonLoadingState.notifier)
              .changeState(LoadingStates.loaded);
          OpenFilex.open(filePath).then((value) {
            ref.read(currentPercentLoadingState.notifier).changeState(0);
          });
        });

      });
    } on DioError catch (e) {
      debugPrint('$e<--eRR');
      Fluttertoast.showToast(msg: "Dosya İndirilemedi!");

    }
  }

  Row buildRow(String header, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            header,
            style: ThemeValueExtension.subtitle
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: ThemeValueExtension.subtitle.copyWith(
              fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
