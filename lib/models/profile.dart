import 'package:cloud_firestore/cloud_firestore.dart';

class Profiles {
  String? id;
  String? image_url;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Profiles({
    this.id,
    this.image_url,
    this.createdAt,
    this.updatedAt,
  });

  factory Profiles.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Profiles(
      id: doc.id,
      image_url: data['image_url'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'image_url': image_url,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
