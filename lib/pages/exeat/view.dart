import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/backend/exeat.dart';
import 'package:house_management/utils/format_date.dart';
import 'package:provider/provider.dart';

class ExeatPage extends StatefulWidget {
  const ExeatPage({Key? key}) : super(key: key);

  @override
  State<ExeatPage> createState() => _ExeatPageState();
}

class _ExeatPageState extends State<ExeatPage> {
  final ScrollController _horizontalAxis = ScrollController();
  final ScrollController _verticalAxis = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchExeats();
  }

  fetchExeats() async {
    await Provider.of<ExeatProvider>(context, listen: false).fetchExeats();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Center(
          child: Text('Exeats'),
        ),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const FilterWidget(),
          // const SizedBox(
          //   width: 10,
          // ),
          Expanded(
            child: Consumer<ExeatProvider>(
              builder: (context, ep, child) {
                return SingleChildScrollView(
                  controller: _verticalAxis,
                  child: SingleChildScrollView(
                    controller: _horizontalAxis,
                    scrollDirection: Axis.horizontal,
                    child: m.DataTable(
                      columns: [
                        'Date',
                        'Name',
                        'Reason',
                        'Destination',
                        'Expected return',
                        'Date returned'
                      ]
                          .map((e) => m.DataColumn(
                                  label: Text(
                                e,
                                overflow: TextOverflow.ellipsis,
                              )))
                          .toList(),
                      rows: ep.exeats
                          .map(
                            (exeats) => m.DataRow(
                              cells: exeats
                                  .toMap()
                                  .values
                                  .skip(1)
                                  .map(
                                    (exeat) => m.DataCell(
                                      SingleChildScrollView(
                                        controller: ScrollController(),
                                        child: Text(
                                          exeat == null
                                              ? ''
                                              : exeat.runtimeType == DateTime
                                                  ? formatDate(exeat)
                                                  : exeat,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
