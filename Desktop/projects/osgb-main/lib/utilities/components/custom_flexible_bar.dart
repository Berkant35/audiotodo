import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/extension/context_extensions.dart';
import '../constants/extension/edge_extension.dart';
import '../init/navigation/navigation_service.dart';
import '../init/theme/custom_colors.dart';

class CustomFlexibleBar extends StatelessWidget {
  final String appBarTitle;
  final String? headerPhoto;
  final String? firstInfo;
  final String? firstHeader;
  final String? secondInfo;
  final String? secondHeader;
  final String? thirdInfo;
  final Roles role;
  final String? thirdHeader;
  final String? fourHeader;
  final String? fiveHeader;
  final String? fourInfo;
  final String? fiveInfo;
  final VoidCallback? goBackFunction;

  const CustomFlexibleBar({
    Key? key,
    required this.appBarTitle,
    required this.role,
    this.headerPhoto,
    this.firstInfo,
    this.firstHeader,
    this.secondInfo,
    this.secondHeader,
    this.thirdInfo,
    this.goBackFunction,
    this.thirdHeader,
    this.fourInfo,
    this.fourHeader,
    this.fiveHeader,
    this.fiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(fourInfo.toString()+'<-four info');
    return Container(
      height: 30.h,
      color: CustomColors.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(
            flex: 2,
          ),
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  IconButton(
                      onPressed: goBackFunction ??
                          () => NavigationService.instance.navigatePopUp(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  Text(
                    appBarTitle,
                    textAlign: TextAlign.center,
                    style: ThemeValueExtension.subtitle
                        .copyWith(color: Colors.white),
                  )
                ],
              )
          ),
          Expanded(
              flex: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.25, color: CustomColors.secondaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(
                              EdgeExtension.normalEdge.edgeValue))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(
                              EdgeExtension.normalEdge.edgeValue
                            )
                        ),
                        child: headerPhoto != null
                            ? CachedNetworkImage(
                                imageUrl: headerPhoto!,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                role == Roles.customer
                                    ? Icons.business_center_sharp
                                    : Icons.person,
                                color: CustomColors.secondaryColor,
                                size: 50,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60.w,
                    height: 100.h,
                    child: fourInfo != null ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        rowInfo(
                            firstHeader ?? "Belirtilmemiş",
                            firstInfo ?? "Belirtilmemiş"
                        ),

                        rowInfo(
                          secondHeader ?? "Belirtilmemiş",
                          secondInfo ?? "Belirtilmemiş"
                        ),

                        rowInfo(
                          thirdHeader ?? "Belirtilmemiş",
                          thirdInfo ?? "Belirtilmemiş"
                        ),
                        fourInfo != null ?
                        columnInfo(
                            fourHeader ?? "Belirtilmemiş",
                            fourInfo ?? "Belirtilmemiş"
                        ) : const SizedBox(),
                        fiveHeader != null ? rowInfo(
                            fiveHeader ?? "Belirtilmemiş",
                            fiveInfo ?? "Belirtilmemiş"
                        ) : const SizedBox(),
                      ],
                    ) : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        rowInfo(
                            firstHeader ?? "Belirtilmemiş",
                            firstInfo ?? "Belirtilmemiş"
                        ),

                        rowInfo(
                            secondHeader ?? "Belirtilmemiş",
                            secondInfo ?? "Belirtilmemiş"
                        ),

                        rowInfo(
                            thirdHeader ?? "Belirtilmemiş",
                            thirdInfo ?? "Belirtilmemiş"
                        ),
                      ],
                    ) ,
                  )
                ],
              )),
        ],
      ),
    );
  }

  Row rowInfo(String header, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            "$header:",
            style: ThemeValueExtension.subtitle2
                .copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            content,
            textAlign: TextAlign.end,
            style: ThemeValueExtension.subtitle2
                .copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white
            ),
          ),
        ),
      ],
    );
  }
  Column columnInfo(String header, String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$header:",
          style: ThemeValueExtension.subtitle2
              .copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white
          ),
        ),
        Text(
          content,
          textAlign: TextAlign.end,
          style: ThemeValueExtension.subtitle2
              .copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white
          ),
        ),
      ],
    );
  }

}
