import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/backend/student.dart';
import 'package:house_management/model/status.dart';
import 'package:house_management/model/student.dart';
import 'package:house_management/utils/format_name.dart';
import 'package:house_management/utils/to_title_case.dart';
import 'package:house_management/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

import '../../../backend/fetch.dart';
import '../../../model/house.dart';
import '../../../model/programme.dart';
import '../../../utils/parse_month.dart';

class ProfileRecord extends StatefulWidget {
  final StudentModel student;

  const ProfileRecord({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  State<ProfileRecord> createState() => _ProfileRecordState();
}

class _ProfileRecordState extends State<ProfileRecord> {
  final TextEditingController _studentName = TextEditingController();
  final TextEditingController _parentName = TextEditingController();
  final TextEditingController _residence = TextEditingController();
  final TextEditingController _parentContact = TextEditingController();
  String _programme = 'Select';
  List<HouseModel> houses = [];
  List<ProgrammeModel> programmes = [];
  String _house = 'Select';
  DateTime dob = DateTime.now();
  bool editMode = false;
  List<StatusModel> statuses = [];
  String _status = 'Select';

  toggleEditMode() {
    setState(() {
      editMode = !editMode;
    });
  }

  @override
  void initState() {
    super.initState();
    dob = DateTime(dob.year, dob.month, dob.day);
    init();
  }

  init() {
    houses = Provider.of<Backend>(context, listen: false).houses;
    programmes = Provider.of<Backend>(context, listen: false).programmes;
    _studentName.text = widget.student.name;
    _parentContact.text = widget.student.contact;
    _parentName.text = widget.student.parentName;
    _residence.text = widget.student.residence;
    _programme = widget.student.programme;
    _house = widget.student.house.name;
    dob = widget.student.dob;
    dob = DateTime(dob.year, dob.month, dob.day);
    _status = widget.student.status;
    statuses = Provider.of<Backend>(context, listen: false).status;
  }

  String queryString = "";
  String newName = "";
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
                'Profile',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  editMode ? FluentIcons.save_all : FluentIcons.edit_contact,
                  size: 24,
                ),
                onPressed: () {
                  toggleEditMode();
                  if (!editMode) {
                    Provider.of<StudentProvider>(context, listen: false)
                        .updateStudent(
                      name: formatName(toTitle(_studentName.text.trim())),
                      house: _house,
                      programme: _programme,
                      parentName: formatName(toTitle(_parentName.text.trim())),
                      residence: formatName(toTitle(_residence.text.trim())),
                      contact: _parentContact.text.trim(),
                      dob: dob,
                      status: _status,
                      id: widget.student.id,
                    );
                  }
                },
              )
            ],
          ),
        ),
        // PROFILE PICTURE
        Center(
          child: ProfilePicture(
            student: widget.student,
            height: 150,
            width: 150,
            names: _studentName.text.trim(),
          ),
        ),
        // DETAILS
        SizedBox(
          height: 450,
          child: Padding(
            padding: const EdgeInsets.only(left: 80, right: 80, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      child: Text('Name'),
                    ),
                    Flexible(
                      child: TextBox(
                        enabled: editMode,
                        controller: _studentName,
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      child: Text('Programme'),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: DropDownButton(
                          disabled: !editMode,
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      child: Text('House'),
                    ),
                    Flexible(
                      child: DropDownButton(
                        disabled: !editMode,
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      child: Text('Parent\'s name'),
                    ),
                    Flexible(
                      child: TextBox(
                        enabled: editMode,
                        controller: _parentName,
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      child: Text('Residence'),
                    ),
                    Flexible(
                      child: TextBox(
                        enabled: editMode,
                        controller: _residence,
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Flexible(
                        fit: FlexFit.tight, child: Text('Parent\'s contact')),
                    Flexible(
                      child: TextBox(
                        enabled: editMode,
                        controller: _parentContact,
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      child: Text('Date of birth'),
                    ),
                    if (editMode)
                      Flexible(
                        child: SizedBox(
                          width: 295,
                          child: DatePicker(
                            selected: dob,
                            onChanged: (v) => setState(() {
                              dob = DateTime(v.year, v.month, v.day);
                            }),
                          ),
                        ),
                      ),
                    if (!editMode)
                      Flexible(
                        child: SizedBox(
                          height: 25,
                          child: Row(
                            children: [
                              Text(parseMonth(dob.month)),
                              const SizedBox(
                                width: 100,
                              ),
                              const m.VerticalDivider(
                                color: m.Colors.grey,
                                width: 1,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(dob.day.toString()),
                              const SizedBox(
                                width: 35,
                              ),
                              const m.VerticalDivider(
                                color: m.Colors.grey,
                                width: 1,
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              Text(dob.year.toString()),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      child: Text('Status'),
                    ),
                    Flexible(
                      child: DropDownButton(
                        disabled: !editMode,
                        title: Text(_status),
                        items: statuses
                            .map(
                              (status) => MenuFlyoutItem(
                                onPressed: () {
                                  setState(() {
                                    _status = status.status;
                                  });
                                },
                                text: Text(status.status),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
