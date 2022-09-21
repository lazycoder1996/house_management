import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/model/student.dart';
import 'package:house_management/pages/registration/details/exeat/exeat.dart';
import 'package:house_management/pages/registration/details/logistics/logistics.dart';
import 'package:house_management/pages/registration/details/profile.dart';
import 'package:house_management/pages/registration/details/punishment/punishment.dart';
import 'package:house_management/pages/registration/details/roll_call.dart';
import 'package:provider/provider.dart';

class StudentProfile extends StatefulWidget {
  final StudentModel student;

  const StudentProfile({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IconButton(
          icon: const Icon(
            FluentIcons.navigate_forward_mirrored,
            size: 30,
          ),
          onPressed: () {
            Provider.of<Backend>(context, listen: false).clearStudent();
          },
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileRecord(
                student: widget.student,
              ),
              const SizedBox(
                height: 20,
              ),
              ExeatRecord(
                student: widget.student,
              ),
              const SizedBox(
                height: 20,
              ),
              LogisticsRecord(
                student: widget.student,
              ),
              const SizedBox(
                height: 20,
              ),
              RollCallRecord(
                student: widget.student,
              ),
              const SizedBox(
                height: 20,
              ),
              PunishmentRecord(
                student: widget.student,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
