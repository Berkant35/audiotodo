import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PDFViewForInspectionDetails extends ConsumerStatefulWidget {
  final String path;
  const PDFViewForInspectionDetails({
    Key? key,
    required this.path
  }) : super(key: key);

  @override
  ConsumerState createState() => _PDFViewForInspectionDetailsState();
}

class _PDFViewForInspectionDetailsState extends ConsumerState<PDFViewForInspectionDetails> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 95.w,
        child: Card(
          elevation: 5,
          child: PdfView(path: widget.path),
        ),
      ),
    );
  }
}
