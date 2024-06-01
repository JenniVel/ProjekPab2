import 'package:flutter/material.dart';

class ReadOnlyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final Color color;
  final IconData icon;

  const ReadOnlyTextBox({
    Key? key,
    required this.text,
    required this.sectionName,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyText1?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        onPressed: () {}, // Add functionality if needed
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sectionName,
                    style: TextStyle(
                      fontFamily: 'fonts/Inter-Black.ttf',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(text,
                      style: TextStyle(
                        color: textColor,
                        fontFamily: 'fonts/Inter-Black.ttf',
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
