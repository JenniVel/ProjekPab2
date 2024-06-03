import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projek/models/review.dart';

class ReviewScreen extends StatefulWidget {
  final String destinationId;
  final String userId;

  ReviewScreen({required this.destinationId, required this.userId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 3.0;
  String _comment = '';

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Review review = Review(
        id: '',
        userId: widget.userId,
        destinationId: widget.destinationId,
        rating: _rating,
        comment: _comment,
        createdAt: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection('Destinations')
          .doc(widget.destinationId)
          .collection('reviews')
          .add(review.toMap());

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Slider(
                value: _rating,
                onChanged: (newRating) {
                  setState(() {
                    _rating = newRating;
                  });
                },
                min: 1,
                max: 5,
                divisions: 4,
                label: '$_rating',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Comment'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment';
                  }
                  return null;
                },
                onSaved: (value) {
                  _comment = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReview,
                child: Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewsList extends StatelessWidget {
  final String destinationId;

  ReviewsList({required this.destinationId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Destinations')
          .doc(destinationId)
          .collection('Reviews')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<Review> reviews = snapshot.data!.docs.map((doc) {
          return Review.fromDocument(doc);
        }).toList();

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            Review review = reviews[index];
            return ListTile(
              title: Text(review.comment),
              subtitle: Text('Rating: ${review.rating}'),
            );
          },
        );
      },
    );
  }
}

class DestinationScreen extends StatelessWidget {
  final String destinationId;
  final String userId;

  DestinationScreen({required this.destinationId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destination Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewScreen(
                      destinationId: destinationId, userId: userId),
                ),
              );
            },
          ),
        ],
      ),
      body: ReviewsList(destinationId: destinationId),
    );
  }
}

//add

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addReview(String reviewText, int rating) async {
  CollectionReference reviews = FirebaseFirestore.instance.collection('reviews');

  try {
    await reviews.add({
      'reviewText': reviewText,
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print("Review added");
  } catch (e) {
    print("Failed to add review: $e");
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Firestore Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(labelText: 'Review'),
            ),
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(labelText: 'Rating'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final reviewText = _reviewController.text;
                final rating = int.parse(_ratingController.text);
                addReview(reviewText, rating);
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}