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
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText1?.color ?? Colors.black;

    return Scaffold(
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
       appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Favorite", style: TextStyle(color: textColor)),
        backgroundColor: theme.backgroundColor,
      ),
      body: FadeInUp(
        delay: const Duration(milliseconds: 100),
        child: const SizedBox(
          child: FavoriteList()
          )
          )
    );
  }
}


class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

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
                child: Text('No destinations available'),
              );
            }

            final data = snapshot.data!;
            return FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final document = data[index];
                  return FadeInUp(
                    delay: Duration(
                        milliseconds: index * 100), // Stagger animations
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(wisataId: document.id!),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            document.imageUrl != null &&
                                    Uri.parse(document.imageUrl!).isAbsolute
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.network(
                                      document.imageUrl!,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      width: 100.0, // Adjust width as needed
                                      height: 100.0,
                                    ),
                                  )
                                : Container(), // Handle cases where image URL is not available
                            const SizedBox(
                                width:
                                    10.0), // Add spacing between image and text
                            Expanded(
                              // Text takes remaining space
                              child: ListTile(
                                title: Text(document.name,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
        }
      },
    );
  }
}