import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek/screens/nav_pages/text_box.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
//user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //semua user
  final usersCollection = FirebaseFirestore.instance.collection("Users");

//edit field
  Future<void> editField(String field) async {
    String newValue = " ";
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
          //cancel button
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          //save button
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    //update di firestore
    if (newValue.trim().length > 0) {
      //hny hk ad di textfield
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          //get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),
                // profile picture
                Icon(
                  Icons.person,
                  size: 72,
                ),
                const SizedBox(height: 10),

                //nama lengkap

                //email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueAccent[700]),
                ),

                const SizedBox(height: 50),

//user details
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.green),
                  ),
                ),

                //username
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'username',
                  onPressed: () => editField('username'),
                ),

                //nama lengkap
                MyTextBox(
                  text: userData['namalengkap'],
                  sectionName: 'nama lengkap',
                  onPressed: () => editField('nama lengkap'),
                ),

                const SizedBox(height: 50),

                //user posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Posts',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
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
