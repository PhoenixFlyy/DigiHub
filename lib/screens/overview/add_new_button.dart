import 'package:flutter/cupertino.dart';

class AddNewButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddNewButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: CupertinoTheme.of(context).barBackgroundColor,
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(CupertinoIcons.add, size: 22), SizedBox(width: 8.0), Text("Hinzufügen")],
      ),
    );
  }
}
