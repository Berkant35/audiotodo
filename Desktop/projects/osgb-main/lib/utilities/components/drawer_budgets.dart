import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:osgb/models/monthly.dart';
import 'package:osgb/models/yearly.dart';
import 'package:osgb/utilities/components/custom_elevated_button.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/constants/extension/edge_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../line/viewmodel/global_providers.dart';
import '../constants/app/enums.dart';
import '../init/theme/custom_colors.dart';

class DrawerBudgets extends ConsumerStatefulWidget {
  const DrawerBudgets({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DrawerBudgetsState();
}

class _DrawerBudgetsState extends ConsumerState<DrawerBudgets> {
  var expectedPayMoney = 0.0;
  var paidMoney = 0.0;

  @override
  void initState() {
    super.initState();
    calculateTotalPayments();
  }

  void calculateTotalPayments() {
    if (ref.read(currentRole) == Roles.customer) {
      expectedPayMoney = 0.0;
      paidMoney = 0.0;
      ref
          .read(currentAccountantManagerState.notifier)
          .getAndSetCurrentPayment(
              ref.read(currentBaseModelState).customer!.rootUserID)
          .then((value) {
        for (var perYear in value!.paymentYearList!) {
          var year = Yearly.fromJson(perYear);
          for (var perMonth in year.monthlyList!) {
            var month = Monthly.fromJson(perMonth);
            paidMoney += month.amountOfDone!;
            expectedPayMoney += month.amountOfWaiting!;
          }
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.read(currentRole) == Roles.customer &&
            ref.read(currentButtonLoadingState) != LoadingStates.loading
        ? SizedBox(
            height: 13.4.h,
            child: Padding(
              padding: EdgeInsets.only(right: 2.w,top: 1.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  perContainer("$expectedPayMoney TL", "ÖDEME YAP",true),
                  perContainer("$paidMoney TL", "İNCELE",false),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Container perContainer(String header, String buttonText,bool isGreenBackground) => Container(
        width: 100.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: CustomColors.customGreyColor.withOpacity(0.15),
          borderRadius: BorderRadius.all(
              Radius.circular(EdgeExtension.lowEdge.edgeValue)),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 1.5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header,
                style: ThemeValueExtension.subtitle.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isGreenBackground ? CustomColors.primaryColor : CustomColors.primaryColor
                ),
              ),
              CustomElevatedButton(
                primaryColor: isGreenBackground ? CustomColors.pinkColorM : CustomColors.secondaryColorM,
                width: 30.w,
                height: 4.5.h,
                onPressed: () {},
                borderRadius: EdgeExtension.lowEdge.edgeValue,
                inButtonText: "",
                inButtonWidget: Text(
                  buttonText,
                  style: ThemeValueExtension.subtitle4.copyWith(

                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      );
}

/* Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Text("Beklenen Toplam Ödeme:",
                    style: ThemeValueExtension.subtitle2
                        .copyWith(fontWeight: FontWeight.w600)),
                SizedBox(
                  width: 0.5.w,
                ),
                Text(expectedPayMoney.toString(),
                    style: ThemeValueExtension.subtitle2.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CustomColors.orangeColor,
                    )),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                          EdgeExtension.lowEdge.edgeValue
                      ))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Ödenen Toplam Miktar:",
                          style: ThemeValueExtension.subtitle2
                              .copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 0.5.w,
                      ),
                      Text(paidMoney.toString(),
                          style: ThemeValueExtension.subtitle2.copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomColors.secondaryColor,
                          )),
                    ],
                  ),
                ),*/
