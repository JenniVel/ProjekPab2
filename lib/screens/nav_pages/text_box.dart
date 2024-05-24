import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  final ThemeData theme; // Accept theme as a parameter

  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
    required this.theme, // Add theme as a required parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Section name
              Text(
                sectionName,
                style: TextStyle(
                    color: theme.primaryColor), // Use theme's primary color
              ),
              // Edit button
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.edit,
                  color: theme.primaryColor, // Use theme's primary color
                ),
              ),
            ],
          ),

          // Text
          Text(text, ),
        ],
      ),
    );
  }
}
