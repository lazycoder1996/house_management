import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/model/item.dart';
import 'package:house_management/model/logistics.dart';
import 'package:house_management/model/student.dart';
import 'package:house_management/widgets/discard_changes.dart';
import 'package:provider/provider.dart';

import '../../../../backend/student.dart';

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
  late List<ItemModel> items;

  @override
  void initState() {
    super.initState();
    items = Provider.of<Backend>(context, listen: false).items.sublist(0);

    loadData();
  }

  loadData() async {
    await Provider.of<StudentProvider>(context, listen: false)
        .fetchLogistics(student: widget.student, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(builder: (context, sp, child) {
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
                  icon: Icon(
                    sp.studentLogistics.isEmpty
                        ? FluentIcons.add_to
                        : FluentIcons.edit_table,
                    size: 24,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AddLogisticsDialog(provider: sp));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 50),
            child: sp.studentLogistics.isEmpty
                ? const Center(
                    child: Text(
                      'No submission made',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  )
                : m.Wrap(
                    spacing: 25,
                    runSpacing: 15,
                    children: items.map(
                      (e) {
                        return LogisticItem(
                          item: e.name,
                          submitted:
                              sp.studentLogistics.first.items!.contains(e.name),
                        );
                      },
                    ).toList(),
                  ),
          )
        ],
      );
    });
  }
}

class AddLogisticsDialog extends StatefulWidget {
  final StudentProvider provider;

  const AddLogisticsDialog({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<AddLogisticsDialog> createState() => _AddLogisticsDialogState();
}

class _AddLogisticsDialogState extends State<AddLogisticsDialog> {
  late List<ItemModel> items;
  Map<String, bool> selected = {};

  @override
  void initState() {
    super.initState();
    items = Provider.of<Backend>(context, listen: false).items.sublist(0);
    List<LogisticsModel> studentLogistics = widget.provider.studentLogistics;
    if (studentLogistics.isNotEmpty) {
      items.removeWhere((item) {
        return studentLogistics.first.items!.contains(item.name);
      });
    }
    for (var item in items) {
      selected[item.name] = false;
    }
  }

  List<String> selectedItems(Map<String, bool> allItems) {
    List<String> res = [];
    for (String item in allItems.keys) {
      if (allItems[item]!) {
        res.add("'$item'");
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: selected.isEmpty
          ? Text(
              '${widget.provider.selectedStudent.name} has submitted all items',
              style: const TextStyle(fontWeight: FontWeight.w500),
            )
          : const Text('Choose from the list below'),
      actions: [
        Button(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Cancel'),
          ),
          onPressed: () {
            if (selected.values.contains(true)) {
              showDialog(
                context: context,
                builder: (context) => const DiscardContentDialog(),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        if (selected.isNotEmpty)
          Button(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Save'),
            ),
            onPressed: () async {
              if (selected.values
                  .where((element) => element)
                  .toList()
                  .isEmpty) {
                showSnackbar(
                  context,
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Text(
                      'Please select at least one item',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                );
              } else if (widget.provider.studentLogistics.isEmpty) {
                // inserting
                await Provider.of<StudentProvider>(context, listen: false)
                    .addLogistics(
                        context: context,
                        student: widget.provider.selectedStudent,
                        items: selectedItems(selected))
                    .then((value) {
                  Navigator.of(context).pop();
                });
              } else {
                // updating
                await Provider.of<StudentProvider>(context, listen: false)
                    .updateLogistics(
                        context: context,
                        student: widget.provider.selectedStudent,
                        items: selectedItems(selected))
                    .then((value) {
                  Navigator.of(context).pop();
                });
              }
            },
          ),
      ],
      content: m.Wrap(
        // mainAxisSize: MainAxisSize.min,
        runSpacing: 8.0,
        spacing: 20.0,
        children: items.map((e) {
          return ToggleButton(
            checked: selected[e.name]!,
            onChanged: (value) {
              setState(() {
                selected[e.name] = value;
              });
            },
            child: Text(
              e.name,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class LogisticItem extends StatefulWidget {
  final String item;
  final bool submitted;

  const LogisticItem({
    Key? key,
    required this.item,
    required this.submitted,
  }) : super(key: key);

  @override
  State<LogisticItem> createState() => _LogisticItemState();
}

class _LogisticItemState extends State<LogisticItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.item,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          height: 20,
          width: 20,
          color: widget.submitted ? Colors.green : Colors.red,
        ),
      ],
    );
  }
}
