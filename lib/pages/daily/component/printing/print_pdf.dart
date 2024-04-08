import 'dart:typed_data';

import '../../../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/company_details.dart';
import '../model/daily_model.dart';

class AttendancePrint extends StatelessWidget {
  const AttendancePrint(
      {super.key, required this.attendanceList, required this.title});
  final List<DailyModel> attendanceList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Daily Attendance Report".toLabel()),
      body: PdfPreview(
        build: (format) => _generatePdf(format, title),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    int number = 0;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final image = pw.MemoryImage(
    //   File('assets/icons/logo.png').readAsBytesSync(),
    // );
    final image = await imageFromAssetBundle('assets/icons/logo.png');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.portrait,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => [
          printHeader(image),
          pw.SizedBox(height: 10),
          pw.Row(children: [
            pw.SizedBox(
                child: pw.Text(title.toUpperCase(),
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold))),
            pw.Spacer(),
            pw.Text("Total Attendance: ${attendanceList.length}",
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
          ]),
          pw.TableHelper.fromTextArray(
              columnWidths: const {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(8),
                2: pw.FlexColumnWidth(6),
                3: pw.FlexColumnWidth(4),
                4: pw.FlexColumnWidth(4),
                5: pw.FlexColumnWidth(4),
                6: pw.FlexColumnWidth(4),
                7: pw.FlexColumnWidth(2.5),
                8: pw.FlexColumnWidth(5),
              },
              context: context,
              cellStyle: const pw.TextStyle(
                fontSize: pdfFont,
              ),
              headerStyle:
                  pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              data: <List<String>>[
                <String>[
                  '#',
                  'Name',
                  'Department',
                  'Branch',
                  'In Time',
                  'Out Time',
                  'Overtime',
                  'Hour',
                  'Date'
                ],
                ...attendanceList.map(
                  (data) => [
                    (number = number + 1).toString(),
                    "${data.surname}, ${data.middlename} ${data.firstname}",
                    data.department,
                    data.branch,
                    data.inTime,
                    data.outTime!,
                    data.overtime!,
                    data.hours!,
                    data.date
                  ],
                )
              ]),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Row printHeader(pw.ImageProvider image) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.SizedBox(
          height: 35,
          //   width: 10,
          child: pw.Image(
            image,
          ),
        ),
        pw.Center(
          child: pw.Column(
            children: [
              pw.SizedBox(
                  child: pw.Text(Cpy.cpyName,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16))),
              pw.SizedBox(
                  child: pw.Text(Cpy.cpyContact,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9))),
              pw.SizedBox(
                  child: pw.Text(Cpy.cpyGps,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9))),
              pw.Text("Email: ${Cpy.cpyEmail}",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9)),
              pw.Text("Website: ${Cpy.cpyWebsite}",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9)),
              // pw.Text("Branch: $branch",
              //     style: pw.TextStyle(
              //         fontWeight: pw.FontWeight.bold, fontSize: 9)),
              pw.SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
