import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/model/student.dart';

class PunishmentRecord extends StatefulWidget {
  final StudentModel student;

  const PunishmentRecord({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  State<PunishmentRecord> createState() => _PunishmentRecordState();
}

class _PunishmentRecordState extends State<PunishmentRecord> {
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Punishment',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(
                  FluentIcons.add_to,
                  size: 24,
                ),
                onPressed: () {
                  // todo: insert into punishment for student
                },
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20, 50, 0),
          child: PunishmentTable(),
        ),
      ],
    );
  }
}

class PunishmentTable extends StatelessWidget {
  const PunishmentTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return m.DataTable(
      border: m.TableBorder.all(
        color: m.Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      columns: [
        'Date issued',
        'Cause',
        'Punishment',
        'Days of working',
        'Status'
      ].map((e) => m.DataColumn(label: Text(e))).toList(),
      rows: const [],
    );
  }
}
