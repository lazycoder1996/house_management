import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/constants/prefs.dart';
import 'package:house_management/pages/auth/login_page.dart';
import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/fetch.dart';

late SharedPreferences prefs;
late var connection;

void main() {
  init().then((value) {
    runApp(const MyApp());
  });
}

// LOAD DATA FROM SHARED PREFERENCES
Future init() async {
  prefs = await SharedPreferences.getInstance();
  connection = PostgreSQLConnection("localhost", 5432, "2021/22",
      username: "postgres", password: "q1w2e3r4t5y6");
  await connection.open().then((value) async {
    print('connection opened');
    await connection.transaction((ctx) async {
      await ctx.query("set search_path to sem1");
    });
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  // CHECK IF LOGGED IN FROM SHARED PREFERENCES
  Future _init() async {}

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Prefs()),
        ChangeNotifierProvider(create: (context) => Backend()),
      ],
      child: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Prefs>(builder: (context, prefs, child) {
      return FluentApp(
        debugShowCheckedModeBanner: false,
        themeMode: prefs.themeMode,
        theme: ThemeData(
          buttonTheme: ButtonThemeData(
            textButtonStyle: ButtonStyle(
              foregroundColor: ButtonState.all(Colors.black),
            ),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          buttonTheme: ButtonThemeData(
            textButtonStyle: ButtonStyle(
              foregroundColor: ButtonState.all(Colors.white),
            ),
          ),
        ),
        title: 'House Management',
        home: const LoginPage(),
      );
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:house_management/utils/format_date.dart';
// import 'package:postgres/postgres.dart';
//
//
// void main() {
//   init().then((value) {
//     runApp(const MyApp());
//   });
// }
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Demo',
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<List<String>> rows = [];
//
// Future returnLogistics() async {
//   List<
//       Map<
//           String,
//           Map<String,
//               dynamic>>> logistics = await connection.mappedResultsQuery(
//       "        select l.date, l.std_id, r.name, l.class, r.house, l.track, r.picture, l.items "
//       "from logistics l join registration r on l.std_id = r.std_id");
//   print(logistics);
//   setState(() {
//     rows.clear();
//     for (final row in logistics) {
//       var items = row["logistics"]!["items"];
//       rows.add([
//         row["logistics"]!["std_id"].toString(),
//         row["registration"]!["name"],
//         formatDate(row["logistics"]!["date"]),
//         row["logistics"]!["class"],
//         row["registration"]!["house"],
//         row["logistics"]!["track"],
//         items != null ? items.join(", ") : "",
//       ]);
//     }
//   });
//   print(rows);
// }
//
//   Future addToLogistics() async {
//     await connection.transaction((ctx) async {
//       await ctx.query(
//         "insert into  logistics (std_id, date, class, track, picture)"
//         "values (3, now(), '1SC2', 'Green', 'www.google.com')",
//       );
//     });
//   }
//
//   Future updateLogistics(array, id) async {
//     await connection.transaction((ctx) async {
//       await ctx.query(
//         "update  logistics set items = array_cat(items, @_array) where std_id=@id",
//         substitutionValues: {"_array": array, "id": id},
//       );
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     returnLogistics();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Container(
//         child: DataTable(
//           columns: ['ID', 'NAME', 'DATE', 'CLASS', 'HOUSE', 'TRACK', 'ITEMS']
//               .map((header) => DataColumn(label: Text(header)))
//               .toList(),
//           rows: rows
//               .map((row) => DataRow(
//                   cells: row.map((cell) => DataCell(Text(cell))).toList()))
//               .toList(),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await updateLogistics(["hoe", "rake"], 3)
//               .then((value) => returnLogistics());
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
