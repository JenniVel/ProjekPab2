import 'package:flutter/material.dart';
import 'package:projek/models/tempat_wisata.dart';


class ItemCard extends StatelessWidget {
  //TODO : 1. Deklarasikan variabel yang dibutuhkan dan pasang pada konstruktor
  final Tempat tempat;

  const ItemCard({super.key, required this.tempat});

  @override
  Widget build(BuildContext context) {
    // TODO : 6. Implementasi routing ke DetailScreen. 
    return InkWell(
      onTap: (){},
        child: Card(
          // TODO : 2. Tetapkan parameter shape, margin, dan elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(4),
          elevation: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO : 3. Buat image sebagai anak dari Column
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    tempat.imageAsset,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //TODO : 4. Buat text sebagai anak dari column
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  tempat.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //TODO : 5. Buat text sebagai anak dari column
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  tempat.type,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}