// ignore_for_file: avoid_unnecessary_containers, library_private_types_in_public_api
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:sample_flutter_app/main_screen.dart';

import 'package:screen_capture_event/screen_capture_event.dart';

class PdfTest extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<PdfTest> {
  final ScreenCaptureEvent screenCaptureEvent = ScreenCaptureEvent();
  final sampleUrl = 'http://www.africau.edu/images/default/sample.pdf';

  String? pdfFlePath;

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sample.pdf');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(sampleUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
  }

  @override
  void initState() {
    screenCaptureEvent.addScreenRecordListener((recorded) {
      if (recorded) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmptyPage()),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: loadPdf,
                  child: const Text("Load pdf"),
                ),
                if (pdfFlePath != null)
                  Expanded(
                    child: Container(
                      child: PdfView(path: pdfFlePath!),
                    ),
                  )
                else
                  const Text("Pdf is not Loaded"),
              ],
            ),
          ),
        );
      }),
    );
  }
}
