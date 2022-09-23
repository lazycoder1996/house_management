import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/backend/exeat.dart';
import 'package:house_management/backend/logistic.dart';
import 'package:house_management/model/exeat.dart';
import 'package:house_management/model/student.dart';
import 'package:house_management/utils/to_title_case.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/logistics.dart';
import '../model/punishment.dart';

class StudentProvider extends ChangeNotifier {
  final List<StudentModel> _students = [];

  List<StudentModel> get students => _students;

  Future addStudent({
    required name,
    required programme,
    required house,
    required parentName,
    required residence,
    required contact,
    required dob,
    required status,
  }) async {
    await connection.transaction((ctx) async {
      await ctx.query("insert into registration"
          "(name, programme, house, parent_name, residence, contact, \"DOB\", status) "
          "values ('$name', '$programme', "
          "'$house', '$parentName', '$residence', '$contact', "
          "'$dob', '$status')");
    }).then((val) {
      fetchStudents();
    });
  }

  late final List<LogisticsModel> _studentLogistics = [];

  List<LogisticsModel> get studentLogistics => _studentLogistics;

  Future addLogistics({
    required StudentModel student,
    required List<String> items,
    required BuildContext context,
  }) async {
    String query = "insert into logistics (std_id, date, items)"
        "values (${student.id}, now(), array[${items.join(", ")}])";
    await connection.transaction((ctx) async {
      await ctx.query(query);
    });
    fetchLogistics(student: student, context: context);
  }

  Future fetchLogistics(
      {required StudentModel student, required BuildContext context}) async {
    _studentLogistics.clear();
    var logistics = await Provider.of<LogisticsProvider>(context, listen: false)
        .fetchLogistics(student: student);
    if (logistics != null) {
      _studentLogistics.add(LogisticsModel.fromMap(logistics));
    }
    notifyListeners();
  }

  Future updateLogistics(
      {required StudentModel student,
      required items,
      required BuildContext context}) async {
    String query =
        "update logistics set items = array_cat(items, ARRAY[${items.join(", ")}]) where std_id=${student.id}";
    await connection.transaction((ctx) async {
      await ctx.query(query);
    });
    fetchLogistics(student: student, context: context);
  }

  final List<PunishmentModel> _studentPunishments = [];

  List<PunishmentModel> get studentPunishments => _studentPunishments;

  fetchPunishment({required StudentModel student}) async {
    String query = "select * from punishment where std_id = ${student.id}";
    var res = await connection.mappedResultsQuery(query);
    for (final row in res) {
      Map<String, dynamic> punishment = row["punishment"];
      _studentPunishments.add(PunishmentModel.fromMap(punishment));
    }
    notifyListeners();
  }

  final List<ExeatModel> _studentExeats = [];

  List<ExeatModel> get exeats => _studentExeats;

  Future addExeat({
    required StudentModel student,
    required Map<String, dynamic> values,
    required BuildContext context,
  }) async {
    String query =
        "insert into exeat (std_id, date_issued, reason, destination, expected_return) "
        "values (${student.id} ,now(), '${values['reason']}', '${values['destination']}', "
        "'${values['expected_return']}')";
    await connection.transaction((ctx) async {
      await ctx.query(query);
    }).then((v) async {
      query =
          "update registration set status = 'absent with exeat' where std_id=${student.id}";
      await connection.transaction((ctx) async {
        await ctx.query(query);
      });
    });
    Map<String, dynamic> s = _selectedStudent.toMap();
    s['status'] = 'absent with exeat';
    _selectedStudent = StudentModel.fromMap(s);
    await fetchExeats(student: student, context: context);
    notifyListeners();
  }

  Future updateExeat(
      {required BuildContext context,
      required DateTime returnDate,
      required ExeatModel exeat,
      required StudentModel student}) async {
    String query =
        "update exeat set date_returned = '$returnDate' where id = ${exeat.id}";
    await connection.transaction((ctx) async {
      await ctx.query(query);
    }).then((v) async {
      query =
          "update registration set status = 'in school' where std_id=${student.id}";
      await connection.transaction((ctx) async {
        await ctx.query(query);
      });
    });
    Map<String, dynamic> s = _selectedStudent.toMap();
    s['status'] = 'in school';
    _selectedStudent = StudentModel.fromMap(s);
    await fetchExeats(student: student, context: context);
    notifyListeners();
  }

  Future fetchExeats(
      {required StudentModel student, required BuildContext context}) async {
    _studentExeats.clear();
    List<Map<String, dynamic>> exeats =
        await Provider.of<ExeatProvider>(context, listen: false)
            .fetchExeats(student: student);
    if (exeats.isNotEmpty) {
      for (var exeat in exeats) {
        _studentExeats.add(ExeatModel.fromMap(exeat));
      }
    }
    notifyListeners();
  }

  late StudentModel _selectedStudent;
  bool _isStudentSelected = false;

  bool get isStudentSelected => _isStudentSelected;

  StudentModel get selectedStudent => _selectedStudent;

  setStudent(StudentModel student) {
    _selectedStudent = student;
    _isStudentSelected = true;
    notifyListeners();
  }

  clearStudent() {
    _isStudentSelected = false;
    notifyListeners();
  }

  Future searchStudent({String? name}) async {
    String query = "select * from registration r join "
        "house h on lower(r.house)=lower(h.name)"
        " where r.name ilike '%$name%'";
    await fetchStudents(query: query);
  }

  Future fetchStudents({
    int? id,
    String? query,
  }) async {
    _students.clear();
    var res = await connection.mappedResultsQuery(
      query ??
          "select * from registration r join house h on lower(r.house)=lower(h.name) ${id != null ? "where std_id = $id" : ""}",
    );
    for (final row in res) {
      Map<String, dynamic> student = row["registration"];
      student['house'] = row['house'];
      student['name'] = toTitle(student['name']);
      _students.add(StudentModel.fromMap(student));
    }
    notifyListeners();
  }

  Future updateStudent({
    required id,
    required name,
    required programme,
    required house,
    required parentName,
    required residence,
    required contact,
    required dob,
    required status,
  }) async {
    String query = "update registration set "
        "name=coalesce('$name', name),"
        "house=coalesce('$house', house),"
        "programme=coalesce('$programme',programme),"
        "parent_name=coalesce('$parentName',parent_name),"
        "residence=coalesce('$residence',residence),"
        "contact=coalesce('$contact',contact),"
        "\"DOB\"=coalesce('$dob',\"DOB\"),"
        "status=coalesce('$status',status) "
        "where std_id = $id";
    await connection.transaction((ctx) async {
      await ctx.query(query);
    });
    fetchStudents();
  }
}
