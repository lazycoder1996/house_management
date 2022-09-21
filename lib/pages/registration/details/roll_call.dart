import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/model/student.dart';

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

  loadData() async {}

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
    return m.DataTable(
      border: m.TableBorder.all(
        color: m.Colors.grey,
      ),
      columns:
          ['Date', 'Status'].map((e) => m.DataColumn(label: Text(e))).toList(),
      rows: [],
    );
  }
}
