import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:projek/komponen/like_button.dart';
import 'package:projek/models/wisata.dart';
import 'package:projek/screens/home/details_page.dart';
import 'package:projek/services/favorite_service.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Fungsi callback untuk mengirim informasi perubahan status favorit
  void _updateFavoriteStatus(Wisata wisata, bool isFavorite) {
    // Lakukan apa pun yang diperlukan dengan informasi ini
    print("Favorite status for ${wisata.name} changed to $isFavorite");
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText1?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Favorite",
          style: TextStyle(
            color: theme.primaryColor,
            fontFamily: 'fonts/Inter-Bold.ttf',
            fontSize: 25,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: FadeInUp(
        delay: const Duration(milliseconds: 100),
        child: SizedBox(child: FavoriteList(updateFavoriteStatus: _updateFavoriteStatus)),
      ),
    );
  }
}


class FavoriteList extends StatefulWidget {
  final Function(Wisata, bool) updateFavoriteStatus;

  const FavoriteList({Key? key, required this.updateFavoriteStatus}) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {

  Future<void> _removeFromFavorites(Wisata wisata) async {
  try {
    widget.updateFavoriteStatus(wisata, false);
    await FavoriteService.removeFromFavorites(wisata.id!);
    setState(() {
      wisata.isFavorite = false;
    });

    // Tampilkan snackbar untuk memberi tahu pengguna bahwa item telah dihapus dari favorit
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from favorites'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (error) {
    // Tangani kesalahan jika terjadi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error removing from favorites: $error'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Wisata>>(
      stream: FavoriteService.getFavoritesForUser(),
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
                              builder: (context) => DetailsPage(wisataId: document.id!, updateFavoriteStatus: widget.updateFavoriteStatus),
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
                                    trailing: LikeButton(
                                  isLiked: true,
                                  onTap: () {
                                    _removeFromFavorites(document);
                                  },
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
            );
        }
      },
    );
  }
}
