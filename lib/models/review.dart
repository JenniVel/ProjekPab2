import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  String userId;
  String destinationId;
  double rating;
  String comment;
  Timestamp createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.destinationId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  // Factory method to create a Review object from a Firestore document
  factory Review.fromDocument(DocumentSnapshot doc) {
    return Review(
      id: doc.id,
      userId: doc['user_id'],
      destinationId: doc['destination_id'],
      rating: doc['rating'],
      comment: doc['comment'],
      createdAt: doc['created_at'],
    );
  }

  // Method to convert a Review object to a map
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'destination_id': destinationId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
    };
  }
}
