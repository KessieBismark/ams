import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/extension.dart';
import '../model/overtime_model.dart';

class OvertimePrint extends StatelessWidget {
  const OvertimePrint(
      {Key? key, required this.attendanceList, required this.title})
      : super(key: key);
  final List<OvertimeModel> attendanceList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Overtime Report".toLabel()),
      body: PdfPreview(
        build: (format) => _generatePdf(title),
      ),
    );
  }

   Future<Uint8List> _generatePdf(String title) {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Center(
            child: pw.SizedBox(
                child: pw.Text(companyName,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 16))),
          ),
          pw.SizedBox(height: 10),
          pw.Center(child: pw.SizedBox(child: pw.Text(title.toUpperCase()))),
          pw.TableHelper.fromTextArray(
              context: context,
              cellStyle: const pw.TextStyle(
                fontSize: pdfFont,
              ),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              data: <List<String>>[
                <String>[
                  'Staff ID',
                  'Name',
                  'Department',
                  'Branch',
                  'Total Seconds',
                  'Time',
                ],
                ...attendanceList.map(
                  (data) => [
                    data.staffId,
                    "${data.surname}, ${data.middlename} ${data.firstname}",
                    data.department,
                    data.branch,
                    data.totalSeconds!,
                    Utils.isNumeric(data.totalSeconds!)
                        ? Utils.convertTime(int.parse(data.totalSeconds!))
                        : data.totalSeconds!
                  ],
                )
              ]),
        ],
      ),
    );

    return pdf.save();
  }
}
