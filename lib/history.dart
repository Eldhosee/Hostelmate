import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'model/user_model.dart';

class History extends StatefulWidget {
  /// Creates the home page.
  final String object;
  History({Key? key, required this.object}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class BillEntry {
  final int amount;
  final String reason;
  final String timestamp;

  BillEntry({
    required this.amount,
    required this.reason,
    required this.timestamp,
  });
}

class _HistoryState extends State<History> {
  List<BillEntry> employees = <BillEntry>[];
  late EmployeeDataSource employeeDataSource;
  late Map<String, dynamic> studentData;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    employeeDataSource = EmployeeDataSource(historyEntries: []);
    readData();
  }

  Future<void> readData() async {
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
      if (extractedData == null) {
        return;
      }
      studentData = extractedData[widget.object];
      if (studentData == null || studentData is! Map<String, dynamic>) {
        // Handle the case where the student data is missing or has an unexpected format
        return;
      }
      List<dynamic> historyData = studentData["history"];
      List<BillEntry> historyEntries = historyData
          .map<BillEntry>((data) => BillEntry(
                amount: data["amount"],
                reason: data["reason"],
                timestamp: data["timestamp"],
              ))
          .toList();
      employeeDataSource = EmployeeDataSource(historyEntries: historyEntries);
      print(historyData);
      print(historyEntries);

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 30, bottom: 50),
            child: Center(
              child: Text(
                'Bill Paid History',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const SpinKitCubeGrid(
                    color: Color(0xFF8B5FBF),
                    size: 80.0,
                  )
                : SfDataGridTheme(
                    data: SfDataGridThemeData(
                      headerColor: const Color.fromARGB(142, 140, 95, 191),
                    ),
                    child: SfDataGrid(
                      source: employeeDataSource,
                      columnWidthMode: ColumnWidthMode.fill,
                      isScrollbarAlwaysShown: true,
                      columns: <GridColumn>[
                        GridColumn(
                          columnName: 'amount',
                          label: Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: const Text('Amount'),
                          ),
                        ),
                        GridColumn(
                          columnName: 'reason',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('Reason'),
                          ),
                        ),
                        GridColumn(
                          columnName: 'timestamp',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('Timestamp'),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<BillEntry> historyEntries}) {
    _employeeData = historyEntries
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'amount', value: e.amount),
              DataGridCell<String>(columnName: 'reason', value: e.reason),
              DataGridCell<String>(columnName: 'timestamp', value: e.timestamp),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == 'amount') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        } else if (e.columnName == 'reason') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        } else if (e.columnName == 'timestamp') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }
        return SizedBox.shrink();
      }).toList(),
    );
  }
}
