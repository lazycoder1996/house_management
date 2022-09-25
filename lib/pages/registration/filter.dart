import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/utils/to_title_case.dart';

class FilterWidget extends StatefulWidget {
  final Map<String, dynamic>? allFields;
  final String? baseQuery;
  final Function? callBack;
  final String? title;

  const FilterWidget({
    Key? key,
    this.allFields,
    this.title,
    this.baseQuery,
    this.callBack,
  }) : super(key: key);

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
  // addFromDB() async {
  //   // load programme
  //   Provider.of<Backend>(context, listen: false)
  //       .fetchProgrammes()
  //       .then((value) {
  //     for (var programme
  //         in Provider.of<Backend>(context, listen: false).programmes) {
  //       byProgramme['fields'][programme.name] = false;
  //     }
  //   });
  //   Provider.of<Backend>(context, listen: false).fetchHouses().then((value) {
  //     for (var house in Provider.of<Backend>(context, listen: false).houses) {
  //       byHouse['fields'][house.name] = false;
  //     }
  //   });
  //   Provider.of<Backend>(context, listen: false).fetchStatus().then((value) {
  //     setState(() {
  //       for (var status
  //           in Provider.of<Backend>(context, listen: false).status) {
  //         byStatus['fields'][status.status] = false;
  //       }
  //     });
  //   });
  // }

  toggles(String header, Map<String, dynamic> initValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 5),
          child: Text(
            toTitle(header),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ...initValues['fields'].keys.map((e) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 5),
            child: Checkbox(
              content: Text(toTitle(e)),
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
    widget.callBack!(formQuery());
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
    Map<String, String> joinedQuery = {};
    String queryString = widget.baseQuery!;
    List<String> fields = [];
    if (widget.allFields != null) {
      for (var i in widget.allFields!.keys) {
        joinedQuery[i] = widget.allFields![i]['query'].join(", ");
      }
      fields = joinedQuery.values.toList();
      if (!isEmpty(fields)) {
        queryString = "$queryString where ";
      }
      joinedQuery.forEach((key, value) {
        if (value.isNotEmpty) {
          queryString =
              "$queryString$key in ($value)${apartFrom(fields, value) ? " and " : ""}";
        }
      });
    }
    if (widget.title != null) {
      queryString = "$queryString ${widget.title}";
    }
    return queryString;
  }

  @override
  void initState() {
    super.initState();
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
                  ],
                ),
              ),
              if (widget.allFields != null)
                ...widget.allFields!.keys.map(
                  (e) => toggles(
                    e,
                    widget.allFields![e],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
