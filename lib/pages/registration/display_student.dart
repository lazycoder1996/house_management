import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/pages/registration/student_card.dart';
import 'package:provider/provider.dart';

import '../../model/student.dart';

class DisplayStudents extends StatefulWidget {
  const DisplayStudents({Key? key}) : super(key: key);

  @override
  State<DisplayStudents> createState() => _DisplayStudentsState();
}

class _DisplayStudentsState extends State<DisplayStudents> {
  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  fetchStudents() async {
    await Provider.of<Backend>(context, listen: false).fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Backend>(
      builder: (context, studentProvider, child) {
        return GridView.builder(
          controller: ScrollController(),
          itemCount: studentProvider.students.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            mainAxisExtent: 130,
            mainAxisSpacing: 3,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            StudentModel student = studentProvider.students[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: StudentCard(student: student),
            );
          },
        );
      },
    );
  }
}
