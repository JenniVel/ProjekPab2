import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projek/models/review.dart';

class ReviewService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _reviewsCollection =
      _database.collection('reviews');

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('images/$fileName');

      UploadTask uploadTask; //upload ke ref yg dituju
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

  static Future<void> addReview(Review reviews) async {
    Map<String, dynamic> newReview = {
      'title': reviews.title,
      'comment': reviews.comment,
      'image_url': reviews.imageUrl,
      'rating': reviews.rating,
      'location': reviews.location,
      'latitude': reviews.latitude,
      'longitude': reviews.longitude,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _reviewsCollection.add(newReview);
  }

  static Future<void> updateReview(Review reviews) async {
    Map<String, dynamic> updatedReview = {
      'title': reviews.title,
      'comment': reviews.comment,
      'image_url': reviews.imageUrl,
      'rating': reviews.rating,
      'location': reviews.location,
      'latitude': reviews.latitude,
      'longitude': reviews.longitude,
      'created_at': reviews.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _reviewsCollection.doc(reviews.id).update(updatedReview);
  }

  static Future<void> deleteReview(Review reviews) async {
    await _reviewsCollection.doc(reviews.id).delete();
  }

  static Future<QuerySnapshot> retrieveReviews() {
    return _reviewsCollection.get();
  }

  static Stream<List<Review>> getReviewList() {
    return _reviewsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Review(
          id: doc.id,
          title: data['title'],
          comment: data['comment'],
          imageUrl: data['image_url'],
          rating: data['rating'] ?? 0.0,
          location: data['location'],
          latitude:
              data['latitude'] != null ? data['latitude'] as double : null,
          longitude:
              data['longitude'] != null ? data['longitude'] as double : null,
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
        );
      }).toList();
    });
  }

  static Future<Map<String, double>> getAverageRatings() async {
    try {
      QuerySnapshot reviewSnapshot = await _reviewsCollection.get();
      Map<String, List<double>> destinationsRating = {};

      for (var doc in reviewSnapshot.docs) {
        String destinationsId = doc['destinationsId']; 
        double rating = doc['rating'];

        if (destinationsRating.containsKey(destinationsId)) {
          destinationsRating[destinationsId]!.add(rating);
        } else {
          destinationsRating[destinationsId] = [rating];
        }
      }

      Map<String, double> averageRatings = {};
      destinationsRating.forEach((destinationsId, ratings) {
        double average = ratings.reduce((a, b) => a + b) / ratings.length;
        averageRatings[destinationsId] = average;
      });

      return averageRatings;
    } catch (e) {
      throw Exception('Error getting average ratings: $e');
    }
  }
}