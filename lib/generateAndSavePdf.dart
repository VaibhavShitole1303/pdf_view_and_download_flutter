import 'dart:io';
import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart';


Future<void> generateAndSavePdf() async {
  // Create a new PDF document
  final PdfDocument document = PdfDocument();

  // Add a page to the document
  final PdfPage page = document.pages.add();

  // Create a PDF text element
  final PdfTextElement textElement = PdfTextElement(
      text: 'Hello, World!',
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)));

  // Layout and draw the text element on the page
  textElement.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width,
          page.getClientSize().height),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));

  // Save the document to a file
  final File file = File('/path/to/your/directory/fileName.pdf');
  await file.writeAsBytes(document.save() as List<int>);

  // Close the document
  document.dispose();

  print('PDF saved to: ${file.path}');
}


