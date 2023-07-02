import 'package:mini_project/model/user_model.dart';
import 'package:mini_project/reusable/alert.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:provider/provider.dart';

import 'appbar.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessBill extends StatefulWidget {
  final String object;
  const MessBill({Key? key, required this.object}) : super(key: key);

  @override
  State<MessBill> createState() => _MessBillState();
}

class _MessBillState extends State<MessBill> {
  int establishmentAmount = 0;
  int effectiveDays = 0;
  int perDayAmount = 0;
  int total = 0;
  bool success = false;
  @override
  void initState() {
    super.initState();

    _calculateTotal();
  }

  Future<void> update() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final response = await http.get(
        Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final currentPerson = extractedData[widget.object];
      extractedData.forEach((studentId, studentData) async {
        if (studentData['Hostel'] == currentPerson['Hostel']) {
          if (studentData.containsKey('MessFee')) {
            studentData['MessFee'] += total;
          } else {
            studentData['MessFee'] = total;
          }
        } else {
          return;
        }
        final updateResponse = await http.put(
          Uri.parse(
              "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/$studentId.json?auth=${authProvider.authToken}"),
          headers: {
            'accept': 'application/json',
          },
          body: json.encode(studentData),
        );
        success = true;
        if (updateResponse.statusCode == 200) {
          success = true;
        } else {
          success = false;
        }
      });
      if (success == true) {
        showAlertDialog(
            context, 'success', 'fee updated successfully', 'success');
      } else {
        showAlertDialog(
            context, 'Error', 'Something went wroung ,try again', 'error');
      }
    } catch (error) {
      showAlertDialog(
          context, 'something went wroung', 'Check your connectivity', 'error');
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, int establishmentAmount,
      int effectiveDays, int perDayAmount) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final image = await imageFromAssetBundle('assets/images/logo.png');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Image(image, width: 150, height: 150),
                    ]),
                pw.Center(
                    child: pw.Text(
                  "Mess Bill",
                  style: pw.TextStyle(font: font, fontSize: 55),
                  textAlign: pw.TextAlign.center,
                )),
                pw.Center(
                    child: pw.Text(
                  "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}, ${DateFormat('hh:mm:ss a').format(DateTime.now())}",
                  style: pw.TextStyle(font: font, fontSize: 20),
                  textAlign: pw.TextAlign.center,
                )),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 60)),
                pw.Text("Establishment Amount: $establishmentAmount",
                    style: pw.TextStyle(font: font, fontSize: 20)),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
                pw.Text("Effective Days : $effectiveDays",
                    style: pw.TextStyle(font: font, fontSize: 20)),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
                pw.Text("Per Day Amount: $perDayAmount",
                    style: pw.TextStyle(font: font, fontSize: 20)),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 40)),
                pw.Text("Total Amount: $total",
                    style: pw.TextStyle(font: font, fontSize: 20)),
              ]);
        },
      ),
    );

    return pdf.save();
  }

  void _calculateTotal() {
    setState(() {
      total = establishmentAmount + (effectiveDays * perDayAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const MyAppBar(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 70),
              child: Text(
                'Mess Bill Generator',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 35, color: Color(0xFF8B5FBF)),
              ),
            ),
            Container(
              width: 350,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Establishment Amount:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  establishmentAmount =
                                      int.tryParse(value) ?? 0;
                                  _calculateTotal();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Effective Days :",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  effectiveDays = int.tryParse(value) ?? 0;
                                  _calculateTotal();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Per Day Amount:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  perDayAmount = int.tryParse(value) ?? 0;
                                  _calculateTotal();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Total : $total",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.money),
                  onPressed: () async {
                    if (total != 0) {
                      bool? confirmed = await showConfirmationDialog(
                        context,
                        'Confirmation',
                        'Do you want to save and generate the mess bill?',
                      );
                      if (confirmed == true) {
                        update();
                        final pdfBytes = await _generatePdf(PdfPageFormat.a4,
                            establishmentAmount, effectiveDays, perDayAmount);
                        await Printing.layoutPdf(
                          onLayout: (format) async => pdfBytes,
                        );
                      }
                    } else {
                      showAlertDialog(context, 'Try Again',
                          'Something went wroung', 'error');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    fixedSize: const Size(220, 50),
                    backgroundColor: const Color(0xFF8B5FBF),
                  ),
                  label: const Text('Confirm and Generate Mess Bill'),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
