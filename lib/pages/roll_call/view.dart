import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/backend/student.dart';
import 'package:house_management/model/house.dart';
import 'package:house_management/pages/registration/filter.dart';
import 'package:provider/provider.dart';

import '../../model/student.dart';

class RollCallPage extends StatefulWidget {
  const RollCallPage({Key? key}) : super(key: key);

  @override
  State<RollCallPage> createState() => _RollCallPageState();
}

class _RollCallPageState extends State<RollCallPage> {
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
          const FilterWidget(),
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
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.houses.first.name;
    init();
  }

  init() async {
    Map<String, List<StudentModel>> students = {};
    for (HouseModel house in widget.houses) {
      print('searching for ${house.name}');

      await Provider.of<StudentProvider>(context, listen: false)
          .fetchStudents(
        query:
            "select * from registration r join house h on lower(r.house)=lower(h.name) where h.name = '${house.name}'",
      )
          .then((value) {
        students[house.name] = value;
        print('${house.name} => ${students[house.name]}');
      });
    }
    print('students => ${students}');
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      onKeyEvent: (v) {
        print(v.physicalKey.usbHidUsage);
        if (v.physicalKey.usbHidUsage == 01) {
          print('eeeii');
        }
      },
      focusNode: FocusNode(),
      child: ContentDialog(
        title: DropDownButton(
          title: Text(selected),
          items: widget.houses
              .map(
                (e) => MenuFlyoutItem(
                  text: Text(e.name),
                  onPressed: () {},
                ),
              )
              .toList(),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // children:
            // [selected]!.map((e) {
            //   return Checkbox(
            //     content: Text(e.name),
            //     onChanged: (val) {},
            //     checked: false,
            //   );
            // }).toList(),
          ),
        ),
      ),
    );
  }
}
