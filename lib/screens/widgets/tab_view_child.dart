import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../models/wisata.dart';
import '../../services/upload_service.dart';
import '../home/details_page.dart';
import 'reuseable_text.dart';

class TabViewChild extends StatelessWidget {
  final List<Wisata> wisata;

  const TabViewChild({Key? key, required this.wisata}) : super(key: key);

  Future<ImageProvider> _getImageProvider(String imageUrl) async {
    final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
    try {
      final imageData = await storageRef.getData();
      return MemoryImage(imageData!);
    } catch (error) {
      // Handle errors (e.g., log the error or display a placeholder image)
      print('Error getting image: $error');
      return const AssetImage(
          'assets/placeholder_image.png'); // Replace with placeholder asset
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder<List<Wisata>>(
      stream: UploadService.getDestinationList(),
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
                child: Text('No destinations available'),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: wisata.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final wisataItem = wisata[index];
                return GestureDetector(
                  onTap: () { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsPage(wisataId: wisataItem.id!),
                    ),
                  );},
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Hero(
                        tag: wisataItem.id!,
                        child: wisataItem.imageUrl != null &&
                                Uri.parse(wisataItem.imageUrl!).isAbsolute
                            ? FutureBuilder<ImageProvider>(
                                future: _getImageProvider(wisataItem.imageUrl!),
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
                        bottom: size.height * 0.025,
                        child: AppText(
                          text: wisataItem.name,
                          size: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
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
