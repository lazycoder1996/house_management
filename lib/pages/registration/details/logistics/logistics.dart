import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/model/student.dart';
import 'package:house_management/utils/format_date.dart';
import 'package:provider/provider.dart';

class LogisticsRecord extends StatefulWidget {
  final StudentModel student;

  const LogisticsRecord({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  State<LogisticsRecord> createState() => _LogisticsRecordState();
}

class _LogisticsRecordState extends State<LogisticsRecord> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Provider.of<Backend>(context, listen: false)
        .fetchStudentLogistics(student: widget.student);
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
                'Logistics',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(
                  FluentIcons.add_to,
                  size: 24,
                ),
                onPressed: () {
                  // todo: insert into logistics for student
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 50),
          child: LogisticsTable(),
        )
      ],
    );
  }
}

class LogisticsTable extends StatelessWidget {
  const LogisticsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<Backend>(
      builder: (context, backend, child) {
        return backend.studentLogistics.isEmpty
            ? const Center(
                child: Text(
                  'No submission made',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              )
            : m.DataTable(
                dataRowHeight: 80,
                border: m.TableBorder.all(
                  color: m.Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                columns: ['Date', 'Items']
                    .map((e) => m.DataColumn(label: Text(e)))
                    .toList(),
                rows: [
                  [
                    backend.studentLogistics[0].date,
                    backend.studentLogistics[0].items
                  ]
                ]
                    .map(
                      (row) => m.DataRow(
                        cells: row
                            .map(
                              (f) => m.DataCell(row.indexOf(f) == 0
                                      ? Text(formatDate(f as DateTime))
                                      : m.Wrap(
                                          children: [f as List<String>][0]
                                              .map(
                                                (e) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(e),
                                                ),
                                              )
                                              .toList(),
                                        )
                                  // : Text(parseItems(f as List<String>)),
                                  ),
                            )
                            .toList(),
                      ),
                    )
                    .toList(),
              );
      },
    );
  }
}
