import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:house_management/backend/logistic.dart';
import 'package:house_management/utils/format_date.dart';
import 'package:house_management/utils/to_title_case.dart';
import 'package:provider/provider.dart';

import '../registration/filter.dart';

class LogisticsPage extends StatefulWidget {
  const LogisticsPage({Key? key}) : super(key: key);

  @override
  State<LogisticsPage> createState() => _LogisticsPageState();
}

class _LogisticsPageState extends State<LogisticsPage> {
  @override
  void initState() {
    super.initState();
    fetchLogistics();
  }

  fetchLogistics() async {
    await Provider.of<LogisticsProvider>(context, listen: false)
        .fetchLogistics();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Center(
          child: Text('Logistics'),
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
            child: Consumer<LogisticsProvider>(builder: (context, lp, child) {
              return SingleChildScrollView(
                controller: ScrollController(),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  scrollDirection: Axis.horizontal,
                  child: m.DataTable(
                    columns: ['Date', 'Name', 'House', 'Items']
                        .map(
                          (e) => m.DataColumn(
                            label: Text(e),
                          ),
                        )
                        .toList(),
                    rows: lp.logistics
                        .map(
                          (row) => m.DataRow(
                            cells: [
                              formatDate(row.date),
                              toTitle(row.name),
                              row.house,
                              row.items!.join(", ")
                            ]
                                .map(
                                  (e) => m.DataCell(
                                    SingleChildScrollView(
                                      controller: ScrollController(),
                                      child: Text(e),
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
            }),
          ),
        ],
      ),
    );
  }
}
