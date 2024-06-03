import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:projek/screens/home/review/review_edit_screen.dart';
import 'package:projek/screens/widgets/review_list.dart';
import 'package:projek/services/review_service.dart';
import 'package:provider/provider.dart';


class ReviewListScreen extends StatefulWidget {
  final String destinationsTitle;
  const ReviewListScreen({Key? key, required this.destinationsTitle}) : super(key: key);

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final user = snapshot.data;
        return ReviewListContent(destinationsTitle: widget.destinationsTitle, user: user);
      },
    );
  }
}

class ReviewListContent extends StatefulWidget {
  final String destinationsTitle;
  final User? user;
  const ReviewListContent(
      {Key? key, required this.destinationsTitle, required this.user})
      : super(key: key);

  @override
  State<ReviewListContent> createState() => _ReviewListContentState();
}

class _ReviewListContentState extends State<ReviewListContent> {
  String userName = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    try {
      if (widget.user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.user!.uid)
            .get();

        if (userData.exists) {
          setState(() {
            userName = userData['username'] ?? 'No Username';
            profileImageUrl = userData['profileImageUrl'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: const AlignmentDirectional(-0.15, 0),
                      child: Text(
                        widget.destinationsTitle,
                        style:
                            const TextStyle(fontFamily: 'Bayon', fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 3,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ReviewList(
                    userName: userName,
                    profileImageUrl: profileImageUrl,
                    location: '',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewEditScreen(),
                ),
              );
            },
            tooltip: 'Add Review',
            backgroundColor: Colors.teal,
            shape: const CircleBorder(),
            elevation: 20,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

