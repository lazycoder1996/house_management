import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/model/student.dart';

class ProfilePicture extends StatelessWidget {
  final StudentModel student;
  final double? height;
  final double? width;
  const ProfilePicture({
    Key? key,
    required this.student,
    this.height = 60,
    this.width = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var names = student.name.split(" ");
    names = [names[0], names[names.length - 1]].map((e) => e[0]).toList();
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: student.picture != null
              ? DecorationImage(image: AssetImage(student.picture!))
              : null),
      child: student.picture == null
          ? CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text(
                names.join(""),
                style: TextStyle(
                  fontSize: height! / 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
