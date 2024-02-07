import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class ApiService{
  static final String PDF_URl="https://virtualjc.neosao.online/api/html-pdf/type-one-view?orderNo=3343";

 static Future<String> loadPdf()async{
    var response= await http.get(PDF_URl as Uri);
    var dir=await getTemporaryDirectory();
    File file=new File(dir.path+"/data.pdf");
    await file.writeAsBytes(response.bodyBytes,flush: true);
    return file.path;
  }
}