import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/utils/parse_color.dart';
import 'package:provider/provider.dart';

import '../../backend/student.dart';
import '../../model/student.dart';
import '../../widgets/profile_picture.dart';

class StudentCard extends StatelessWidget {
  final StudentModel student;

  const StudentCard({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 200,
      child: GestureDetector(
        onTap: () {
          Provider.of<StudentProvider>(context, listen: false)
              .setStudent(student);
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // row to display picture and name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // picture

                  ProfilePicture(student: student),
                  const SizedBox(
                    width: 10,
                  ),
                  // column for name and house
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // name
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            student.name.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            // maxLines: 2,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          student.house.name,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 10,
              ),
              // class and year
              Row(
                children: [
                  Text(
                    '${student.programme} (${student.year})',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Container(
                    height: 15,
                    width: 15,
                    color: parseColor(student.house.color),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
