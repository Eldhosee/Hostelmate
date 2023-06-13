import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'model/user_model.dart';

class NotPaidList extends StatefulWidget {
  final String object;

  NotPaidList({Key? key, required this.object}) : super(key: key);

  @override
  State<NotPaidList> createState() => _NotPaidListState();
}

class BillEntry {
  final String name;
  final String email;
  final int amount;

  BillEntry({
    required this.name,
    required this.email,
    required this.amount,
  });
}

class _NotPaidListState extends State<NotPaidList> {
  List<BillEntry> students = [];
  late EmployeeDataSource employeeDataSource;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    employeeDataSource = EmployeeDataSource(entries: []);
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

      List<BillEntry> paidListEntries = [];
      final presentuser = extractedData[widget.object];
      extractedData.forEach((key, value) {
        final studentData = value as Map<String, dynamic>;
        if (studentData['MessFee'] != 0 &&
            studentData['Hostel'] == presentuser['Hostel']) {
          paidListEntries.add(BillEntry(
            name: studentData['name'],
            email: studentData['email'],
            amount: studentData['MessFee'],
          ));
        }
      });
      if (paidListEntries.isEmpty) {
        print("null");
      }
      print(paidListEntries);
      employeeDataSource = EmployeeDataSource(entries: paidListEntries);

      isLoading = false;
      setState(() {});
    } catch (error) {
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
                'Bill Not Paid List',
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
                          columnName: 'Name',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('Name'),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Email',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('Email'),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Amount',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('Amount'),
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
  EmployeeDataSource({required List<BillEntry> entries}) {
    _employeeData = entries
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Name', value: e.name),
              DataGridCell<String>(columnName: 'Email', value: e.email),
              DataGridCell<int>(columnName: 'Amount', value: e.amount),
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
        if (e.columnName == 'Name') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        } else if (e.columnName == 'Email') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        } else if (e.columnName == 'Amount') {
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
