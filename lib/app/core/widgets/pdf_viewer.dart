import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:get/get.dart';

class PDFViewerPage extends StatelessWidget {
  const PDFViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String url = Get.arguments['url'];
    final String title = Get.arguments['title'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SfPdfViewer.network(url),
    );
  }
}
