import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../profil/pengaturan_profile_screen.dart'; // Import PengaturanProfileScreen

class Profile extends StatefulWidget {
  const Profile({super.key});

  get image_url => null;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String nama = "", username = "", email = "";
  String? imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    getValidationData();
  }

  Future<void> getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final encryptedFullname = sharedPreferences.getString('fullname') ?? '';
    final encryptedEmail = sharedPreferences.getString('email') ?? '';
    final encryptedUsername = sharedPreferences.getString('username') ?? '';
    final keyString = sharedPreferences.getString('key') ?? '';
    final ivString = sharedPreferences.getString('iv') ?? '';

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedFullname = encrypter.decrypt64(encryptedFullname, iv: iv);
    final decryptedEmail = encrypter.decrypt64(encryptedEmail, iv: iv);
    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);

    setState(() {
      nama = decryptedFullname;
      email = decryptedEmail;
      username = decryptedUsername;
    });

    // Retrieve profile image URL from Firestore
    final docSnapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(username)
        .get();
    if (docSnapshot.exists) {
      setState(() {
        imageUrl = docSnapshot['image_url'];
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

      // Upload the image to Firebase Storage
      String? uploadedImageUrl = await ProfileService.uploadImage(_imageFile!);
      if (uploadedImageUrl != null) {
        // Save the uploaded image URL to Firestore
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(username)
            .update({
          'image_url': uploadedImageUrl,
        });

        setState(() {
          imageUrl = uploadedImageUrl;
        });
      }
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PengaturanProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  imageUrl != null
                      ? CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(imageUrl!),
                        )
                      : const CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('lib/images/hello.png'),
                        ),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Profile Image'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Text(
                'Informasi Akun',
                style: TextStyle(
                  fontFamily: 'fonts/Inter-Black.ttf',
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: itemProfile(nama, Icons.person, () {}),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: itemProfile(username, Icons.admin_panel_settings, () {}),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: itemProfile(email, Icons.mail, () {}),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: Text(
                'Detail Informasi',
                style: TextStyle(
                  fontFamily: 'fonts/Inter-Black.ttf',
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: itemProfile(
                  'Pengaturan', Icons.settings, _navigateToSettings),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 900),
              child: itemProfile('Tema', Icons.format_paint, _showDialog),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 900),
              child: itemProfile('Keluar', Icons.logout, _showDialog),
            ),
          ],
        ),
      ),
    );
  }

  itemProfile(String title, IconData iconData, VoidCallback? press) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue.shade800,
          padding: const EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.blue.shade800,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'fonts/Inter-Black.ttf',
                  color: Color(0xFF1284EE),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Apakah anda yakin ingin log out ?'),
            actions: [
              MaterialButton(
                onPressed: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('fullname');
                  sharedPreferences.remove('username');
                  sharedPreferences.remove('email');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, '/');
                  });
                },
                child: const Text(
                  'Iya',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tidak'),
              )
            ],
          );
        });
  }
}
