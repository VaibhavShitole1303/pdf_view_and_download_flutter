import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWid;
import 'package:printing/printing.dart';

class PDFView extends StatefulWidget {
  const PDFView({Key? key}) : super(key: key);

  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  late String _dataFromHtml = ''; // Provide an initial value

  @override
  void initState() {
    super.initState();
    // Fetch data from HTML URL when the widget is initialized
    _fetchDataFromHtmlUrl();
  }

  Future<void> _fetchDataFromHtmlUrl() async {
    try {
      final response = await http.get(Uri.parse('https://virtualjc.neosao.online/api/html-pdf/type-one-view?orderNo=3343'));
      if (response.statusCode == 200) {
        final htmlDocument = htmlParser.parse(response.body);
        final data = htmlDocument.documentElement?.outerHtml; // Fetch entire HTML content
        setState(() {
          _dataFromHtml = data!;
        });
        print('_dataFromHtml: $_dataFromHtml');
      } else {
        throw Exception('Failed to fetch data from HTML URL: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching HTML content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) =>
            _createPdf(format, _dataFromHtml),
      ),
    );
  }
  Future<Uint8List> _createPdf1() async {
    final pdf = await Printing.convertHtml(
      format: PdfPageFormat.a4,
      html: _dataFromHtml,
    );
    return pdf;
  }
  Future<Uint8List> _createPdf(PdfPageFormat format, String data) async {
    final pdf = pdfWid.Document(
      version: PdfVersion.pdf_1_4,
      compress: true,
    );

    final ttf = await rootBundle.load('fonts/Lora-Regular.ttf'); // Load a font file
    final font = pdfWid.Font.ttf(ttf.buffer.asByteData()!); // Convert to PDF font
    final textStyle = pdfWid.TextStyle(font: font, fontSize: 12); // Apply the font to the text style

    pdf.addPage(
      pdfWid.Page(
        pageFormat: format,
        build: (context) {
          return pdfWid.Center(
            child: pdfWid.Text(
              data,
              style: textStyle,
            ),
          );
        },
      ),
    );
    return pdf.save();
  }
}
