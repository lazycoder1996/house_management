import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/backend/roll_call.dart';
import 'package:house_management/backend/student.dart';
import 'package:house_management/model/house.dart';
import 'package:provider/provider.dart';

import '../../model/student.dart';

class RollCallPage extends StatefulWidget {
  const RollCallPage({Key? key}) : super(key: key);

  @override
  State<RollCallPage> createState() => _RollCallPageState();
}

class _RollCallPageState extends State<RollCallPage> {
  Map<String, dynamic> filterFields = {};
  String baseQuery = '';

  @override
  void initState() {
    super.initState();
    init();
    fetchRollCalls();
  }

  init() async {
    filterFields = {
      'date': {
        'fields': {},
        'query': [],
      },
      // 'house': {
      //   'fields': {},
      //   'query': [],
      // },
    };
    // for (HouseModel house
    //     in Provider.of<Backend>(context, listen: false).houses) {
    //   filterFields['house']['fields'][house.name] = false;
    // }
    await Provider.of<RollCallProvider>(context, listen: false)
        .fetchUniqueDates()
        .then((value) {
      setState(() {
        for (String date in value) {
          filterFields['date']['fields'][date] = false;
        }
      });
    });
  }

  fetchRollCalls() async {
    await Provider.of<RollCallProvider>(context, listen: false).fetchRolls(
      query: baseQuery,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Center(
          child: Text('Roll Calls'),
        ),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const FilterWidget(),
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            // color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ...filterFields['date']['fields'].keys.map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RadioButton(
                            content: Text(e),
                            checked: filterFields['date']['fields'][e],
                            onChanged: (v) {
                              setState(() {
                                filterFields['date']['fields']
                                    .updateAll((key, value) => false);
                                filterFields['date']['fields'][e] = v;
                              });
                              Provider.of<RollCallProvider>(context,
                                      listen: false)
                                  .fetchRolls(
                                query:
                                    "select rc.house, r.date, count(case when r.status = true then r.id end) as present, "
                                    "count(case when r.status = false then r.id end) as absent "
                                    "from roll_call as r join registration rc on r.std_id=rc.std_id "
                                    "where date = '$e' group by house, r.date",
                              );
                            },
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Tooltip(
                      message: 'Conduct Roll call',
                      child: IconButton(
                        icon: const Icon(
                          FluentIcons.add_to,
                          size: 40,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const ConductRollCall(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Consumer<RollCallProvider>(
                      builder: (context, rp, child) {
                        return m.DataTable(
                            columns: ['House', 'No. Present', 'No. absent']
                                .map(
                                  (e) => m.DataColumn(
                                    label: Text(e),
                                  ),
                                )
                                .toList(),
                            rows: rp.rollCalls
                                .map(
                                  (e) => m.DataRow(
                                    cells: [
                                      m.DataCell(
                                        Text(e.house),
                                      ),
                                      m.DataCell(
                                        Text(e.present.toString()),
                                      ),
                                      m.DataCell(
                                        Text(e.absent.toString()),
                                      ),
                                    ],
                                  ),
                                )
                                .toList());
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ConductRollCall extends StatefulWidget {
  const ConductRollCall({Key? key}) : super(key: key);

  @override
  State<ConductRollCall> createState() => _ConductRollCallState();
}

class _ConductRollCallState extends State<ConductRollCall> {
  Map<HouseModel, bool> selectedHouses = {};
  late List<HouseModel> houses;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    houses = Provider.of<Backend>(context, listen: false).houses;
    houses.removeWhere((element) => element.name == 'Day');
    for (HouseModel house in houses) {
      selectedHouses[house] = false;
    }
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
            Navigator.of(context).pop();
          },
        ),
        Button(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Proceed'),
          ),
          onPressed: () {
            if (selectedHouses.values.every((element) => !element)) {
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AllList(
                      houses: selectedHouses.keys
                          .map((e) {
                            return e;
                          })
                          .where((element) => selectedHouses[element]!)
                          .toList(),
                    );
                  });
            }
          },
        ),
      ],
      title: const Text('Conduct Roll'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Select House',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ToggleButton(
                  checked: !selectedHouses.containsValue(false),
                  onChanged: (v) {
                    setState(() {
                      selectedHouses.updateAll((key, value) => v);
                    });
                  },
                  child: const Text('All'),
                ),
              ),
              ...houses
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ToggleButton(
                          checked: selectedHouses[e]!,
                          onChanged: (v) {
                            setState(() {
                              selectedHouses[e] = v;
                            });
                          },
                          child: Text(e.name),
                        ),
                      ))
                  .toList()
            ],
          )
        ],
      ),
    );
  }
}

class AllList extends StatefulWidget {
  final List<HouseModel> houses;

  const AllList({
    Key? key,
    required this.houses,
  }) : super(key: key);

  @override
  State<AllList> createState() => _AllListState();
}

class _AllListState extends State<AllList> {
  late HouseModel selected;

  Map<String, List<StudentModel>> students = {};
  Map<StudentModel, bool> roll = {};

  @override
  void initState() {
    super.initState();
    selected = widget.houses.first;
    init();
  }

  init() async {
    for (HouseModel house in widget.houses) {
      await Provider.of<StudentProvider>(context, listen: false)
          .fetchStudents(
        query:
            "select * from registration r join house h on lower(r.house)=lower(h.name) where h.name = '${house.name}'",
      )
          .then((value) {
        setState(() {
          students[house.name] = value;
        });
      });
    }
    for (List<StudentModel> houseStudent in students.values) {
      for (StudentModel student in houseStudent) {
        roll[student] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      actions: [
        Button(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Close'),
          ),
          onPressed: () async {
            for (StudentModel student in roll.keys) {
              await Provider.of<StudentProvider>(context, listen: false)
                  .addRollCall(
                student: student,
                context: context,
                value: roll[student],
              )
                  .then((value) {
                Navigator.of(context).pop();
              });
            }
          },
        )
      ],
      // constraints: const BoxConstraints.expand(width: 500),
      title: DropDownButton(
        title: Text(selected.name),
        items: widget.houses
            .map(
              (house) => MenuFlyoutItem(
                text: Text(house.name),
                onPressed: () {
                  setState(() {
                    selected = house;
                  });
                },
              ),
            )
            .toList(),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: students.isEmpty
              ? []
              : students[selected.name]!.map((student) {
                  return Checkbox(
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(student.id.toString()),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(student.name),
                        ],
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        roll[student] = val!;
                      });
                    },
                    checked: roll[student] ?? false,
                  );
                }).toList(),
        ),
      ),
    );
  }
}
