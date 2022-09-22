import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/model/exeat.dart';
import 'package:house_management/model/item.dart';
import 'package:house_management/model/logistics.dart';
import 'package:house_management/model/programme.dart';
import 'package:house_management/model/status.dart';

import '../main.dart';
import '../model/house.dart';
import '../model/student.dart';

class Backend extends ChangeNotifier {
  final List<ProgrammeModel> _programmes = [];

  List<ProgrammeModel> get programmes => _programmes;

  final List<HouseModel> _houses = [];

  List<HouseModel> get houses => _houses;
  final List<StatusModel> _status = [];

  List<StatusModel> get status => _status;

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

  fetchStudentPunishment({int? id}) async {}

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

  final List<ItemModel> _items = [];

  List<ItemModel> get items => _items;

  Future fetchItems() async {
    _items.clear();
    var res = await connection.mappedResultsQuery("select * from items");
    for (final row in res) {
      var item = row["items"];
      _items.add(ItemModel.fromMap(item));
    }
    notifyListeners();
  }
}
