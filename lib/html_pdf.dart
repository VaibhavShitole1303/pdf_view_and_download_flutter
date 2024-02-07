import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_html/flutter_html.dart';


class HtmlToPdfConverter1 extends StatefulWidget {
  final String htmlUrl;

  const HtmlToPdfConverter1({required this.htmlUrl});

  @override
  _HtmlToPdfConverterState createState() => _HtmlToPdfConverterState();
}

class _HtmlToPdfConverterState extends State<HtmlToPdfConverter1> {
  late String _htmlContent;

  @override
  void initState() {
    super.initState();
    _fetchHtmlContent();
  }

  Future<void> _fetchHtmlContent() async {
    final response = await http.get(Uri.parse(widget.htmlUrl));
    if (response.statusCode == 200) {
      _htmlContent = response.body;
    } else {
      throw Exception('Failed to fetch HTML content: ${response.statusCode}');
    }
  }

  Future<void> _convertToPdf() async {
    // Create PDF document
    final pdf = pw.Document();


    final pw.ThemeData theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('assets/OpenSans-Regular.ttf')),
      bold: pw.Font.ttf(await rootBundle.load('assets/OpenSans-Bold.ttf')),
    );

    pdf.addPage(
      pw.Page(
        theme: theme,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello, World!', style: pw.TextStyle(fontSize: 24)),
          );
        },
      ),
    );

    // Get directory for saving PDF file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/output.pdf');

    // Write PDF content to file
    await file.writeAsBytes(await pdf.save());

    print('PDF saved to: ${file.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _htmlContent.isNotEmpty ? _convertToPdf : null,
            child: Text('Convert to PDF'),
          ),
        ],
      ),
    );
  }
}