import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:timestory_back4app/model/TimeSheetDataModel.dart';
import 'package:timestory_back4app/util/Utilities.dart';

Future<Uint8List> exportToPDF(List<TimeSheetDataModel> tsModelList, String selectedMonth) async {
  final doc = pw.Document();
  DateTime reportDate = formatDate(DateTime.now());
  String showMonth = selectedMonth == "" ? 'Till Date' : selectedMonth;
  var data = await rootBundle.load("fonts/OpenSans-Regular.ttf");

  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(70.0),
      build: (context) =>
          pw.Center(
              child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Container(
                    color: PdfColor.fromHex('#33FCFF'),
                    width: 500,
                    height: 20,
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(tsModelList.first.projectDM.userDM.username, style: pw.TextStyle(font: pw.Font.ttf(data))),
                      pw.Text("Report Date: $reportDate", style: pw.TextStyle(font: pw.Font.ttf(data))),
                    ])),
                pw.Text("____________________________________________________________________________________",
                    style: pw.TextStyle(font: pw.Font.ttf(data))),
                pw.Text("Project:", style: pw.TextStyle(font: pw.Font.ttf(data))),
                pw.Text("Timesheet: $showMonth",
                    style: pw.TextStyle(
                      font: pw.Font.ttf(data),
                    )),
                pw.Text("Total number of Hours:", style: pw.TextStyle(font: pw.Font.ttf(data))),
                pw.Text("____________________________________________________________________________________",
                    style: pw.TextStyle(font: pw.Font.ttf(data))),
                pw.Padding(padding: const pw.EdgeInsets.all(10.0), child: pw.Text("", style: pw.TextStyle(font: pw.Font.ttf(data)))),
                pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {0: const pw.FixedColumnWidth(70), 1: const pw.FixedColumnWidth(50), 2: const pw.FlexColumnWidth()},
                    defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
                    children: [
                      pw.TableRow(children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(4.0), child: pw.Text("Date", style: pw.TextStyle(font: pw.Font.ttf(data)))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0), child: pw.Text("Total Hours", style: pw.TextStyle(font: pw.Font.ttf(data)))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0), child: pw.Text("Work Description", style: pw.TextStyle(font: pw.Font.ttf(data)))),
                      ])
                    ]),
                pw.ListView.builder(
                    itemCount: tsModelList.length,
                    itemBuilder: (context, index) {
                      return pw.Table(
                          border: pw.TableBorder.all(),
                          columnWidths: {0: const pw.FixedColumnWidth(70), 1: const pw.FixedColumnWidth(50), 2: const pw.FlexColumnWidth()},
                          defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
                          children: [
                            pw.TableRow(children: [
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(4.0),
                                  child: pw.Text(tsModelList[index].selectedDateStr, style: pw.TextStyle(font: pw.Font.ttf(data)))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(4.0),
                                  child: pw.Text(tsModelList[index].numberOfHrs.toString(), style: pw.TextStyle(font: pw.Font.ttf(data)))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(4.0),
                                  child: pw.Text(tsModelList[index].workDescription, style: pw.TextStyle(font: pw.Font.ttf(data)))),
                            ])
                          ]);
                    })
              ]))));

  final bytes = await doc.save();
  return bytes;
}
