import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/model/student.dart';

import '../main.dart';
import '../model/logistics.dart';

class LogisticsProvider extends ChangeNotifier {
  final List<LogisticsModel> _logistics = [];

  List<LogisticsModel> get logistics => _logistics;

  fetchLogistics({StudentModel? student}) async {
    if (student == null) _logistics.clear();
    String query =
        "select l.date, r.name, r.house, l.items from logistics l join registration r on l.std_id=r.std_id";
    if (student != null) query = "$query where r.std_id=${student.id}";
    var res = await connection.mappedResultsQuery(query);
    for (final row in res) {
      Map<String, dynamic> logistic = row["logistics"];
      logistic['name'] = row["registration"]['name'];
      logistic['house'] = row["registration"]['house'];
      if (student != null) {
        return logistic;
      }
      _logistics.add(LogisticsModel.fromMap(logistic));
    }
    notifyListeners();
  }
}
