import 'package:flutter/material.dart';
import 'package:mini_project/appbar.dart';
import 'package:mini_project/matron/details.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../model/user_model.dart';

class Rooms extends StatefulWidget {
  final String object;

  Rooms({Key? key, required this.object}) : super(key: key);

  @override
  State<Rooms> createState() => _RoomsState();
}

class BillEntry {
  final String name;
  final String email;
  final String room;
  final String college;
  final String year;
  final String phone;
  final String department;

  BillEntry({
    required this.name,
    required this.email,
    required this.phone,
    required this.room,
    required this.year,
    required this.college,
    required this.department,
  });
}

class _RoomsState extends State<Rooms> {
  List<BillEntry> students = [];
  late EmployeeDataSource employeeDataSource;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    employeeDataSource = EmployeeDataSource(
        entries: [], context: context, object: widget.object);
    readData();
  }

  Future<void> readData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      print(response.statusCode);
      setState(() {
        students = [];
      });

      final presentuser = extractedData[widget.object];
      extractedData.forEach((key, value) {
        final studentData = value as Map<String, dynamic>;
        if (studentData['hostel'] == presentuser['hostel'] &&
            studentData['email'] != presentuser['email']) {
          print(studentData['name']);
          students.add(BillEntry(
            name: studentData['name'],
            email: studentData['email'],
            room: studentData['room'],
            year: studentData['year'],
            college: studentData['college'],
            phone: studentData['phone'],
            department: studentData['department'],
          ));
        }
      });

      setState(() {
        employeeDataSource = EmployeeDataSource(
            entries: students, context: context, object: widget.object);
        isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterData(String query) {
    List<BillEntry> filteredEntries = [];

    for (var entry in students) {
      if (entry.name.toLowerCase().contains(query.toLowerCase())) {
        filteredEntries.add(entry);
      }
    }
    setState(() {
      employeeDataSource = EmployeeDataSource(
          entries: filteredEntries, context: context, object: widget.object);
      print(employeeDataSource);
      print(filteredEntries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE9E4ED),
        appBar: const MyAppBar(),
        body: RefreshIndicator(
            onRefresh: readData,
            child: Stack(children: <Widget>[
              ListView(),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 50),
                    child: Center(
                      child: Text(
                        'Students list',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 145, 145, 145)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: TextField(
                      onChanged: (value) {
                        if (value == '') {
                          readData();
                        }

                        filterData(value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search by Name',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                      child: isLoading
                          ? const SpinKitCubeGrid(
                              color: Color(0xFF8B5FBF),
                              size: 50.0,
                            )
                          : SingleChildScrollView(
                              child: SfDataGridTheme(
                                data: SfDataGridThemeData(
                                  headerColor:
                                      const Color.fromARGB(142, 140, 95, 191),
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
                                      columnName: 'Phone',
                                      label: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text('Phone'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Room',
                                      label: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text('Room'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Department',
                                      label: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text('Department'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'College',
                                      label: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text('College'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                ],
              ),
            ])));
  }
}

class EmployeeDataSource extends DataGridSource {
  var context;
  var object;

  EmployeeDataSource({
    required List<BillEntry> entries,
    required this.context,
    required this.object,
  }) {
    _employeeData = entries
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Name', value: e.name),
              DataGridCell<String>(columnName: 'Email', value: e.email),
              DataGridCell<String>(columnName: 'Phone', value: e.phone),
              DataGridCell<String>(columnName: 'Room', value: e.room),
              DataGridCell<String>(
                  columnName: 'Department', value: e.department),
              DataGridCell<String>(columnName: 'College', value: e.college),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MatronMore(
                            email: e.value.toString(),
                            matron: object,
                          )),
                );
              },
              child: Text(
                e.value.toString(),
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          );
        } else if (e.columnName == 'Phone') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        } else if (e.columnName == 'Room') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        } else if (e.columnName == 'Department') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        } else if (e.columnName == 'College') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }
}
