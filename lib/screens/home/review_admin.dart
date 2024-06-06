import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReviewAdmin extends StatelessWidget {
  const ReviewAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.redAccent)),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  var review = document.data() as Map<String, dynamic>;
                  return ReviewCard(review: review, documentId: document.id);
                },
              );
          }
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final String documentId;

  const ReviewCard({Key? key, required this.review, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          review['title'] ?? 'No Title',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(review['comment'] ?? 'No Comment', style: TextStyle(color: Colors.grey[700])),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => _showDeleteConfirmationDialog(context),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Yakin ingin menghapus review ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('reviews')
                    .doc(documentId)
                    .delete()
                    .whenComplete(() => Navigator.of(context).pop());
              },
            ),
          ],
        );
      },
    );
  }
}