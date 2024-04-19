import 'package:flutter/material.dart';

class Tombol extends StatelessWidget {
  final String imagePath ;
  final Function()? onTap;
  const Tombol({
    super.key,
    required this.imagePath,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey[200],
          ),
          child: Image.asset(
            imagePath,
            height: 20,
          ),
      ),
    );
  }
}