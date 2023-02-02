import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanoid/async.dart';
import 'package:ntp/ntp.dart';
import 'package:osgb/custom_functions.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/notification_model.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/row_form_field.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/custom_file.dart';
import '../../models/customer.dart';
import '../../utilities/constants/extension/context_extensions.dart';
import '../../utilities/init/navigation/navigation_service.dart';
import '../../utilities/init/theme/custom_colors.dart';

class FileDetail extends ConsumerStatefulWidget {
  final File file;
  final Customer customer;
  final bool canUploadFile;
  final String? Function(String? value) setStateForParent;

  const FileDetail({
    Key? key,
    required this.customer,
    required this.file,
    required this.canUploadFile,
    required this.setStateForParent,
  }) : super(key: key);

  @override
  ConsumerState createState() => _FileDetailState();
}

class _FileDetailState extends ConsumerState<FileDetail> {
  late TextEditingController? titleController;
  late TextEditingController? contentController;
  late File localFile;
  final _fileUploadFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    localFile = widget.file;
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController!.dispose();
    contentController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Dosya Detay",
          style: ThemeValueExtension.subtitle,
        ),
      ),
      body: Form(
        key: _fileUploadFormKey,
        child: Padding(
          padding: seperatePadding(),
          child: ListView(
            children: [
              Text(
                "Dosya Yükleme",
                style: ThemeValueExtension.headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              infoColumn("Dosya Yolu", localFile.path),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  infoColumn("Dosya Boyut",
                      CustomFunctions.getFileSize(localFile, 1).toString()),
                  Icon(
                    CustomFunctions.getIconDataByFileName(localFile.path),
                    size: 3.h,
                    color: CustomColors.pinkColor,
                  ),
                ],
              ),
              RowFormField(
                headerName: "Dosya Başlık",
                hintText: "2023 Mart dekont",
                canEdit: widget.canUploadFile,
                maxLength: 30,
                editingController: titleController!,
                custValidateFunction: (value) =>
                    value != "" ? null : "Bu alan boş bırakılamaz",
              ),
              RowFormField(
                headerName: "Dosya Açıklama",
                hintText: "2023 Mart ayının dekontunun pdf dosyasıdır",
                canEdit: widget.canUploadFile,
                editingController: contentController!,
                maxLines: 5,
                custValidateFunction: (value) =>
                    value != "" ? null : "Bu alan boş bırakılamaz",
              ),
              SizedBox(
                height: 2.h,
              ),
              uploadButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadButton() {
    return ref.watch(currentButtonLoadingState) != LoadingStates.loading
        ? CustomElevatedButton(
            onPressed: () async {
              _fileUploadFormKey.currentState!.save();
              if (_fileUploadFormKey.currentState!.validate()) {
                var nanoID = await nanoid();
                var currentTime = await NTP.now();
                var customFile = CustomFile(
                    fileExplain: contentController!.text,
                    fileID: nanoID,
                    fileName: titleController!.text,
                    uploadingDate: currentTime.toString().substring(0, 16),
                    fileSize:
                        CustomFunctions.getFileSize(localFile, 1).toString(),
                    customerID: widget.customer.rootUserID);
                ref
                    .read(currentFileState.notifier)
                    .uploadCustomFile(customFile, ref, localFile)
                    .then((value) async {
                  if (value) {
                    Fluttertoast.showToast(
                        msg: "Başarılı bir şekilde dosya yüklendi!");

                    var notification = CustomNotification(
                        title: "Dosya Gönderimi Gerçekleşti",
                        body: (ref.read(currentRole) == Roles.admin ||
                                ref.read(currentRole) == Roles.expert)
                            ? "SU OSGB Size Bir Dosya Gönderdi"
                            : "${widget.customer.customerName} Size Bir Dosya Gönderdi",
                        sound: "default");

                    var admin = await ref
                        .read(currentBaseModelState.notifier)
                        .getAdmin();
                    var notificationModel = NotificationModel(
                        to: (ref.read(currentRole) == Roles.admin ||
                                ref.read(currentRole) == Roles.expert)
                            ? widget.customer.pushToken!
                            : admin!.pushToken,
                        priority: "high",
                        notification: notification);

                    ref
                        .read(currentPushNotificationState.notifier)
                        .sendPush(notificationModel);

                    widget.setStateForParent("test");
                    NavigationService.instance.navigatePopUp();
                  } else {
                    Fluttertoast.showToast(msg: "Bir şeyler ters gitti");
                  }
                });
              }
            },
            inButtonText: null,
            primaryColor: CustomColors.secondaryColorM,
            inButtonWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload,
                  size: 4.h,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  "Dosya Yükle",
                  style: ThemeValueExtension.subtitle,
                )
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(),
          );
  }

  Padding infoColumn(String header, String content) => Padding(
        padding: seperatePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(header,
                style: ThemeValueExtension.subtitle
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(content, style: ThemeValueExtension.subtitle3),
          ],
        ),
      );
}
