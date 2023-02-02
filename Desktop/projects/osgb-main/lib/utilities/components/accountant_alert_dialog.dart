import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanoid/async.dart';
import 'package:ntp/ntp.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/models/monthly.dart';
import 'package:osgb/models/payment_action.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/components/row_form_field.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/notification_model.dart';
import '../init/theme/custom_colors.dart';

class AccountantAlertDialog extends ConsumerStatefulWidget {
  final Monthly monthly;
  final String choosedYear;
  final String customerID;
  final String? customerPushToken;
  final Function() setStateCase;

  const AccountantAlertDialog(
      {Key? key,
      required this.monthly,
      required this.customerPushToken,
      required this.choosedYear,
      required this.setStateCase,
      required this.customerID})
      : super(key: key);

  @override
  ConsumerState createState() => _AccountantAlertDialogState();
}

class _AccountantAlertDialogState extends ConsumerState<AccountantAlertDialog> {
  late TextEditingController paymentEditingController;
  late TextEditingController paymentExplainEditingController;
  late Monthly currentMonthly;

  @override
  void initState() {
    super.initState();
    paymentEditingController = TextEditingController();
    paymentExplainEditingController = TextEditingController();
    currentMonthly = widget.monthly;
  }

  @override
  void dispose() {
    super.dispose();
    paymentEditingController.dispose();
    paymentExplainEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.choosedYear} / ${widget.monthly.monthName!}',
          style: ThemeValueExtension.headline6
              .copyWith(fontWeight: FontWeight.bold)),
      insetPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            buildRow("Beklenen:", currentMonthly.amountOfWaiting.toString()),
            SizedBox(
              height: 2.h,
            ),
            buildRow("Ödenen:", currentMonthly.amountOfDone.toString()),
            SizedBox(
              height: 1.h,
            ),
            const Divider(),
            SizedBox(
              height: 1.h,
            ),
            RowFormField(
                headerName: "Ödeme Girin",
                editingController: paymentEditingController,
                inputType: TextInputType.number,
                textAlign: TextAlign.center,
                custValidateFunction: (value) {
                  return null;
                }),
            SizedBox(
              height: 1.h,
            ),
            RowFormField(
                headerName: "Ödeme Açıklama",
                editingController: paymentExplainEditingController,
                inputType: TextInputType.text,
                hintText: "Aylık ödeme gerçekleştirildi...",
                maxLines: 5,
                textAlign: TextAlign.start,
                custValidateFunction: (value) {
                  return null;
                }),
            SizedBox(
              height: 2.h,
            ),
            ref.watch(currentButtonLoadingState) != LoadingStates.loading
                ? paymentButtons()
                : SizedBox(
                    width: 90.w,
                    height: 10.h,
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Row buildRow(String header, String content) {
    return Row(
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
            style: ThemeValueExtension.subtitle
                .copyWith(color: CustomColors.secondaryColor),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Column paymentButtons() {
    return Column(
      children: [
        CustomElevatedButton(
          height: 7.h,
          onPressed: () async {
            var amount = int.parse(paymentEditingController.text);
            currentMonthly.amountOfWaiting =
                currentMonthly.amountOfWaiting! + amount.toDouble();

            var curMonthly = widget.monthly;
            var dateTime = await NTP.now();
            var uniqueID = await nanoid();
            currentMonthly.paymentActionList?.add(PaymentAction(
                    paymentActionID: uniqueID,
                    explain: paymentExplainEditingController.text,
                    amount: -amount.toDouble(),
                    dateTime: dateTime.toUtc().toString().substring(0, 16))
                .toJson());

            ref
                .read(currentAccountantManagerState.notifier)
                .addDebtToMonthly(
                    widget.customerID,
                    int.parse(paymentEditingController.text),
                    curMonthly,
                    widget.choosedYear,
                    ref)
                .then((value) {
              ref.read(currentPushNotificationState.notifier).sendPush(
                  NotificationModel(
                      to: widget.customerPushToken,
                      priority: "high",
                      notification: CustomNotification(
                          title:
                              "Ödeme Güncellemesi(${widget.choosedYear}/${curMonthly.monthName})",
                          body:
                              "${amount.toString()} TL ödemelerinize eklenildi")));
            });
            widget.setStateCase();
            setState(() {});
          },
          inButtonText: "Ödeme Ekle",
          primaryColor: CustomColors.secondaryColorM,
        ),
        SizedBox(
          height: 2.h,
        ),
        CustomElevatedButton(
          height: 7.h,
          onPressed: () async {
            var amount = int.parse(paymentEditingController.text);
            currentMonthly.amountOfWaiting =
                currentMonthly.amountOfWaiting! - amount.toDouble();
            currentMonthly.amountOfDone =
                currentMonthly.amountOfDone! + amount.toDouble();
            var curMonthly = widget.monthly;
            var dateTime = await NTP.now();
            var uniqueID = await nanoid();
            currentMonthly.paymentActionList!.add(PaymentAction(
                    paymentActionID: uniqueID,
                    explain: paymentExplainEditingController.text,
                    amount: amount.toDouble(),
                    dateTime: dateTime.toUtc().toString().substring(0, 16))
                .toJson());

            ref
                .read(currentAccountantManagerState.notifier)
                .addDebtToMonthly(
                    widget.customerID,
                    int.parse(paymentEditingController.text),
                    curMonthly,
                    widget.choosedYear,
                    ref)
                .then((value) {
              ref.read(currentPushNotificationState.notifier).sendPush(
                  NotificationModel(
                      to: widget.customerPushToken,
                      priority: "high",
                      notification: CustomNotification(
                          title:
                              "Ödeme Güncellemesi(${widget.choosedYear}/${curMonthly.monthName})",
                          body: "${amount.toString()} TL ödemeniz eksiltildi")));
            });
            setState(() {});
            widget.setStateCase();
          },
          inButtonText: "Ödeme Eksilt",
          primaryColor: CustomColors.orangeColorM,
        ),
      ],
    );
  }
}
