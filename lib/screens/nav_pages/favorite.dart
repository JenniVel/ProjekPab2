import 'package:flutter/material.dart';
import 'package:projek/models/people_also_like_mode.dart';
import 'package:projek/screens/widgets/wisata_widget.dart';

class FavoritePage extends StatefulWidget {
  final List<PeopleAlsoLikeModel> favoriteWisata;
  const FavoritePage({Key? key, required this.favoriteWisata})
      : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background untuk menutupi layar ketika daftar kosong
          Container(
            color: Theme.of(context).backgroundColor,
            width: size.width,
            height: size.height,
          ),
          // Positioned untuk teks "Favorite" di kiri atas
          if (widget.favoriteWisata.isNotEmpty)
            const Positioned(
              top: 20,
              left: 20,
              child: Text(
                'Favorite',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue,
                ),
              ),
            ),
          // ListView.builder
          widget.favoriteWisata.isEmpty
              ? const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Icon(
                          Icons.favorite,
                          size: 90.0,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Your Favorited Locations',
                        style: TextStyle(
                          fontFamily: 'fonts/Inter-Black.ttf',
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                      top: 70), // Sesuaikan jarak sesuai kebutuhan
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: size.height * .5,
                  child: ListView.builder(
                      itemCount: widget.favoriteWisata.length,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return WisataWidget(
                          index: index,
                          combinedPeopleAlsoLikeModelList:
                              widget.favoriteWisata,
                        );
                      }),
                ),
          Positioned(
            bottom: 20,
            left: size.width * 0.5 - 195,
            width: 385,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  for (var item in widget.favoriteWisata) {
                    item.isFavorite = false;
                  }
                  widget.favoriteWisata.clear();
                  isEmpty = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Hapus Semua',
                  style: TextStyle(fontSize: 16.0, color: Colors.blue.shade50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
