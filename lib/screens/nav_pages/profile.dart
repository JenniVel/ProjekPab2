import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String nama = "", username = "", email = "";

  @override
  void initState() {
    super.initState();
    getValidationData();
  }

  Future getValidationData() async {
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
    print(nama);
    print(email);
    print(username);
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
            const Center(
                child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('images/ic_profil.jpg'),
                ),
              ],
            )),
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
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: itemProfile('08xxxxxxxxxx', Icons.phone, () {}),
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
              delay: const Duration(milliseconds: 900),
              child: itemProfile('keluar', Icons.logout, _showDialog),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: itemProfile('TruPay', Icons.wallet, () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ));
              }),
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
            )),
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
                  sharedPreferences.remove('nama');
                  sharedPreferences.remove('username');
                  sharedPreferences.remove('email');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                  // Sign in berhasil, navigasikan ke layar utama
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
