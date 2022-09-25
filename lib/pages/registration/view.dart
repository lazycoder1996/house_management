import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/pages/registration/add_record.dart';
import 'package:house_management/pages/registration/filter.dart';
import 'package:house_management/pages/registration/profile.dart';
import 'package:provider/provider.dart';

import '../../backend/fetch.dart';
import '../../backend/student.dart';
import 'display_student.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic> filterFields = {
    'year': {
      'fields': {'One': false, 'Two': false, 'Three': false},
      'query': []
    },
    'programme': {'fields': {}, 'query': []},
    'house': {'fields': {}, 'query': []},
    'status': {'fields': {}, 'query': []},
  };

  // connect to database and set data
  addFromDB() async {
    // load programme
    Provider.of<Backend>(context, listen: false)
        .fetchProgrammes()
        .then((value) {
      for (var programme
          in Provider.of<Backend>(context, listen: false).programmes) {
        filterFields['programme']['fields'][programme.name] = false;
      }
    });
    Provider.of<Backend>(context, listen: false).fetchHouses().then((value) {
      for (var house in Provider.of<Backend>(context, listen: false).houses) {
        filterFields['house']['fields'][house.name] = false;
      }
    });
    Provider.of<Backend>(context, listen: false).fetchStatus().then((value) {
      for (var status in Provider.of<Backend>(context, listen: false).status) {
        filterFields['status']['fields'][status.status] = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    addFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, sp, child) {
        return sp.isStudentSelected
            ? StudentProfile(
                student: sp.selectedStudent,
              )
            : ScaffoldPage(
                header: const PageHeader(
                  title: Center(
                    child: Text('Registration'),
                  ),
                ),
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilterWidget(
                      baseQuery:
                          "select * from registration r join house h on lower(r.house)=lower(h.name) ",
                      callBack: (query) async {
                        await Provider.of<StudentProvider>(context,
                                listen: false)
                            .fetchStudents(query: query);
                      },
                      allFields: filterFields,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextBox(
                                  padding: const EdgeInsets.all(10),
                                  controller: _searchController,
                                  prefix: const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Icon(FluentIcons.search),
                                  ),
                                  suffix: IconButton(
                                    icon: const Icon(FluentIcons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      Provider.of<StudentProvider>(context,
                                              listen: false)
                                          .fetchStudents();
                                    },
                                  ),
                                  placeholder: 'Search Here',
                                  onChanged: (st) {
                                    Provider.of<StudentProvider>(context,
                                            listen: false)
                                        .searchStudent(
                                      name: _searchController.text.trim(),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Tooltip(
                                  message: 'Add a student record',
                                  child: IconButton(
                                    icon: const Icon(
                                      FluentIcons.add_to,
                                      size: 40,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) =>
                                              const AddStudentRecord());
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Expanded(child: DisplayStudents()),
                        ],
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
