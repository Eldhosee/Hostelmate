import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mini_project/appbar.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/user_model.dart';

class QRCodeGenerator extends StatefulWidget {
  final String object;
  const QRCodeGenerator({Key? key, required this.object}) : super(key: key);

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  final String uniqueCode = const Uuid().v4();
  bool isLoading = false;
  // Generate a unique code
  bool generate = false;

  Future<void> _printQRCode(BuildContext context) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final image = await imageFromAssetBundle('assets/images/logo.png');
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
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
                  "Attendece QR Code",
                  style: pw.TextStyle(font: font, fontSize: 55),
                  textAlign: pw.TextAlign.center,
                )),
                pw.Padding(padding: const pw.EdgeInsets.only(top: 60)),
                pw.Center(
                  child: pw.BarcodeWidget(
                      data: uniqueCode,
                      barcode: pw.Barcode.qrCode(),
                      width: 200,
                      height: 200),
                )
              ]);
        },
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<bool> setqrcode(String Code) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final studentData = extractedData[widget.object];
      print(response.statusCode);
      studentData['qrcode'] = Code;
      final updateResponse = await http.put(
        Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json?auth=${authProvider.authToken}",
        ),
        body: json.encode(studentData),
      );
      print(updateResponse.statusCode);
      return true;
    } catch (error) {
      print(error);
      showAlertDialog(
          context, "Try again", "check your connectivity!", 'error');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: Center(
          child: generate
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: QrImageView(
                        data:
                            uniqueCode, // Set the unique code as the data for QR code
                        size: 150.0,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30),
                      child: Center(
                        child: Text(
                          'please print and save the qr code inorder to set the new QR code',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    )
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      generate = true;
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Center(
                          child: Text(
                        'Generate new QR code for attendence',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF8B5FBF),
                        ),
                      )),
                    ),
                  ),
                )),
      floatingActionButton: generate
          ? isLoading
              ? const SpinKitCubeGrid(
                  color: Color(0xFF8B5FBF),
                  size: 50.0,
                )
              : FloatingActionButton.extended(
                  icon: const Icon(Icons.print),
                  backgroundColor: const Color(0xFF8B5FBF),
                  onPressed: () async {
                    isLoading = true;
                    bool set = await setqrcode(uniqueCode);
                    if (set == true) {
                      isLoading = false;
                      _printQRCode(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'qr code data has been saved successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Something went wroung, try again')),
                      );
                    }
                    isLoading = false;
                  },
                  label: const Text("Print and save"))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
