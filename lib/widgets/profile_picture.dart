import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/model/student.dart';

class ProfilePicture extends StatelessWidget {
  final StudentModel student;
  final String? names;
  final double? height;
  final double? width;
  const ProfilePicture({
    Key? key,
    required this.student,
    this.height = 60,
    this.names,
    this.width = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _names = names != null ? names!.split(" ") : student.name.split(" ");
    _names = [_names[0], _names[_names.length - 1]]
        .map((e) => e[0].toUpperCase())
        .toList();
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
                _names.join(""),
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
