import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:projek/screens/home/review/review_edit_screen.dart';
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
            .collection('users')
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

class ReviewList extends StatefulWidget {
  final String userName;
  final String profileImageUrl;
  final String location;

  const ReviewList(
      {super.key,
      required this.userName,
      required this.profileImageUrl,
      required this.location});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ReviewService.getReviewList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            return ListView(
              padding: const EdgeInsets.all(10),
              children: snapshot.data!.map((document) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                            Text(
                              document.title,
                              style: TextStyle(
                                fontFamily: 'Bayon',
                                fontSize: 23,
                              ),
                            ),
                            Text(
                              document.updatedAt != null
                                  ? ' ${_formatTimestamp(document.updatedAt!)}'
                                  : document.createdAt != null
                                      ? ' ${_formatTimestamp(document.createdAt!)}'
                                      : 'Date not available',
                              style: TextStyle(
                                fontFamily: 'Battambang',
                                fontSize: 13,
                              ),
                            ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      widget.profileImageUrl.isNotEmpty
                                          ? NetworkImage(widget.profileImageUrl)
                                          : null,
                                  child: widget.profileImageUrl.isEmpty
                                      ? const Icon(Icons.person, size: 35)
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.userName,
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_pin,
                                            size: 18,
                                          ),
                                          Expanded(
                                            child: Text(
                                              (document.latitude != null &&
                                                      document.longitude !=
                                                          null)
                                                  ? '${document.latitude!.toStringAsFixed(3)}, ${document.longitude!.toStringAsFixed(3)}'
                                                  : 'Location not selected',
                                              style: TextStyle(
                                                fontFamily: 'Readex Pro',
                                                fontSize: 10,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    PopupMenuButton<String>(
                                      icon: Icon(
                                        Icons.more_vert,
                                      ),
                                      onSelected: (String value) {
                                        if (value == 'edit') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewEditScreen(
                                                review: document,
                                              ),
                                            ),
                                          );
                                        } else if (value == 'delete') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Confirm Delete'),
                                                content: Text(
                                                    'Are you sure want to delete this \'${document.title}\' ?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Delete'),
                                                    onPressed: () {
                                                      ReviewService
                                                              .deleteReview(
                                                                  document)
                                                          .whenComplete(() =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop());
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    RatingBarIndicator(
                                      rating: document.rating ?? 0,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        document.imageUrl != null &&
                                Uri.parse(document.imageUrl!).isAbsolute
                            ? Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(document.imageUrl!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        Text(
                          document.comment,
                          style: TextStyle(
                            fontFamily: 'Basic',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}