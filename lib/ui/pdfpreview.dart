import 'dart:io';

import 'package:daily_diary/allwidgets/button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreview extends StatelessWidget {
  const PdfPreview({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Back()),
      body: SfPdfViewer.file(
        File(path),
        scrollDirection: PdfScrollDirection.horizontal,
        onDocumentLoaded: (details) {
          print('Hello pdf onDocumentLoaded ${details.document}');
        },
        onDocumentLoadFailed: (details) {
          print('Hello pdf onDocumentLoadFailed ${details.description}');
        },
      ),
    );
  }
}
