import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/model/exeat.dart';
import 'package:house_management/model/logistics.dart';
import 'package:house_management/model/programme.dart';
import 'package:house_management/model/status.dart';

import '../main.dart';
import '../model/house.dart';
import '../model/student.dart';

class Backend extends ChangeNotifier {
  final List<StudentModel> _students = [];

  List<StudentModel> get students => _students;

  final List<ProgrammeModel> _programmes = [];

  List<ProgrammeModel> get programmes => _programmes;

  final List<HouseModel> _houses = [];

  List<HouseModel> get houses => _houses;
  final List<StatusModel> _status = [];

  List<StatusModel> get status => _status;

  bool _isStudentSelected = false;

  bool get isStudentSelected => _isStudentSelected;
  late StudentModel _selectedStudent;

  StudentModel get selectedStudent => _selectedStudent;

  late final List<LogisticsModel> _studentLogistics = [];

  List<LogisticsModel> get studentLogistics => _studentLogistics;

  late final List<ExeatModel> _studentExeat = [];

  List<ExeatModel> get studentExeat => _studentExeat;

  fetchStudentExeat({StudentModel? student}) async {
    _studentExeat.clear();
    String query = "select * from exeat where std_id=${student!.id}";
    var res = await connection.mappedResultsQuery(query);
    for (final row in res) {
      Map<String, dynamic> exeat = row["exeat"];
      _studentExeat.add(ExeatModel.fromMap(exeat));
    }
    notifyListeners();
  }

  fetchStudentLogistics({StudentModel? student}) async {
    _studentLogistics.clear();
    String query = "select * from logistics where std_id=${student!.id}";
    var res = await connection.mappedResultsQuery(query);
    for (final row in res) {
      Map<String, dynamic> logistic = row["logistics"];
      _studentLogistics.add(LogisticsModel.fromMap(logistic));
    }
    notifyListeners();
  }

  fetchStudentPunishment({int? id}) async {}

  setStudent(StudentModel student) {
    _selectedStudent = student;
    _isStudentSelected = true;
    notifyListeners();
  }

  clearStudent() {
    _isStudentSelected = false;
    notifyListeners();
  }

  Future updateStudent({required String query}) async {
    await connection.transaction((ctx) async {
      await ctx.query(query);
    });
    fetchStudents();
  }

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
      _students.add(StudentModel.fromMap(student));
    }
    notifyListeners();
  }

  Future fetchProgrammes() async {
    _programmes.clear();
    var res = await connection.mappedResultsQuery("select * from programme");
    for (final row in res) {
      var programme = row["programme"];
      _programmes
          .add(ProgrammeModel(name: programme['name'], id: programme["id"]));
    }
    notifyListeners();
  }

  Future fetchHouses() async {
    _houses.clear();
    var res = await connection.mappedResultsQuery("select * from house");
    for (final row in res) {
      var house = row["house"];
      _houses.add(HouseModel(
          name: house['name'], id: house["house_id"], color: house["color"]));
    }
    notifyListeners();
  }

  Future fetchStatus() async {
    _status.clear();
    var res = await connection.mappedResultsQuery("select * from status");
    for (final row in res) {
      var status = row["status"];
      _status.add(
        StatusModel(status: status['status'], id: status["id"]),
      );
    }
    notifyListeners();
  }
}
