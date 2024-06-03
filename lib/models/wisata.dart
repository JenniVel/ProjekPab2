import 'package:cloud_firestore/cloud_firestore.dart';

class Wisata {
  String? id;
  final String name;
  final String description;
  final String harga;
  final String kategori;
  final double latitude;
  final double longitude;
  bool isFavorite;
  String? imageUrl;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Wisata( {
    this.id,
    required this.name,
    required this.description,
    required this.harga,
    required this.kategori,
    required this.latitude, 
    required this.longitude,
    required this.isFavorite,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Wisata.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Wisata(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      harga: data['harga'],
      kategori: data['kategori'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      imageUrl: data['image_url'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp, 
      isFavorite: data['isFavorite'], 
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'description': description,
      'harga' : harga,
      'kategori' : kategori,
      'latitude' : latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'isFavorite': isFavorite
    };
  }

  factory Wisata.FromFirestore(Map<String, dynamic> data, String id) {
    return Wisata(
      id: id,
      name: data['name'],
      description: data['description'],
      harga: data['harga'],
      kategori: data['kategori'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      imageUrl: data['image_url'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp, 
      isFavorite: data['isFavorite'], 
    );
  }

  Map<String, dynamic> ToFirestore() {
    return {
      'name': name,
      'description': description,
      'harga' : harga,
      'kategori' : kategori,
      'latitude' : latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'isFavorite': isFavorite
    };
  }
}