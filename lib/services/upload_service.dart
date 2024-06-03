import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:projek/models/wisata.dart';
import 'package:path/path.dart' as path;

class UploadService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _DestinationsCollection = _database.collection('Destinations');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to upload an image to Firebase Storage
  static Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('images/$fileName');

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(imageFile);
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // Method to add a new destination to Firestore
  static Future<void> addDestination(Wisata wisata) async {
    Map<String, dynamic> newDestination = {
      'name': wisata.name,
      'description': wisata.description,
      'harga': wisata.harga,
      'kategori': wisata.kategori,
      'image_url': wisata.imageUrl,
      'latitude': wisata.latitude,
      'longitude': wisata.longitude,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'isFavorite': false,
    };
    await _DestinationsCollection.add(newDestination);
  }

  // Method to update an existing destination in Firestore
  static Future<void> updateDestination(Wisata wisata) async {
    Map<String, dynamic> updatedDestination = {
      'name': wisata.name,
      'description': wisata.description,
      'harga': wisata.harga,
      'kategori': wisata.kategori,
      'image_url': wisata.imageUrl,
      'latitude': wisata.latitude,
      'longitude': wisata.longitude,
      'created_at': wisata.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
      'isFavorite': false,
    };

    await _DestinationsCollection.doc(wisata.id).update(updatedDestination);
  }

  // Method to delete a destination from Firestore
  static Future<void> deleteDestination(Wisata wisata) async {
    await _DestinationsCollection.doc(wisata.id).delete();
  }

  // Method to retrieve all destinations from Firestore
  static Future<QuerySnapshot> retrieveDestinations() {
    return _DestinationsCollection.get();
  }

  // Method to get a stream of destination list from Firestore
  static Stream<List<Wisata>> getDestinationList() {
    return _DestinationsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Wisata(
          id: doc.id,
          name: data['name'],
          description: data['description'],
          harga: data['harga'],
          kategori: data['kategori'],
          imageUrl: data['image_url'],
          createdAt: data['created_at'] != null ? data['created_at'] as Timestamp : null,
          updatedAt: data['updated_at'] != null ? data['updated_at'] as Timestamp : null, 
          latitude: data['latitude'], 
          longitude: data['longitude'],
          isFavorite: data['isFavorite'],
        );
      }).toList();
    });
  }

  Future<Wisata> getDestinationById(String id) async {
    DocumentSnapshot doc = await _database.collection('Destinations').doc(id).get();
    if (doc.exists) {
      return Wisata.FromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } else {
      throw Exception('Destination not found');
    }
  }

  Future<void> updateDestinationRating(String DestinationId, double rating) async {
    try {
      await _database.collection('Destinations').doc(DestinationId).update({
        'rating': rating,
      });
    } catch (e) {
      print('Error updating Destination rating: $e');
    }
  }

  // Method to add a comment to a destination
  static Future<void> addComment(String destinationId, String comment, String userId) async {
    // Reference to the comments sub-collection for a specific destination
    CollectionReference commentsCollection = _DestinationsCollection.doc(destinationId).collection('Comments');

    // Map representing the comment data
    Map<String, dynamic> newComment = {
      'comment': comment,
      'user_id': userId,
      'created_at': FieldValue.serverTimestamp(),
    };

    // Add the new comment to the comments sub-collection
    await commentsCollection.add(newComment);
  }

  // Method to retrieve comments for a specific destination
  static Future<QuerySnapshot> getComments(String destinationId) {
    // Get all comments from the comments sub-collection for the specified destination
    return _DestinationsCollection.doc(destinationId).collection('Comments').get();
  }
}