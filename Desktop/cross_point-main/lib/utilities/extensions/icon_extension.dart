import 'package:flutter/material.dart';

enum IconImages { pdf, doc, m4a, mov, png, jpg, jpeg, mp4 }

extension IconImageExtension on IconImages {
  Icon get whicIcon {
    switch (this) {
      case IconImages.pdf:
        return const Icon(Icons.picture_as_pdf);
      case IconImages.doc:
        return const Icon(Icons.file_copy_sharp);

      default:
        throw Exception('NOT VALİD FONT SİZE');
    }
  }
}
