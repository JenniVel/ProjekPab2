import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek/models/wisata.dart';
import 'package:projek/screens/home/details_page.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key});

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

  @override
  Widget build(BuildContext context) {

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
                );
            }
            
            final wisataList = snapshot.data!;
            return SizedBox(
              height: 300.0, // Set the height of the Container
              child: FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: ListView.builder(
                  itemCount: wisataList.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final wisataItem = wisataList[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: index * 100),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  wisataId: wisataItem.id!,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              wisataItem.imageUrl != null &&
                                      Uri.parse(wisataItem.imageUrl!).isAbsolute
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        wisataItem.imageUrl!,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        width: 100.0, // Adjust width as needed
                                        height: 100.0,
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    wisataItem.name,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
        }
      },
    );
  }
}
