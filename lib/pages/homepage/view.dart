import 'package:fluent_ui/fluent_ui.dart';
import 'package:house_management/pages/logistics/view.dart';
import 'package:house_management/pages/registration/view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List<Widget> pages = const [
    SizedBox(),
    RegistrationPage(),
    LogisticsPage(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: NavigationBody.builder(
          index: selectedIndex,
          itemBuilder: (context, index) {
            return pages[index];
          }),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (i) => setState(() => selectedIndex = i),
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItem(
              icon: const Icon(FluentIcons.home), title: const Text('Home')),
          PaneItem(
              icon: const Icon(FluentIcons.open_enrollment),
              title: const Text('Registration')),
          PaneItem(
              icon: const Icon(FluentIcons.broom),
              title: const Text('Logistics')),
          PaneItem(
              icon: const Icon(FluentIcons.out_of_office),
              title: const Text('Exeat')),
          PaneItem(
              icon: const Icon(FluentIcons.count),
              title: const Text('Roll call')),
          PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('Settings')),
        ],
      ),
    );
  }
}
