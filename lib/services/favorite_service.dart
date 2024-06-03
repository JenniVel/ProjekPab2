import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek/models/wisata.dart';

class FavoriteService {
  static Future<void> addToFavorites(Wisata wisata) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      final userId = user.uid;
      final docRef = FirebaseFirestore.instance
          .collection('Destination_favorites')
          .doc('${wisata.id}');

      await docRef.set({
        'userId': userId,
        'name': wisata.name,
        'description': wisata.description,
        'harga': wisata.harga,
        'kategori': wisata.kategori,
        'image_url': wisata.imageUrl,
        'created_at': wisata.createdAt,
        'updated_at': wisata.updatedAt,
        'isFavorite': wisata.isFavorite,
        'latitude': wisata.latitude,
        'longitude': wisata.longitude,
      });

      print("Added to favorites successfully.");
    } catch (error) {
      print("Error adding to favorites: $error");
      // Consider using a logging service or showing a user-friendly message
    }
  }

  static Future<void> removeFromFavorites(String wisataId) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    final userId = user.uid;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Destination_favorites')
        .where('userId', isEqualTo: userId)
        .where(FieldPath.documentId, isEqualTo: '${wisataId}')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print("Removed from favorites successfully.");
    } else {
      print("Document not found in favorites.");
    }
  } catch (error) {
    print("Error removing from favorites: $error");
    // Tangani kesalahan secara lebih spesifik
  }
}


  static Stream<List<Wisata>> getFavoritesForUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    final userId = user.uid;
    return FirebaseFirestore.instance
        .collection('Destination_favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Wisata.fromDocument(doc)).toList());
  }
}
