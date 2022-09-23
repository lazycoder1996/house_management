import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/backend/student.dart';
import 'package:house_management/model/student.dart';
import 'package:house_management/widgets/discard_changes.dart';
import 'package:provider/provider.dart';

import '../../../../model/exeat.dart';
import '../../../../utils/format_date.dart';

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
    await Provider.of<StudentProvider>(context, listen: false)
        .fetchExeats(student: widget.student, context: context);
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
                  showDialog(
                    context: context,
                    builder: (context) => AddExeatRecord(
                      student: widget.student,
                    ),
                  );
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

class ExeatTable extends StatefulWidget {
  const ExeatTable({Key? key}) : super(key: key);

  @override
  State<ExeatTable> createState() => _ExeatTableState();
}

class _ExeatTableState extends State<ExeatTable> {
  List<String> formRow(ExeatModel exeat) {
    return [
      formatDate(exeat.departure),
      exeat.reason,
      exeat.destination,
      formatDate(exeat.expectedReturn),
      exeat.dateReturned != null ? formatDate(exeat.dateReturned!) : "",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, sp, child) {
        return sp.exeats.isEmpty
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
                rows: sp.exeats
                    .map(
                      (exeat) => m.DataRow(
                        cells: formRow(exeat)
                            .map(
                              (item) => m.DataCell(
                                item.isNotEmpty
                                    ? Text(item)
                                    : IconButton(
                                        icon: const Icon(
                                          FluentIcons.edit,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return EditExeatRecord(
                                                student: sp.selectedStudent,
                                                exeat: exeat,
                                              );
                                            },
                                          );
                                        },
                                      ),
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

class AddExeatRecord extends StatefulWidget {
  final StudentModel student;

  const AddExeatRecord({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  State<AddExeatRecord> createState() => _AddExeatRecordState();
}

class _AddExeatRecordState extends State<AddExeatRecord> {
  DateTime expectedDate = DateTime.now().add(const Duration(days: 2));
  TextEditingController reasonController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    destinationController.text = widget.student.residence;
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      actions: [
        Button(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Cancel'),
          ),
          onPressed: () {
            if (reasonController.text.isNotEmpty ||
                destinationController.text.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) => const DiscardContentDialog());
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        Button(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Save'),
          ),
          onPressed: () async {
            // insert into student exeat
            await Provider.of<StudentProvider>(context, listen: false)
                .addExeat(
              student: widget.student,
              values: {
                'reason': reasonController.text.trim(),
                'destination': destinationController.text.trim(),
                'expected_return': expectedDate,
              },
              context: context,
            )
                .then((value) {
              Navigator.of(context).pop();
            });
          },
        ),
      ],
      title: const Text('Add exeat record'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextBox(
            placeholder: 'Reason',
            controller: reasonController,
          ),
          const SizedBox(
            height: 30,
          ),
          TextBox(
            placeholder: 'Destination',
            controller: destinationController,
          ),
          const SizedBox(
            height: 30,
          ),
          DatePicker(
            selected: expectedDate,
            onChanged: (newDate) {
              setState(() {
                expectedDate = newDate;
              });
            },
          )
        ],
      ),
    );
  }
}

class EditExeatRecord extends StatefulWidget {
  final StudentModel student;
  final ExeatModel exeat;

  const EditExeatRecord({
    Key? key,
    required this.student,
    required this.exeat,
  }) : super(key: key);

  @override
  State<EditExeatRecord> createState() => _EditExeatRecordState();
}

class _EditExeatRecordState extends State<EditExeatRecord> {
  DateTime returnDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      content: DatePicker(
        header: 'Date Returned',
        selected: returnDate,
        onChanged: (date) {
          setState(() {
            returnDate = date;
          });
        },
      ),
      title: const Text('Edit record'),
      actions: [
        Button(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('CANCEL'),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Button(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('SAVE'),
          ),
          onPressed: () async {
            // UPDATE EXEAT AND STUDENT
            if (returnDate.isAfter(DateTime.now())) {
              showSnackbar(
                context,
                const Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Text(
                    'Date returned cannot be in advanced',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                alignment: Alignment.bottomCenter,
              );
            } else {
              await Provider.of<StudentProvider>(context, listen: false)
                  .updateExeat(
                returnDate: returnDate,
                context: context,
                exeat: widget.exeat,
                student: widget.student,
              )
                  .then((value) {
                Navigator.of(context).pop();
              });
            }
          },
        ),
      ],
    );
  }
}
