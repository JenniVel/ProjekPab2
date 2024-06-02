import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("Users");

  Future<void> initializeUserData(User currentUser) async {
    DocumentSnapshot userDoc = await usersCollection.doc(currentUser.email).get();
    if (!userDoc.exists) {
      await usersCollection.doc(currentUser.email).set({
        'username': currentUser.displayName ?? '',
        'namalengkap': currentUser.displayName ?? '',
        'email': currentUser.email,
        'image_url': '',
      });
    }
  }

  Future<String?> loadProfileImage(User currentUser) async {
    DocumentSnapshot userDoc = await usersCollection.doc(currentUser.email).get();
    if (userDoc.exists && userDoc.data() != null) {
      return (userDoc.data() as Map<String, dynamic>)['image_url'];
    }
    return null;
  }

  Future<String?> pickImage(User currentUser) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      return await uploadImageToFirebase(imageFile, currentUser);
    }
    return null;
  }

  Future<String?> uploadImageToFirebase(File imageFile, User currentUser) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${currentUser.email}.jpg');
      await storageRef.putFile(imageFile);
      String imageUrl = await storageRef.getDownloadURL();
      await usersCollection.doc(currentUser.email).update({'image_url': imageUrl});
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> removeImage(User currentUser) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${currentUser.email}.jpg');
      await storageRef.delete();
      await usersCollection.doc(currentUser.email).update({
        'image_url': FieldValue.delete(),
      });
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> editField(User currentUser, String field, String newValue) async {
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }
}
