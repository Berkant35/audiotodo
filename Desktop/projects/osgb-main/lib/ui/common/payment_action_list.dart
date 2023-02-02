import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/models/monthly.dart';
import 'package:osgb/models/payment_action.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/constants/extension/edge_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utilities/init/theme/custom_colors.dart';

class PaymentActionList extends ConsumerStatefulWidget {
  final Monthly monthly;

  const PaymentActionList({Key? key, required this.monthly}) : super(key: key);

  @override
  ConsumerState createState() => _PaymentActionListState();
}

class _PaymentActionListState extends ConsumerState<PaymentActionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ay Dökümü(${widget.monthly.monthName})",
          style: ThemeValueExtension.subtitle,
        ),
      ),
      body: widget.monthly.paymentActionList!.isNotEmpty
          ? Padding(
              padding: seperatePadding(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Döküm Liste",
                      style: ThemeValueExtension.headline6
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.monthly.paymentActionList!.length,
                        itemBuilder: (context, index) {
                          var paymentAction = PaymentAction.fromJson(
                              widget.monthly.paymentActionList![index]);

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 1.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(
                                      EdgeExtension.lowEdge.edgeValue)),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        blurStyle: BlurStyle.outer)
                                  ]),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(
                                            "İşlem Açıklama",
                                            style: ThemeValueExtension.subtitle.copyWith(
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(paymentAction.explain.toString(),
                                              style:
                                                  ThemeValueExtension.subtitle),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(paymentAction.dateTime.toString(),
                                              style: ThemeValueExtension.subtitle3
                                                  .copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: CustomColors
                                                          .customGreyColor
                                                          .withOpacity(0.9))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        paymentAction.amount
                                                .toString()
                                                .contains("-")
                                            ? paymentAction.amount.toString()
                                            : "+${paymentAction.amount}",
                                        style: ThemeValueExtension.subtitle
                                            .copyWith(
                                                color: paymentAction.amount
                                                        .toString()
                                                        .contains("-")
                                                    ? CustomColors.orangeColor
                                                    : CustomColors
                                                        .secondaryColor),
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    SizedBox(height: 20.h,)
                  ],
                ),
              ),
            )
          : Center(
              child: Text(
                "Henüz bir hareket olmadı",
                style: ThemeValueExtension.subtitle,
              ),
            ),
    );
  }
}
