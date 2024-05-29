import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek/komponen/like_button.dart';
import 'package:projek/models/wisata.dart';
import 'package:projek/screens/home/details_page.dart';
import 'package:projek/screens/widgets/reuseable_text.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Stream<List<Wisata>> _getFavoriteWisataStream() {
    return FirebaseFirestore.instance
        .collection('Destination_favorites')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Wisata.fromDocument(doc)).toList());
  }

  Future<ImageProvider> _getImageProvider(String url) async {
    return NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder<List<Wisata>>(
      stream: _getFavoriteWisataStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No favorite destinations available'),
              );
            }
            final wisataList = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: wisataList.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final wisataItem = wisataList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsPage(wisataId: wisataItem.id!),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Hero(
                        tag: wisataItem.id!,
                        child: wisataItem.imageUrl != null &&
                                Uri.parse(wisataItem.imageUrl!).isAbsolute
                            ? FutureBuilder<ImageProvider>(
                                future:
                                    _getImageProvider(wisataItem.imageUrl!),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(
                                        child: Icon(Icons.error));
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  return Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.network(
                                            wisataItem.imageUrl!,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            width:
                                                200.0, // Adjust width as needed
                                            height: 300.0,
                                          )),
                                      SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  );
                                },
                              )
                            : Container(color: Colors.grey[200]),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: size.height * 0.2,
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: size.width,
                          height: size.height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(153, 0, 0, 0),
                                Color.fromARGB(118, 29, 29, 29),
                                Color.fromARGB(54, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: size.width * 0.07,
                        bottom: size.height * 0.045,
                        child: AppText(
                          text: wisataItem.name,
                          size: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Positioned(
                        left: size.width * 0.07,
                        bottom: size.height * 0.025,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            AppText(
                              text: "Lokasi",
                              size: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
        }
      },
    );
  }
}
