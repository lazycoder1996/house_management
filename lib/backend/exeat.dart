import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/model/exeat.dart';
import 'package:house_management/model/student.dart';

import '../main.dart';

class ExeatProvider extends ChangeNotifier {
  final List<ExeatModel> _exeats = [];

  List<ExeatModel> get exeats => _exeats;

  Future fetchExeats({StudentModel? student}) async {
    if (student == null) _exeats.clear();
    String query =
        "select e.id, e.date_issued, r.name, e.reason, e.destination, "
        "e.expected_return, e.date_returned from exeat e join registration r"
        " on e.std_id=r.std_id";
    if (student != null) query = "$query where e.std_id=${student.id}";
    var res = await connection.mappedResultsQuery(query);
    List<Map<String, dynamic>> singleStudentExeat = [];
    for (final row in res) {
      Map<String, dynamic> exeat = row["exeat"];
      exeat['name'] = row["registration"]['name'];
      if (student != null) {
        singleStudentExeat.add(exeat);
        // return exeat;
      } else {
        _exeats.add(ExeatModel.fromMap(exeat));
      }
    }
    notifyListeners();
    return singleStudentExeat;
  }
}
