import 'package:fluent_ui/fluent_ui.dart';

class DiscardContentDialog extends StatelessWidget {
  const DiscardContentDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      actions: [
        Button(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Yes'),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }),
        Button(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No'),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
      title: const Text('Discard Changes?'),
      content: const Text('Are you sure you want to discard changes?'),
    );
  }
}
