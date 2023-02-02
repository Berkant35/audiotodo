import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../constants/extension/edge_extension.dart';
import '../init/theme/custom_colors.dart';

class CustomCard extends ConsumerWidget {
  final String? networkImage;
  final String header1;
  final String content1;
  final String header2;
  final String content2;
  final String header3;
  final String content3;
  final IconData? specificIconData;
  final String navigationContentText;
  final VoidCallback onClick;

  const CustomCard({
    Key? key,
    required this.networkImage,
    required this.header1,
    required this.content1,
    required this.header2,
    this.specificIconData,
    required this.content2,
    required this.header3,
    required this.content3,
    required this.navigationContentText,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      shadowColor: CustomColors.customGreyColor,
      borderRadius:
          BorderGeometryExtension.lowToNormalEdge.borderRadiusGeometryValue,
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: buildOfHeight(),
          width: 95.w,
          decoration:
              BoxDecorationExtensions.cardBoxDecoration.boxDecorationValue,
          child: Row(
            children: [
              headerCard(context),
              colCard(),
              actionCard(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded actionCard() {
    return Expanded(
      child: SizedBox(
        child: Center(
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(navigationContentText,
                style: ThemeValueExtension.subtitle2.copyWith(
                    fontWeight: FontWeight.w400,
                    color: CustomColors.secondaryColor)),
          ),
        ),
      ),
    );
  }

  Expanded colCard() {
    return Expanded(
        flex: 10,
        child: SizedBox(
          height: buildOfHeight(),
          child: Column(
            children: [
              buildExpanded(header1, content1),
              buildExpanded(header2, content2),
              buildExpanded(header3, content3),
            ],
          ),
        ));
  }

  Expanded headerCard(BuildContext context) {
    return Expanded(
        flex: 4,
        child: specificIconData != null
            ? Icon(
                specificIconData,
                color: CustomColors.customGreyColor,
                size: 10.h,
              )
            : customCached(context));
  }

  SizedBox customCached(BuildContext context) {
    return SizedBox(
      height: buildOfHeight(),
      child: Padding(
        padding: EdgeInsets.all(context.lowValue),
        child: ClipRRect(
          borderRadius:
              BorderGeometryExtension.lowEdge.borderRadiusGeometryValue,
          child: cachedNetworkImage(),
        ),
      ),
    );
  }

  Widget cachedNetworkImage() {
    return networkImage != null
        ? CachedNetworkImage(
            imageUrl: networkImage!,
            imageBuilder: inCachedImage,
            placeholder: (context, url) => Padding(
              padding: EdgeInsets.all(4.h),
              child: const CircularProgressIndicator.adaptive(),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              color: CustomColors.customGreyColor,
              size: 10.h,
            ),
          )
        : Icon(
            Icons.person,
            color: CustomColors.customGreyColor,
            size: 10.h,
          );
  }

  Widget inCachedImage(context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );

  double buildOfHeight() => 13.7.h;

  Expanded buildExpanded(String title, String content) {
    return Expanded(flex: 2, child: rowInfoOfCards(title, content));
  }

  Padding rowInfoOfCards(String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.25.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 7,
            child: Text(
              title,
              style: ThemeValueExtension.subtitle2
                  .copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip,
            ),
          ),
          Flexible(
              flex: 9,
              child: Text(
                content,
                overflow: TextOverflow.visible,
                style: ThemeValueExtension.subtitle2
                    .copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.end,
              ))
        ],
      ),
    );
  }
}
