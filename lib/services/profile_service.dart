// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:projek/screens/awalan/masuk_screen.dart';

// class ProfilService {
//   static final currentUser = FirebaseAuth.instance.currentUser!;
//   static final usersCollection = FirebaseFirestore.instance.collection("Users");

//   static Future<void> initializeUserData() async {
//     DocumentSnapshot userDoc = await usersCollection.doc(currentUser.email).get();
//     if (!userDoc.exists) {
//       await usersCollection.doc(currentUser.email).set({
//         'username': currentUser.displayName ?? '',
//         'namalengkap': currentUser.displayName ?? '',
//         'email': currentUser.email,
//         'image_url': '',
//       });
//     }
//   }

//   static Future<void> loadProfileImage() async {
//     DocumentSnapshot userDoc = await usersCollection.doc(currentUser.email).get();
//     if (userDoc.exists && userDoc.data() != null) {
//       // Set state atau lakukan pembaruan tampilan sesuai kebutuhan
//     }
//   }

//   static Future<void> pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       // Implementasi pengambilan gambar
//     }
//   }

//   static Future<String?> uploadImageToFirebase(File imageFile) async {
//     try {
//       final storageRef = FirebaseStorage.instance.ref().child('profile_images').child('${currentUser.email}.jpg');
//       await storageRef.putFile(imageFile);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }

//   static Future<void> removeImage() async {
//     try {
//       final storageRef = FirebaseStorage.instance.ref().child('profile_images').child('${currentUser.email}.jpg');
//       await storageRef.delete();
//       await usersCollection.doc(currentUser.email).update({'image_url': FieldValue.delete()});
//       // Set state atau lakukan pembaruan tampilan sesuai kebutuhan
//     } catch (e) {
//       print('Error deleting image: $e');
//     }
//   }

//   static Future<void> editField(BuildContext context, String field) async {
//     String newValue = "";
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Theme.of(context).backgroundColor,
//         title: Text("Edit $field", style: Theme.of(context).textTheme.headline6),
//         content: TextField(
//           autofocus: true,
//           style: Theme.of(context).textTheme.bodyText1,
//           decoration: InputDecoration(
//             hintText: "Enter new $field",
//             hintStyle: TextStyle(color: Color.fromARGB(255, 71, 101, 136)),
//           ),
//           onChanged: (value) {
//             newValue = value;
//           },
//         ),
//         actions: [
//           TextButton(
//             child: Text('Cancel', style: Theme.of(context).textTheme.bodyText1),
//             onPressed: () => Navigator.pop(context),
//           ),
//           TextButton(
//             child: Text('Save', style: Theme.of(context).textTheme.bodyText1),
//             onPressed: () => Navigator.of(context).pop(newValue),
//           ),
//         ],
//       ),
//     );

//     if (newValue.trim().isNotEmpty) {
//       await usersCollection.doc(currentUser.email).update({field: newValue});
//     }
//   }

//   static Future<void> confirmSignOut(BuildContext context) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Konfirmasi Keluar', style: Theme.of(context).textTheme.headline6),
//         content: Text('Apakah Anda yakin ingin keluar?', style: Theme.of(context).textTheme.bodyText1),
//         actions: [
//           TextButton(
//             child: Text('Tidak', style: Theme.of(context).textTheme.bodyText1),
//             onPressed: () => Navigator.pop(context),
//           ),
//           TextButton(
//             child: Text('Ya', style: Theme.of(context).textTheme.bodyText1),
//             onPressed: () async {
//               Navigator.pop(context);
//               await signOut(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   static Future<void> signOut(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Future.delayed(Duration.zero, () {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => MasukScreen()),
//           (Route<dynamic> route) => false,
//         );
//       });
//     } catch (e) {
//       print('Error signing out: $e');
//     }
//   }
// }
