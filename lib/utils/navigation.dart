import 'package:fluent_ui/fluent_ui.dart';

toScreen(context, page) {
  Navigator.of(context).push(FluentPageRoute(builder: (context) => page));
}
