import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? id;
  final String title;
  final String comment;
  String? imageUrl;
  String? location;
  double? latitude;
  double? longitude;
  double? rating;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? userName; 

  Review({
    this.id,
    required this.title,
    required this.comment,
    this.imageUrl,
    this.location,
    this.latitude,
    this.longitude,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.userName, 
  });

  factory Review.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      title: data['title'],
      comment: data['comment'],
      imageUrl: data['image_url'],
      location: data['location'],
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
      rating: data['rating'] as double?,
      createdAt: data['created_at'] as Timestamp?,
      updatedAt: data['updated_at'] as Timestamp?,
      userName: data['userName'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'comment': comment,
      'image_url': imageUrl,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'userName': userName,
    };
  }
}
