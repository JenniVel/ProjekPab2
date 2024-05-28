import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projek/models/wisata.dart';

class UjiCobaScreen extends StatefulWidget {
  const UjiCobaScreen({super.key});

  @override
  State<UjiCobaScreen> createState() => _UjiCobaScreenState();
}

class _UjiCobaScreenState extends State<UjiCobaScreen> {
  final Stream<List<Wisata>>? wisataStream = // Replace with your actual Stream/Future
      FirebaseFirestore.instance
          .collection('Destinations') // Replace 'wisata' with your collection name
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Wisata.fromDocument(doc)).toList();
      });

  List<Wisata> allWisata = []; // List to store all Wisata objects
  List<Wisata> filteredWisata = []; // List to store filtered Wisata objects
  String selectedCategory = 'All'; // Default category

  @override
  void initState() {
    super.initState();
    wisataStream!.listen((data) {
      allWisata = data;
      filteredWisata = allWisata;
      setState(() {});
    });
  }

  void filterByCategory(String category) {
    setState(() {
      if (category == 'All') {
        filteredWisata = allWisata;
      } else {
        filteredWisata = allWisata.where((wisata) => wisata.kategori == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Adjust number of tabs based on your categories
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wisata by Category'),
          bottom: TabBar(
            tabs: [
              Tab(child: Text('All')),
              Tab(child: Text('pantai')),
              Tab(child: Text('gunung')),
              Tab(child: Text('perkotaan')), // Add more tabs for other categories
            ],
            onTap: (index) {
              String category;
              switch (index) {
                case 0:
                  category = 'All';
                  break;
                case 1:
                  category = 'pantai';
                  break;
                case 2:
                  category = 'gunung';
                  break;
                case 3:
                  category = 'perkotaan';
                  break;
                default:
                  category = 'All';
              }
              filterByCategory(category);
            },
          ),
        ),
        body: TabBarView(
          children: [
             _wisataListView(wisata: filteredWisata), // All category
            _wisataListView(wisata: filteredWisata.where((wisata) => wisata.kategori == 'pantai').toList()),
            _wisataListView(wisata: filteredWisata.where((wisata) => wisata.kategori == 'gunung').toList()),
            _wisataListView(wisata: filteredWisata.where((wisata) => wisata.kategori == 'danau').toList()),
          ],
        ),
      ),
    );
  }

  Future<ImageProvider> _getImageProvider(String imageUrl) async {
  final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
  try {
    final imageData = await storageRef.getData();
    return MemoryImage(imageData!);
  } catch (error) {
    // Handle errors (e.g., log the error or display a placeholder image)
    print('Error getting image: $error');
    return const AssetImage('assets/placeholder_image.png'); // Replace with placeholder asset
  }
}

  Widget _wisataListView({required List<Wisata> wisata}) {
    return ListView.builder(
      itemCount: wisata.length,
      itemBuilder: (context, index) {
        final wisataItem = wisata[index];
        return InkWell(
          // onTap: () => Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => WisataDetailsPage(wisata: wisataItem),
          //   ),
          // ),
          child:  Card(
      child: Stack(
        children: [
          wisataItem.imageUrl != null && Uri.parse(wisataItem.imageUrl!).isAbsolute
              ? FutureBuilder<ImageProvider>(
                  future: _getImageProvider(wisataItem.imageUrl!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                          return const Center(child: Icon(Icons.error));
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return Image(image: snapshot.data!, fit: BoxFit.cover, width: double.infinity, height: 200.0);
                      },
                    )
                  : Container(color: Colors.grey[200]),
              Positioned(
                    bottom: 10.0,
                    left: 10.0,
                    child: Text(wisataItem.name, style: const TextStyle(color: Colors.white, fontSize: 16.0)),
                  ),
                ],
              ),
            )
        );
          }
    );
  }
}