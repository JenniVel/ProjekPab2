import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:projek/screens/awalan/reset_password.dart';
import 'package:projek/tema/theme_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PengaturanProfile extends StatefulWidget {
  const PengaturanProfile({Key? key});

  @override
  State<PengaturanProfile> createState() => _ProfileState();
}

class _ProfileState extends State<PengaturanProfile> {
  String nama = "", username = "", email = "";
  String? imageUrl;
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;

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

      String? uploadedImageUrl = await _uploadImageToFirebase(_imageFile!);
      if (uploadedImageUrl != null) {
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

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$username.jpg');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(username)
          .update({
        'fullname': nama,
        'email': email,
        'image_url': imageUrl,
      });

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final keyString = sharedPreferences.getString('key') ?? '';
      final ivString = sharedPreferences.getString('iv') ?? '';

      final encrypt.Key key = encrypt.Key.fromBase64(keyString);
      final iv = encrypt.IV.fromBase64(ivString);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encryptedFullname = encrypter.encrypt(nama, iv: iv).base64;
      final encryptedEmail = encrypter.encrypt(email, iv: iv).base64;

      sharedPreferences.setString('fullname', encryptedFullname);
      sharedPreferences.setString('email', encryptedEmail);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan berhasil disimpan!')));

      setState(() {
        isEditing = false;
      });

      // Navigasi kembali ke halaman profil setelah menyimpan perubahan
      Navigator.pop(context);
    }
  }

  void _resetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPass()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.transparent,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : imageUrl != null
                                  ? NetworkImage(imageUrl!)
                                  : const AssetImage('images/google/hello.png')
                                      as ImageProvider,
                        ),
                        if (isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nama Lengkap',
                      style: TextStyle(
                        fontFamily: 'fonts/Inter-Black.ttf',
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: isEditing
                    ? TextFormField(
                        initialValue: nama,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: const Color(0xFFF5F6F9),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama lengkap tidak boleh kosong';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          nama = value!;
                        },
                      )
                    : Text(
                        nama,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade800,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Text(
                  'Nama Pengguna',
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
                delay: const Duration(milliseconds: 550),
                child: isEditing
                    ? TextFormField(
                        initialValue: username,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.admin_panel_settings),
                          filled: true,
                          fillColor: const Color(0xFFF5F6F9),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama pengguna tidak boleh kosong';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username = value!;
                        },
                      )
                    : Text(
                        username,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade800,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Text(
                  'Gmail',
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
                delay: const Duration(milliseconds: 650),
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                child: Text(
                  'Ganti Kata Sandi',
                  style: TextStyle(
                    fontFamily: 'fonts/Inter-Black.ttf',
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (!isEditing) // Show the reset password button only when not in edit mode
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(360, 60),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'fonts/Inter-Bold.ttf',
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade400,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Ganti Kata Sandi"),
                  ),
                ),
              const SizedBox(height: 20),
              if (isEditing) // Show the save button only in edit mode
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(360, 60),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'fonts/Inter-Bold.ttf',
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade400,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Simpan Perubahan"),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TemaPage()),
          );
        },
        child: const Icon(Icons.color_lens),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
