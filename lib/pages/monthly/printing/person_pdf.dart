import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../services/constants/constant.dart';
import '../../../services/utils/company_details.dart';
import '../../../services/widgets/extension.dart';
import '../model/mreport_model.dart';

class PersonPrint extends StatelessWidget {
  const PersonPrint(
      {super.key, required this.attendanceList, required this.title});
  final List<MReportModel> attendanceList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Attendance Report".toLabel()),
      body: PdfPreview(
        build: (format) =>  _generatePdf(format, title),
      ),
    );
  }

  Future<Uint8List>  _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final image = pw.MemoryImage(
      File('assets/icons/logo.png').readAsBytesSync(),
    );
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          // pw.Center(
          //   child: pw.SizedBox(
          //       child: pw.Text(companyName,
          //           style: pw.TextStyle(
          //               fontWeight: pw.FontWeight.bold, fontSize: 16))),
          // ),
          printHeader(image),
          pw.SizedBox(height: 10),
          pw.Center(child: pw.SizedBox(child: pw.Text(title.toUpperCase()))),
          pw.TableHelper.fromTextArray(
              context: context,
              cellStyle: const pw.TextStyle(
                fontSize: pdfFont,
              ),
              headerStyle: pw.TextStyle(
                  fontSize: pdfFontHeader, fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              data: <List<String>>[
                <String>[
                  'Staff ID',
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
                    data.staffId,
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
        pw.Align(
          alignment: pw.Alignment.topLeft,
          child: pw.SizedBox(
            height: 35,
            child: pw.Image(
              image,
            ),
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
