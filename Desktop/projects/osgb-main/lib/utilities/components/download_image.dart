import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:osgb/line/viewmodel/global_providers.dart';
import 'package:osgb/utilities/components/seperate_padding.dart';
import 'package:osgb/utilities/constants/app/enums.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/extension/context_extensions.dart';
import '../init/theme/custom_colors.dart';

class DownloadImage extends ConsumerStatefulWidget {
  final String imageLink;
  final String fileName;

  const DownloadImage({
    Key? key,
    required this.imageLink,
    required this.fileName,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DownloadImageState();
}

class _DownloadImageState extends ConsumerState<DownloadImage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: seperatePadding(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "QR",
                style: ThemeValueExtension.subtitle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              ref.watch(currentLoadingState) != LoadingStates.loading
                  ? IconButton(
                      onPressed: () async {
                        ref
                            .read(currentLoadingState.notifier)
                            .changeState(LoadingStates.loading);
                        var response = await Dio().get(
                            widget.imageLink,
                            options: Options(responseType: ResponseType.bytes));
                        final result = await ImageGallerySaver.saveImage(
                            Uint8List.fromList(response.data),
                            quality: 60,
                            name: widget.fileName);
                        if(result['isSuccess'].toString() == 'true'){
                          Fluttertoast.showToast(msg: "Fotoğraflarıma indirildi!");
                        }else{
                          Fluttertoast.showToast(msg: "Bir şeyler ters gitti");
                        }

                        ref
                            .read(currentLoadingState.notifier)
                            .changeState(LoadingStates.loaded);
                      },
                      icon: Icon(
                        Icons.download,
                        size: 3.25.h,
                        color: Colors.black,
                      ))
                  : const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          CachedNetworkImage(
            imageUrl: widget.imageLink,
            fit: BoxFit.fill,
            imageBuilder: inCachedImage,
            placeholder: (context, url) =>
                const CircularProgressIndicator.adaptive(),
            errorWidget: (context, url, error) => const Icon(
              Icons.person,
              color: CustomColors.customGreyColor,
              size: 70,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          TextButton(
              onPressed: () => launchUrl(Uri.parse(widget.imageLink),
                  mode: LaunchMode.externalApplication),
              child: Text(
                "QR Link",
                style: ThemeValueExtension.subtitle.copyWith(
                    color: CustomColors.secondaryColor,
                    fontWeight: FontWeight.w500),
              )
          ),
        ],
      ),
    );
  }

  Widget inCachedImage(context, imageProvider) => Container(
        height: 30.h,
        width: 90.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      );
}
