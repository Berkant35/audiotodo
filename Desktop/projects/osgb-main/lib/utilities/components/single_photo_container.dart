import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osgb/utilities/constants/extension/context_extensions.dart';
import 'package:osgb/utilities/constants/extension/edge_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../init/theme/custom_colors.dart';

class SinglePhotoArea extends StatefulWidget {
  final String? photoUrl;
  final bool? showInArea;
  final Function(File value)? onSaved;

  const SinglePhotoArea(
      {Key? key, this.photoUrl, this.onSaved, required this.showInArea})
      : super(key: key);

  @override
  State<SinglePhotoArea> createState() => _SinglePhotoAreaState();
}

class _SinglePhotoAreaState extends State<SinglePhotoArea> {
  final _picker = ImagePicker();
  CroppedFile? _croppedFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 30.h,
      decoration: BoxDecoration(
          color: CustomColors.customCardBackgroundColor,
          border: Border.all(

              color: CustomColors.secondaryColor),
          borderRadius: BorderRadius.all(
              Radius.circular(EdgeExtension.lowEdge.edgeValue))),
      child: Center(
        child: widget.showInArea!
            ? _croppedFile == null && widget.photoUrl == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.photo_camera),
                          onPressed: () async {
                            _showShetBottom(context);
                          }),
                      Text(
                        "Fotoğraf eklemek için tıkla",
                        style: ThemeValueExtension.subtitle3,
                      )
                    ],
                  )
                : image()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: const Icon(Icons.photo_camera),
                      onPressed: () async {
                        _showShetBottom(context);
                      }),
                  Text(
                    "Fotoğraf eklemek için tıkla",
                    style: ThemeValueExtension.subtitle3,
                  )
                ],
              ),
      ),
    );
  }

  Widget image() {
    return InkWell(
      onTap: () {
        _showShetBottom(context);
      },
      child: ClipRRect(
        borderRadius:
            BorderRadius.all(Radius.circular(EdgeExtension.lowEdge.edgeValue)),
        child: _croppedFile != null
            ? Image.file(
                File(_croppedFile!.path),
                width: 90.w,
                height: 70.h,
                fit: BoxFit.contain,
              )
            : CachedNetworkImage(
                imageUrl: widget.photoUrl!,
                width: 90.w,
                height: 70.h,
                fit: BoxFit.contain,
              ),
      ),
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

  Future<void> kameradanCek() async {
    var photo = await _picker.pickImage(
        imageQuality: 50,
        source: ImageSource.camera,
        maxHeight: 1800,
        maxWidth: 1800);
    if (photo != null) {
      var croppedYeniResim = await ImageCropper().cropImage(
          sourcePath: photo.path,
          aspectRatio: CropAspectRatio(ratioX: 90.w, ratioY: 70.h),
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: "Kırp",
                toolbarColor: CustomColors.primaryColor,
                toolbarWidgetColor: Colors.white,
                lockAspectRatio: false),
            IOSUiSettings(
              title: "Kırp",
            )
          ]);
      _croppedFile = croppedYeniResim;
      widget.onSaved!(File(_croppedFile!.path));
      setState(() {});
    }
  }

  Future<void> galeridenSec() async {
    var photo = await _picker.pickImage(
        imageQuality: 50,
        source: ImageSource.gallery,
        maxHeight: 1800,
        maxWidth: 1800);
    if (photo != null) {
      var croppedYeniResim = await ImageCropper().cropImage(
          sourcePath: photo.path,
          aspectRatio: CropAspectRatio(ratioX: 90.w, ratioY: 25.h),
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: "Kırp",
                toolbarColor: CustomColors.primaryColor,
                toolbarWidgetColor: Colors.white,
                lockAspectRatio: false),
            IOSUiSettings(
              title: "Kırp",
            )
          ]);
      _croppedFile = croppedYeniResim;
      widget.onSaved!(File(_croppedFile!.path));
      setState(() {});
    }
  }

  _showShetBottom(BuildContext showContext) {
    if (Platform.isAndroid) {
      showModalBottomSheet(
          context: showContext,
          builder: (context) {
            return SizedBox(
              height: 30.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: Text(
                      "Kameradan Çek",
                      style: ThemeValueExtension.subtitle,
                    ),
                    onTap: kameradanCek,
                  ),
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text(
                      "Galeriden Seç",
                      style: ThemeValueExtension.subtitle,
                    ),
                    onTap: galeridenSec,
                  ),
                ],
              ),
            );
          });
    } else {
      showCupertinoModalPopup(
        context: showContext,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: kameradanCek,
              child: Text(
                "Kameradan çek",
                style: ThemeValueExtension.subtitle2,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: galeridenSec,
              child: Text(
                "Galeriden seç",
                style: ThemeValueExtension.subtitle2,
              ),
            )
          ],
        ),
      );
    }
  }
}
