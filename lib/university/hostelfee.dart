import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mini_project/appbar.dart';
import 'package:mini_project/reusable/alert.dart';
import 'package:mini_project/reusable/showDialog.dart';

import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../model/user_model.dart';

class HostelBill extends StatefulWidget {
  final String object;
  const HostelBill({Key? key, required this.object}) : super(key: key);

  @override
  State<HostelBill> createState() => _HostelBillState();
}

class _HostelBillState extends State<HostelBill> {
  int hostelfee = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
      extractedData.forEach((studentId, studentData) async {
        if (hostelfee != 0) {
          if (studentData.containsKey('Hostelfee') &&
              studentData['role'] == 'Inmate') {
            studentData['Hostelfee'] += hostelfee;
          } else {
            studentData['Hostelfee'] = hostelfee;
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

        if (updateResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hostel fee updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wroung ,try again')),
          );
        }
      });
    } catch (error) {
      print(error);
      showAlertDialog(
          context, 'something went wroung', 'Check your connectivity', 'error');
    }
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    int hostelfee,
  ) async {
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
                  "Hostel Bill",
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
                pw.Text("Total Amount: $hostelfee",
                    style: pw.TextStyle(font: font, fontSize: 20)),
              ]);
        },
      ),
    );

    return pdf.save();
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
                'Hostel Bill Generator',
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
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Hostel fee :",
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
                                  hostelfee = int.tryParse(value) ?? 0;
                                });
                              },
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
                child: isLoading
                    ? const SpinKitCubeGrid(
                        color: Color(0xFF8B5FBF),
                        size: 50.0,
                      ) // Show loading indicator
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.money),
                        onPressed: () async {
                          if (hostelfee != 0) {
                            bool? confirmed = await showConfirmationDialog(
                              context,
                              'Confirmation',
                              'Do you want to save and generate the hostel bill?',
                            );
                            if (confirmed == true) {
                              setState(() {
                                isLoading = true;
                              });

                              update();
                              final pdfBytes = await _generatePdf(
                                  PdfPageFormat.a4, hostelfee);
                              await Printing.layoutPdf(
                                onLayout: (format) async => pdfBytes,
                              );
                              setState(() {
                                isLoading = false;
                              });
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
