import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/demand.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/custom_flexible_bar.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../models/notification_model.dart';
import '../../../../../utilities/init/theme/custom_colors.dart';

class ConfirmAddWorker extends ConsumerStatefulWidget {
  final DemandWorker demandWorker;

  const ConfirmAddWorker({Key? key, required this.demandWorker})
      : super(key: key);

  @override
  ConsumerState createState() => _ConfirmAddWorkerState();
}

class _ConfirmAddWorkerState extends ConsumerState<ConfirmAddWorker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        toolbarHeight: 30.h,
        flexibleSpace: CustomFlexibleBar(
          firstHeader: "Çalışan Adı",
          secondHeader: "Görevi",
          thirdHeader: "Şirket",
          firstInfo:   widget.demandWorker.demandWorker!.workerName,
          secondInfo:  widget.demandWorker.demandWorker!.workerJob,
          thirdInfo:   widget.demandWorker.demandByCustomer!.customerName,
          headerPhoto: widget.demandWorker.demandWorker!.photoURL,
          appBarTitle: "Çalışan Talep",
          role: Roles.customer,
        ),
      ),
      body: Padding(
        padding: seperatePadding(),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Text(
              "Düzenle",
              style: ThemeValueExtension.headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            infoRowForWorker(
                "Çalışan Adı", widget.demandWorker.demandWorker!.workerName!),

            infoRowForWorker(
                "Görev", widget.demandWorker.demandWorker!.workerJob!),
            infoRowForWorker("Çalışan Telefon",
                widget.demandWorker.demandWorker!.workerPhoneNumber!),
            infoRowForWorker(
                "Şirket", widget.demandWorker.demandByCustomer!.customerName!),
            infoRowForWorker("İşe Başlangıç Tarihi",
                widget.demandWorker.demandWorker!.startAtCompanyDate!),
            SizedBox(
              height: 4.h,
            ),
            ref.watch(currentButtonLoadingState) != LoadingStates.loading
                ? Column(
                    children: [
                      Center(
                          child: CustomElevatedButton(
                        onPressed: () {
                          ref
                              .read(currentAdminWorksState.notifier)
                              .confirmWorkDemand(widget.demandWorker, ref)
                              .then((value) {
                                debugPrint("$value");
                            if (value) {
                              ref
                                  .read(currentPushNotificationState.notifier)
                                  .sendPush(
                                    NotificationModel(
                                      to: widget.demandWorker.demandByCustomer!
                                          .pushToken!,
                                      priority: "high",
                                      notification: CustomNotification(
                                          title: "Çalışan Talebiniz Onaylandı",
                                          body:
                                              "${widget.demandWorker.demandWorker!.workerName} çalışanınız onaylanmıştır")));
                            } else {
                              ref
                                  .read(currentAdminWorksState.notifier)
                                  .deleteWorkDemand(
                                      widget.demandWorker.demandID!, ref)
                                  .then((value) {
                                ref
                                    .read(currentPushNotificationState.notifier)
                                    .sendPush(NotificationModel(
                                        to: widget.demandWorker
                                            .demandByCustomer!.pushToken!,
                                        priority: "high",
                                        notification: CustomNotification(
                                            title:
                                                "Çalışan Talebiniz Reddedildi",
                                            body:
                                                "${widget.demandWorker.demandWorker!.workerName} çalışanınız reddedilmiştir.")));
                              });
                            }
                          });
                        },
                        inButtonText: "Çalışan Talebini Onayla",
                        primaryColor: CustomColors.secondaryColorM,
                      )),
                      SizedBox(
                        height: 2.h,
                      ),
                      Center(
                          child: CustomElevatedButton(
                        onPressed: () {
                          ref
                              .read(currentAdminWorksState.notifier)
                              .deleteWorkDemand(
                                  widget.demandWorker.demandID!, ref)
                              .then((value) {
                            ref
                                .read(currentPushNotificationState.notifier)
                                .sendPush(NotificationModel(
                                    to: widget.demandWorker.demandByCustomer!
                                        .pushToken!,
                                    priority: "high",
                                    notification: CustomNotification(
                                        title: "Çalışan Talebiniz Reddedildi",
                                        body:
                                            "${widget.demandWorker.demandWorker!.workerName} çalışanınız reddedilmiştir.")));
                          });
                        },
                        inButtonText: "Talebi Reddet",
                        primaryColor: CustomColors.orangeColorM,
                      )),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
            SizedBox(
              height: 25.h,
            ),
          ],
        ),
      ),
    );
  }

  Column infoRowForWorker(String header, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2.h,
        ),
        Text(header,
            style: ThemeValueExtension.subtitle
                .copyWith(fontWeight: FontWeight.bold)),
        Text(
          content,
          style: ThemeValueExtension.subtitle,
        ),
      ],
    );
  }
}
