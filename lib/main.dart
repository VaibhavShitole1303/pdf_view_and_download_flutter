import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:pdf/widgets.dart' as pw;

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  var _progress=0.0;
  final controller=WebViewController()
  ..setJavaScriptMode(JavaScriptMode.disabled)
  ..loadRequest(Uri.parse("https://virtualjc.neosao.online/api/html-pdf/type-one-view?orderNo=3343"));

  // final pdfUrl =  HtmlToPdfConverter().convertToPdf("https://virtualjc.neosao.online/api/html-pdf/type-one-view?orderNo=3343");


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
          final htmlContent = await controller.toString();


          FileDownloader.downloadFile(url: "https://virtualjc.neosao.online/api/html-pdf/type-one-view?orderNo=3343",onDownloadError: (String error){
            print("DownloadError--------------"+error);
          }, onDownloadCompleted:(path) {
            final File file=File(path);
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

  Future<String> downloadPDF(String pdfUrl) async {
    final response = await http.get(Uri.parse(pdfUrl));

    if (response.statusCode == 200) {
      final documentDirectory = (await getExternalStorageDirectory())!.path;
      final file = File('$documentDirectory/mydata.pdf');
      await file.writeAsBytes(response.bodyBytes);
      print('Download successful'+file.path.toString());

      return file.path;
    } else {
      throw Exception('Failed to download PDF');
    }
  }
}





Future<void> _convertToPdf(String _htmlFilePath) async {
  final pdf = pw.Document();

  // Read HTML file content
  final htmlFile = File(_htmlFilePath);
  final htmlContent = await htmlFile.readAsString();

  // Add HTML content to PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(htmlContent),
        );
      },
    ),
  );

  // Get directory for saving PDF file
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/output.pdf');

  // Write PDF content to file
  await file.writeAsBytes(await pdf.save());

  print('PDF saved to-------****************: ${file.path}');
}
void someFunction(
    String ss
    ) {
  // Delay for 5 seconds
  Timer(Duration(seconds: 5), () {
    // Code to execute after the delay
    _convertToPdf(ss);

  });
}