import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projek/models/wisata.dart';

class FavoriteService {

  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _DestinationsCollection =
      _database.collection('Destinations');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<void> addToFavorites(Wisata wisata) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Destination_favorites').doc(wisata.id);
      await docRef.set({
        'name': wisata.name,
        'description': wisata.description,
        'harga': wisata.harga,
        'kategori': wisata.kategori,
        'image_url': wisata.imageUrl,
        'created_at': wisata.createdAt,
        'updated_at': wisata.updatedAt,
        'isFavorite': wisata.isFavorite,
      });

      
    } catch (error) {
      print("Error adding to favorites: $error");
    }
  }

  static Future<void> removeFromFavorites(String wisataId) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Destination_favorites').doc(wisataId);
      await docRef.delete();
    } catch (error) {
      print("Error removing from favorites: $error");
    }
  }
}
