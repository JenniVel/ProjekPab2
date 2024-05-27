import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:projek/models/wisata.dart';
import 'package:path/path.dart' as path;

class UploadService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _DestinationsCollection =
      _database.collection('Destinations');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

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

  static Future<void> addDestination(Wisata wisata) async {
    Map<String, dynamic> newDestination = {
      'name': wisata.name,
      'description': wisata.description,
      'harga': wisata.harga,
      'kategori': wisata.kategori,
      'image_url': wisata.imageUrl,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _DestinationsCollection.add(newDestination);
  }

  static Future<void> updateDestination(Wisata wisata) async {
    Map<String, dynamic> updatedDestination = {
      'name': wisata.name,
      'description': wisata.description,
      'harga': wisata.harga,
      'kategori': wisata.kategori,
      'image_url': wisata.imageUrl,
      'created_at': wisata.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _DestinationsCollection.doc(wisata.id).update(updatedDestination);
  }

  static Future<void> deleteDestination(Wisata wisata) async {
    await _DestinationsCollection.doc(wisata.id).delete();
  }

  static Future<QuerySnapshot> retrieveDestinations() {
    return _DestinationsCollection.get();
  }

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
}