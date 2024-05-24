import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek/screens/nav_pages/text_box.dart';
import 'package:projek/tema/theme_screen.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  String? imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    DocumentSnapshot userDoc =
        await usersCollection.doc(currentUser.email).get();
    if (userDoc.exists && userDoc.data() != null) {
      setState(() {
        imageUrl = (userDoc.data() as Map<String, dynamic>)['image_url'];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      String? uploadedImageUrl = await _uploadImageToFirebase(_imageFile!);
      if (uploadedImageUrl != null) {
        await usersCollection.doc(currentUser.email).update({
          'image_url': uploadedImageUrl,
        });

        setState(() {
          imageUrl = uploadedImageUrl;
        });
      }
    }
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${currentUser.email}.jpg');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _removeImage() async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${currentUser.email}.jpg');
      await storageRef.delete();

      await usersCollection.doc(currentUser.email).update({
        'image_url': FieldValue.delete(),
      });

      setState(() {
        imageUrl = null;
        _imageFile = null;
      });
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> _showImageOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Change Profile Picture'),
            onTap: () {
              Navigator.pop(context);
              _pickImage();
            },
          ),
          if (imageUrl != null)
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Remove Profile Picture'),
              onTap: () {
                Navigator.pop(context);
                _removeImage();
              },
            ),
        ],
      ),
    );
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.pink,
        title: Text("Edit $field"),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.amber),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.brown),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  Future<void> _confirmSignOut() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Keluar'),
        content: Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            child: Text('Tidak', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Ya', style: TextStyle(color: Colors.black)),
            onPressed: () async {
              Navigator.pop(context);
              await _signOut();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await usersCollection.doc(currentUser.email).update({
      'username': '',
      'namalengkap': '',
    });
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText1?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan", style: TextStyle(color: textColor)),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (userData['image_url'] != null
                                    ? NetworkImage(userData['image_url'])
                                    : AssetImage('images/google/hello.png'))
                                as ImageProvider,
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt,
                            color: Color(0xFF176FF2)),
                        onPressed: _showImageOptions,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Informasi Akun',
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'Nama Pengguna',
                  onPressed: () => editField('username'),
                  theme: theme,
                ),
                MyTextBox(
                  text: userData['namalengkap'],
                  sectionName: 'Nama Lengkap',
                  onPressed: () => editField('namalengkap'),
                  theme: theme,
                ),
                ReadOnlyTextBox(
                  text: currentUser.email!,
                  sectionName: 'Email',
                  color: theme.primaryColor, // Pass theme's primary color
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Pengaturan',
                    style: TextStyle(color: Color(0xFF176FF2)),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens),
                  title: Text('Tema', style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TemaPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Keluar', style: TextStyle(color: textColor)),
                  onTap: _confirmSignOut,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: textColor)),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ReadOnlyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final Color color; // Add color parameter

  const ReadOnlyTextBox({
    Key? key,
    required this.text,
    required this.sectionName,
    required this.color, // Update constructor to include color parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyText1?.color ?? Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionName,
            style: TextStyle(color: color), // Use color parameter here
          ),
          const SizedBox(height: 5),
          Text(text, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}
