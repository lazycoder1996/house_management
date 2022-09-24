import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/backend/fetch.dart';
import 'package:house_management/backend/student.dart';
import 'package:provider/provider.dart';

import '../../utils/parse_color.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool showFilter = true;
  Map<String, dynamic> byYear = {
    'fields': {
      'One': false,
      'Two': false,
      'Three': false,
    },
    'query': []
  };
  Map<String, dynamic> byProgramme = {'fields': {}, 'query': []};
  Map<String, dynamic> byHouse = {'fields': {}, 'query': []};
  Map<String, dynamic> byStatus = {'fields': {}, 'query': []};

  // connect to database and set data
  addFromDB() async {
    // load programme
    Provider.of<Backend>(context, listen: false)
        .fetchProgrammes()
        .then((value) {
      for (var programme
          in Provider.of<Backend>(context, listen: false).programmes) {
        byProgramme['fields'][programme.name] = false;
      }
    });
    Provider.of<Backend>(context, listen: false).fetchHouses().then((value) {
      for (var house in Provider.of<Backend>(context, listen: false).houses) {
        byHouse['fields'][house.name] = false;
        byHouse["color"] = parseColor(house.color);
      }
    });
    Provider.of<Backend>(context, listen: false).fetchStatus().then((value) {
      setState(() {
        for (var status
            in Provider.of<Backend>(context, listen: false).status) {
          byStatus['fields'][status.status] = false;
        }
      });
    });
  }

  toggles(String header, Map<String, dynamic> initValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 5),
          child: Text(
            header,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ...initValues['fields'].keys.map((e) {
          return e == "color"
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5),
                  child: Checkbox(
                    content: Text(e),
                    checked: initValues['fields'][e],
                    onChanged: (b) => setState(() {
                      initValues['fields'][e] = b!;
                      addToQuery(initValues, e);
                    }),
                  ),
                );
        }).toList(),
      ],
    );
  }

  addToQuery(Map<String, dynamic> v, e) {
    if (v['query'].contains("'$e'")) {
      v['query'].remove("'$e'");
    } else {
      v['query'].add("'$e'");
    }
    Provider.of<StudentProvider>(context, listen: false)
        .fetchStudents(query: formQuery());
  }

  isEmpty(List<String> strings) {
    for (String str in strings) {
      if (str.isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  apartFrom(List<String> strings, String removeString) {
    strings.remove(removeString);
    return !isEmpty(strings);
  }

  formQuery() {
    String queryString =
        "select * from registration r join house h on lower(r.house)=lower(h.name) ";
    String _byHouse = byHouse['query'].join(" , ");
    String _byYear = byYear['query'].join(" , ");
    String _byProgramme = byProgramme['query'].join(" , ");
    String _byStatus = byStatus['query'].join(" , ");
    List<String> fields = [_byProgramme, _byHouse, _byStatus, _byYear];
    if (!isEmpty(fields)) {
      queryString = "$queryString where ";
    }
    if (_byHouse.isNotEmpty) {
      queryString =
          "${queryString}house in ($_byHouse)${apartFrom(fields, _byHouse) ? " and " : ""}";
    }
    if (_byYear.isNotEmpty) {
      queryString =
          "${queryString}year in ($_byYear)${apartFrom(fields, _byYear) ? " and " : ""}";
    }
    if (_byProgramme.isNotEmpty) {
      queryString =
          "${queryString}programme in ($_byProgramme)${apartFrom(fields, _byProgramme) ? " and " : ""}";
    }
    if (_byStatus.isNotEmpty) {
      queryString =
          "${queryString}status in ($_byStatus)${apartFrom(fields, _byStatus) ? " and " : ""}";
    }
    return queryString;
  }

  @override
  void initState() {
    super.initState();
    addFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: showFilter ? 1.0 : 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    TextButton(
                      onPressed: null,
                      child: Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 14,
                          // color: Colors.black,
                        ),
                      ),
                    ),
                    // if (showFilter) ...[
                    //   const Spacer(),
                    //   IconButton(
                    //     icon: const Icon(FluentIcons.cancel),
                    //     onPressed: () => setState(() {
                    //       showFilter = false;
                    //     }),
                    //   ),
                    // ]
                  ],
                ),
              ),
              // if (showFilter) ...[
              toggles('Year', byYear),
              toggles('Programme', byProgramme),
              toggles('House', byHouse),
              toggles('Status', byStatus),
              // ]
            ],
          ),
        ),
      ),
    );
  }
}
