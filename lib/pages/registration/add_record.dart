import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/backend/student.dart';
import 'package:house_management/model/house.dart';
import 'package:house_management/model/programme.dart';
import 'package:house_management/utils/to_title_case.dart';
import 'package:house_management/widgets/discard_changes.dart';
import 'package:provider/provider.dart';

import '../../utils/format_name.dart';

class AddStudentRecord extends StatefulWidget {
  const AddStudentRecord({Key? key}) : super(key: key);

  @override
  State<AddStudentRecord> createState() => _AddStudentRecordState();
}

class _AddStudentRecordState extends State<AddStudentRecord> {
  DateTime dob = DateTime.now();
  final TextEditingController _studentName = TextEditingController();
  final TextEditingController _parentName = TextEditingController();
  final TextEditingController _residence = TextEditingController();
  final TextEditingController _parentContact = TextEditingController();
  String _programme = 'Select';
  List<HouseModel> houses = [];
  List<ProgrammeModel> programmes = [];
  String _house = 'Select';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    houses = Provider.of<Backend>(context, listen: false).houses;
    programmes = Provider.of<Backend>(context, listen: false).programmes;
  }

  bool verifyRecords() {
    return _studentName.text.isNotEmpty &&
        _parentName.text.isNotEmpty &&
        _residence.text.isNotEmpty &&
        _parentContact.text.isNotEmpty &&
        _programme != 'Select' &&
        _house != 'Select';
  }

  safeToCancel() {
    return _studentName.text.isEmpty &&
        _parentName.text.isEmpty &&
        _residence.text.isEmpty &&
        _parentContact.text.isEmpty &&
        _programme == 'Select' &&
        _house == 'Select';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ContentDialog(
      actions: [
        Button(
          onPressed: () {
            if (safeToCancel()) {
              Navigator.pop(context);
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const DiscardContentDialog();
                  });
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Cancel'),
          ),
        ),
        Button(
          onPressed: () {
            if (verifyRecords()) {
              Provider.of<StudentProvider>(context, listen: false)
                  .addStudent(
                      name: formatName(toTitle(_studentName.text.trim())),
                      programme: _programme,
                      house: _house,
                      parentName: formatName(toTitle(_parentName.text.trim())),
                      residence: formatName(toTitle(_residence.text.trim())),
                      contact: _parentContact.text.trim(),
                      dob: dob,
                      status: 'in school')
                  .then((value) {
                setState(() {
                  _studentName.clear();
                  _parentName.clear();
                  _house = 'Select';
                  _parentContact.clear();
                  _programme = 'Select';
                  _residence.clear();
                  dob = DateTime.now();
                });
              });
            } else {
              showSnackbar(
                context,
                const Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Text(
                    'Please fill out all forms',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                alignment: Alignment.bottomCenter,
              );
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Save'),
          ),
        ),
      ],
      title: const Text('Add Student'),
      constraints: BoxConstraints.expand(
          width: size.width * 0.5, height: size.height * 0.6),
      content: SizedBox(
        height: 500,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Name'),
                  Text('Programme'),
                  Text('House'),
                  Text('Parent\'s name'),
                  Text('Residence'),
                  Text('Parent\'s contact'),
                  Text('Date of birth'),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBox(
                    controller: _studentName,
                    padding: const EdgeInsets.all(10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: DropDownButton(
                      title: Text(_programme),
                      items: programmes
                          .map(
                            (programme) => MenuFlyoutItem(
                              onPressed: () {
                                setState(() {
                                  _programme = programme.name;
                                });
                              },
                              text: Text(programme.name),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  DropDownButton(
                    title: Text(_house),
                    items: houses
                        .map(
                          (house) => MenuFlyoutItem(
                            onPressed: () {
                              setState(() {
                                _house = house.name;
                              });
                            },
                            text: Text(house.name),
                          ),
                        )
                        .toList(),
                  ),
                  TextBox(
                    controller: _parentName,
                    padding: const EdgeInsets.all(10),
                  ),
                  TextBox(
                    controller: _residence,
                    padding: const EdgeInsets.all(10),
                  ),
                  TextBox(
                    controller: _parentContact,
                    padding: const EdgeInsets.all(10),
                  ),
                  SizedBox(
                    width: 295,
                    child: DatePicker(
                      selected: dob,
                      onChanged: (v) => setState(() {
                        dob = DateTime(v.year, v.month, v.day);
                      }),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
