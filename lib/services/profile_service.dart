import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projek/models/profile.dart';
import 'package:path/path.dart' as path;

class ProfileService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _profilesCollection =
      _database.collection('profiles');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  static Future<void> addProfile(Profiles profiles) async {
    Map<String, dynamic> newNote = {
      'image_url': profiles.image_url,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _profilesCollection.add(newNote);
  }

  static Future<void> updateProfile(Profiles profiles) async {
    Map<String, dynamic> updatedProfile = {
      'image_url': profiles.image_url,
      'created_at': profiles.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _profilesCollection.doc(profiles.id).update(updatedProfile);
  }

  static Future<void> deleteNote(Profiles profiles) async {
    await _profilesCollection.doc(profiles.id).delete();
  }

  static Future<QuerySnapshot> retrieveProfiles() {
    return _profilesCollection.get();
  }

  static Stream<List<Profiles>> getProfile() {
    return _profilesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Profiles(
          id: doc.id,
          image_url: data['image_url'],
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
