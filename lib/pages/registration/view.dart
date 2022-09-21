import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/pages/registration/add_record.dart';
import 'package:house_management/pages/registration/filter.dart';
import 'package:house_management/pages/registration/profile.dart';
import 'package:provider/provider.dart';

import '../../utils/format_name.dart';
import 'display_student.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Backend>(builder: (context, backend, child) {
      return backend.isStudentSelected
          ? StudentProfile(
              student: backend.selectedStudent,
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
                  const FilterWidget(),
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
                                    Provider.of<Backend>(context, listen: false)
                                        .fetchStudents();
                                  },
                                ),
                                placeholder: 'Search Here',
                                onChanged: (st) {
                                  Provider.of<Backend>(context, listen: false)
                                      .fetchStudents(
                                          query:
                                              "select * from registration r join "
                                              "house h on lower(r.house)=lower(h.name)"
                                              " where r.name ilike '%${formatName(_searchController.text.trim())}%'");
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
    });
  }
}