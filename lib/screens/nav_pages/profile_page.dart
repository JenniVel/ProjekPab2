import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek/screens/awalan/masuk_screen.dart';
import 'package:projek/screens/awalan/reset_password.dart';
import 'package:projek/screens/widgets/box.dart';
import 'package:projek/screens/widgets/text_box.dart';
import 'package:projek/tema/theme_screen.dart';
import 'package:projek/services/profile_service.dart'; // Import the new service

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final ProfileService _profileService = ProfileService();
  String? imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _loadProfileImage();
  }

  Future<void> _initializeUserData() async {
    await _profileService.initializeUserData(currentUser);
  }

  Future<void> _loadProfileImage() async {
    String? url = await _profileService.loadProfileImage(currentUser);
    setState(() {
      imageUrl = url;
    });
  }

  Future<void> _pickImage() async {
    String? url = await _profileService.pickImage(currentUser);
    if (url != null) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  Future<void> _removeImage() async {
    await _profileService.removeImage(currentUser);
    setState(() {
      imageUrl = null;
      _imageFile = null;
    });
  }

  Future<void> _showImageOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.camera_alt,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text('Change Profile Picture'),
            onTap: () {
              Navigator.pop(context);
              _pickImage();
            },
          ),
          if (imageUrl != null)
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Theme.of(context).iconTheme.color,
              ),
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
        backgroundColor: Theme.of(context).backgroundColor,
        title:
            Text("Edit $field", style: Theme.of(context).textTheme.headline6),
        content: TextField(
          autofocus: true,
          style: Theme.of(context).textTheme.bodyText1,
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Color.fromARGB(255, 71, 101, 136)),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: Theme.of(context).textTheme.bodyText1),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save', style: Theme.of(context).textTheme.bodyText1),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await _profileService.editField(currentUser, field, newValue);
    }
  }

  Future<void> _confirmSignOut() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Keluar',
            style: Theme.of(context).textTheme.headline6),
        content: Text('Apakah Anda yakin ingin keluar?',
            style: Theme.of(context).textTheme.bodyText1),
        actions: [
          TextButton(
            child: Text('Tidak', style: Theme.of(context).textTheme.bodyText1),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Ya', style: Theme.of(context).textTheme.bodyText1),
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
    try {
      await FirebaseAuth.instance.signOut();
      // Use Future.delayed to ensure navigation happens after the widget tree update
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MasukScreen()),
          (Route<dynamic> route) => false,
        );
      });
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText1?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Pengaturan",
            style: TextStyle(
              color: theme.primaryColor,
              fontFamily: 'fonts/Inter-Bold.ttf',
              fontSize: 25,
            )),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            _profileService.usersCollection.doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 25),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: theme.backgroundColor,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (userData['image_url'] != null &&
                                        userData['image_url'].isNotEmpty
                                    ? NetworkImage(userData['image_url'])
                                    : AssetImage('images/hello.png'))
                                as ImageProvider,
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt,
                            color: Color.fromARGB(255, 47, 106, 195)),
                        onPressed: _showImageOptions,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Informasi Akun',
                    style: TextStyle(
                      fontFamily: 'fonts/Inter-Black.ttf',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                MyTextBox(
                  text: userData['username'].isEmpty
                      ? currentUser.displayName ?? 'Username'
                      : userData['username'],
                  sectionName: 'Nama Pengguna',
                  onPressed: () => editField('username'),
                  theme: theme,
                  icon: Icons.person,
                  color: theme.iconTheme.color,
                ),
                MyTextBox(
                  text: userData['namalengkap'].isEmpty
                      ? currentUser.displayName ?? 'Nama Lengkap'
                      : userData['namalengkap'],
                  sectionName: 'Nama Lengkap',
                  onPressed: () => editField('namalengkap'),
                  theme: theme,
                  icon: Icons.badge,
                  color: theme.iconTheme.color,
                ),
                ReadOnlyTextBox(
                  text: currentUser.email!,
                  sectionName: 'Email',
                  color: theme.primaryColor,
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Pengaturan Lainnya',
                    style: TextStyle(
                      fontFamily: 'fonts/Inter-Black.ttf',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens, color: theme.iconTheme.color),
                  title: Text('Tema', style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TemaPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.password, color: theme.iconTheme.color),
                  title: Text('Ganti Kata Sandi',
                      style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Reset(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.exit_to_app, color: theme.iconTheme.color),
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
