import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

import 'package:flutter/material.dart';
import 'package:pdf_view/pdf_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:pdf/widgets.dart' as pw;

// import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';


void main() async {
  // Initialize flutter_downloader
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // Set to false in production
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "title"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _dataFromHtml = ''; // Provide an initial value

  var _progress=0.0;
  final controller=WebViewController()
  ..setJavaScriptMode(JavaScriptMode.disabled)
  ..loadRequest(Uri.parse("https://virtualjc.neosao.online/api/html-pdf/type-one-view?orderNo=3343"));

  // final pdfUrl =  HtmlToPdfConverter().convertToPdf("https://virtualjc.neosao.online/api/html-pdf/type-one-view?orderNo=3343");

  Future<void> _fetchDataFromHtmlUrl() async {
    try {
      final response = await http.get(Uri.parse('https://virtualjc.neosao.online/api/html-pdf/type-one-view?orderNo=3343'));
      if (response.statusCode == 200) {
        final htmlDocument = htmlParser.parse(response.body);
        final data = htmlDocument.documentElement?.innerHtml; // Fetch entire HTML content
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: WebViewWidget(controller: controller,),

      ),
      bottomNavigationBar:   Container(
        height: 20,
        width: _progress*4,
        color: Colors.red,
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _fetchDataFromHtmlUrl();

          // Timer(Duration(seconds: 10), () async {
          //   // Code to execute after the delay
          //   // _convertToPdf(ss);
          //   final String apiKey = 'vaibhavshitole1303@gmail.com_5g3S3Xexxsz8A48juSq3xI71E01738E8c236xIJtt5e968007p6HD7PmzUJ9XDV0';
          //   final String htmlContent = _dataFromHtml.toString(); // Your HTML content here
          //   print('PDF htmlContent to^^^^^^^^^%%%%%%%%%%: ${htmlContent}');
          //
          //   try {
          //     final response = await http.post(
          //       Uri.parse('https://api.pdf.co/v1/pdf/convert/from/html'),
          //       headers: {
          //         'x-api-key': apiKey,
          //         HttpHeaders.contentTypeHeader: 'application/json',
          //       },
          //       body: jsonEncode({'html': htmlContent}),
          //     );
          //
          //
          //     if (response.statusCode == 200) {
          //       // Save or process the PDF content
          //       // Save the PDF to device
          //
          //       final pdfBytes = response.bodyBytes;
          //       final directory = await getExternalStorageDirectory();
          //       final file = File('${directory?.path}/output.pdf');
          //       await file.writeAsBytes(pdfBytes);
          //       print('PDF saved to^^^^^^^^^%%%%%%%%%%: ${file.path}');
          //
          //     } else {
          //       print('Failed to convert HTML to PDF: ${response.body}');
          //     }
          //   } catch (e) {
          //     print('Error converting HTML to PDF--: $e');
          //   }
          // });


          _fetchDataFromHtmlUrl();
          _convertToPdf();
          // convert(_dataFromHtml,"demoee");
          FileDownloader.downloadFile(url: "https://virtualjc.neosao.online/api/html-pdf/type-one-view?orderNo=3343",onDownloadError: (String error){
            print("DownloadError--------------"+error);
          }, onDownloadCompleted:(path) async {
            // final File file=File(path);
            final directory = await getApplicationDocumentsDirectory();
            final file = File('${directory.path}/output.html');
            someFunction(file.toString());
            print("DownloadCompleted---------------------"+file.toString());
          },
          onProgress: (fileName, progress) {
            setState(() {
              _progress=progress;
            });
          },);
    },
    child: Icon(Icons.download),
    )
    ) ;// This trailing comma makes auto-formatting nicer for build methods.

  }

  Future<void> _convertToPdf() async {
    final pdf = pw.Document();
    // Add HTML content to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(_dataFromHtml),
          );
        },
      ),
    );

    // Get directory for saving PDF file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/output.pdf');


    // Write PDF content to file
    await file.writeAsBytes(await pdf.save());

    print('PDF saved to-------****************############: ${file.path}');
  }
  void someFunction(
      String ss
      ) {
    // Delay for 5 seconds
    Timer(Duration(seconds: 10), () {
      // Code to execute after the delay
      // _convertToPdf(ss);

    });
  }
  convert(String cfData, String name) async {

    // Name is File Name that you want to give the file
    var targetPath = await _localPath;
    var targetFileName = name;

    // var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
    //     cfData, targetPath!, targetFileName);
    // print(generatedPdfFile);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(generatedPdfFile.toString()),
    // ));
  }

  Future<String?> get _localPath async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationSupportDirectory();
      } else {   // if platform is android
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      print("Can-not get download folder path");
    }
    return directory?.path;
  }


}

