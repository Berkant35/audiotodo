import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowPhoto extends StatelessWidget {
  final String photoURL;

  const ShowPhoto({Key? key, required this.photoURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,elevation: 0),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(photoURL),
      ),
    );
  }
}
