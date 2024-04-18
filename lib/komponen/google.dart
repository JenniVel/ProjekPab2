import 'package:flutter/material.dart';

class Tombol extends StatelessWidget {
  final String imagePath ;
  const Tombol({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}