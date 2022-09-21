import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/model/student.dart';
import 'package:provider/provider.dart';

class ExeatRecord extends StatefulWidget {
  final StudentModel student;

  const ExeatRecord({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  State<ExeatRecord> createState() => _ExeatRecordState();
}

class _ExeatRecordState extends State<ExeatRecord> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Provider.of<Backend>(context, listen: false)
        .fetchStudentExeat(student: widget.student);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exeat',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(
                  FluentIcons.add_to,
                  size: 24,
                ),
                onPressed: () {
                  // todo: insert into exeat for student
                },
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 50, top: 20),
          child: ExeatTable(),
        ),
      ],
    );
  }
}

class ExeatTable extends StatelessWidget {
  const ExeatTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Backend>(builder: (context, backend, child) {
      return backend.studentLogistics.isEmpty
          ? const Center(
              child: Text(
                'No records found',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            )
          : m.DataTable(
              border: m.TableBorder.all(
                color: m.Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
              columns: [
                'Departure',
                'Reason',
                'Destination',
                'Expected return',
                'Date returned'
              ].map((e) => m.DataColumn(label: Text(e))).toList(),
              rows: const [],
            );
    });
  }
}
