import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/backend/student.dart';
import 'package:house_management/model/student.dart';
import 'package:house_management/utils/format_date.dart';
import 'package:provider/provider.dart';

class RollCallRecord extends StatefulWidget {
  final StudentModel student;

  const RollCallRecord({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  State<RollCallRecord> createState() => _RollCallRecordState();
}

class _RollCallRecordState extends State<RollCallRecord> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Provider.of<StudentProvider>(context, listen: false)
        .fetchRollCalls(id: widget.student.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Roll Call',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 50, top: 20),
          child: RollCallTable(),
        ),
      ],
    );
  }
}

class RollCallTable extends StatelessWidget {
  const RollCallTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<StudentProvider>(builder: (context, sp, child) {
      return sp.rollCalls.isEmpty
          ? const Center(
              child: Text(
                'No roll calls conducted',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            )
          : m.DataTable(
              border: m.TableBorder.all(
                color: m.Colors.grey,
              ),
              columnSpacing: 76,
              columns: ['Date', 'Status']
                  .map((e) => m.DataColumn(label: Text(e)))
                  .toList(),
              rows: sp.rollCalls
                  .map((e) => m.DataRow(
                        cells: [
                          m.DataCell(Text(formatDate(e.date))),
                          m.DataCell(e.status
                              ? Icon(
                                  FluentIcons.check_mark,
                                  color: Colors.green,
                                )
                              : Icon(
                                  FluentIcons.cancel,
                                  color: Colors.red,
                                )),
                        ],
                      ))
                  .toList(),
            );
    });
  }
}
