import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/utils/format_date.dart';

import '../main.dart';
import '../model/roll_call.dart';
import '../model/student.dart';

class RollCallProvider extends ChangeNotifier {
  Future fetchUniqueDates() async {
    String query = "select distinct(date) from roll_call";
    var res = await connection.mappedResultsQuery(query);
    return List.generate(
        res.length, (index) => formatDate(res[index]['roll_call']['date']));
  }

  final List<RollCallsModel> _rollCalls = [];

  List<RollCallsModel> get rollCalls => _rollCalls;

  Future addRoll({required int stdId, bool? value}) async {
    String query = "insert into roll_call (date, std_id, status) "
        "values (now(), $stdId, ${value ?? false})";
    await connection.transaction((ctx) async {
      await ctx.query(query);
    });
  }

  Future fetchRolls({StudentModel? student, String? query}) async {
    _rollCalls.clear();
    String q = query ??
        "select rc.id, rc.date, rc. status, rc.std_id, r.house from roll_call rc "
            "join registration r on rc.std_id=r.std_id";
    if (student != null) q += " where rc.std_id = ${student.id}";
    var res = await connection.mappedResultsQuery(q);
    for (final row in res) {
      Map<String, dynamic> rollCall = row["registration"];
      rollCall['present'] = row['']['present'];
      rollCall['absent'] = row['']['absent'];
      rollCall['date'] = row['roll_call']['date'];
      _rollCalls.add(RollCallsModel.fromMap(rollCall));
    }
    notifyListeners();
    if (student != null) {
      return List.generate(
        res.length,
        (index) => RollCallModel.fromMap(res[index]["roll_call"]),
      );
    }
  }
}
