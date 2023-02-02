import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_filex/open_filex.dart';
import 'package:osgb/custom_functions.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/custom_file.dart';
import 'package:osgb/utilities/components/custom_card.dart';
import 'package:osgb/utilities/components/file_detail_alert_dialog.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:search_page/search_page.dart';

import '../../../../models/customer.dart';
import '../../../../utilities/init/theme/custom_colors.dart';
import '../../../common/files_detail.dart';

class FilesOfCustomers extends ConsumerStatefulWidget {
  final Customer customer;

  const FilesOfCustomers({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  ConsumerState createState() => _FilesOfCustomersState();
}

class _FilesOfCustomersState extends ConsumerState<FilesOfCustomers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: Padding(
              padding: seperatePadding(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Dosyalar",
                        style: ThemeValueExtension.headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () async {
                            var fileList = <CustomFile>[];
                            fileList = await ref
                                .read(currentFileState.notifier)
                                .getCustomFileList(widget.customer.rootUserID!);
                            if (fileList.isNotEmpty) {
                              showSearch(
                                context: context,
                                delegate: SearchPage<CustomFile>(
                                  items: fileList,
                                  searchLabel: 'Ara',
                                  suggestion: Center(
                                    child: Padding(
                                      padding: seperatePadding(),
                                      child: Text(
                                        'Dosya isimine göre ara',
                                        style: ThemeValueExtension.subtitle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  failure: Center(
                                    child: Text(
                                      'Sonuç bulunamadı',
                                      style: ThemeValueExtension.subtitle,
                                    ),
                                  ),
                                  filter: (customFile) => [
                                    customFile.fileName,
                                  ],
                                  builder: (customFile) => ListTile(
                                    leading: Icon(
                                        CustomFunctions.getIconDataByFileName(
                                            customFile.fileURL!)),
                                    title: Text(
                                      customFile.fileName!,
                                      style: ThemeValueExtension.subtitle,
                                    ),
                                    subtitle: Text(
                                      customFile.fileSize!,
                                      style: ThemeValueExtension.subtitle2
                                          .copyWith(
                                              color:
                                                  CustomColors.customGreyColor),
                                    ),
                                    onTap: () => showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return FileDetailAlertDialog(
                                            customFile: customFile,
                                            customerName:
                                                widget.customer.customerName,
                                          );
                                        }),
                                  ),
                                ),
                              );
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Aranacak bir kullanıcı bulunmamaktadır");
                            }
                          },
                          icon: const Icon(
                            Icons.search,
                            color: CustomColors.secondaryColor,
                          ))
                    ],
                  ),
                  IconButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          File file = File(result.files.single.path!);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FileDetail(
                                    file: file,
                                    customer: widget.customer,
                                    canUploadFile: true,
                                    setStateForParent: (value) {
                                      setState(() {
                                        debugPrint("Value $value");
                                      });
                                    },
                                  )));
                        } else {
                          Fluttertoast.showToast(msg: "Dosya Seçilemedi!");
                        }
                      },
                      icon: const Icon(
                        Icons.add_box_outlined,
                        color: CustomColors.secondaryColor,
                      ))
                ],
              ),
            ),
          ),
        ),
        Expanded(
            flex: 9,
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(
                children: [
                  FutureBuilder<List<CustomFile>>(
                    future: ref
                        .read(currentFileState.notifier)
                        .getCustomFileList(widget.customer.rootUserID!),
                    builder: (context, snapshot) {
                      var listOfFiles = snapshot.data;
                      return snapshot.connectionState == ConnectionState.done
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: listOfFiles!.length,
                              itemBuilder: (context, index) {
                                var customFile = listOfFiles[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomCard(
                                    networkImage: "networkImage",
                                    header1: "Dosya Adı",
                                    content1: customFile.fileName!,
                                    specificIconData:
                                        CustomFunctions.getIconDataByFileName(
                                            customFile.fileURL!),
                                    header2: "Dosya Boyutu",
                                    content2: customFile.fileSize!,
                                    header3: "Eklenme Tarihi",
                                    content3: customFile.uploadingDate!,
                                    navigationContentText: "indir",
                                    onClick: () => showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return FileDetailAlertDialog(
                                            customFile: customFile,
                                            customerName:
                                                widget.customer.customerName,
                                          );
                                        }),
                                  ),
                                );
                              })
                          : const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
