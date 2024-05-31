// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'review_model.dart';  // Import the Review model

// class ReviewScreen extends StatefulWidget {
//   final String destinationId;
//   final String userId;

//   ReviewScreen({required this.destinationId, required this.userId});

//   @override
//   _ReviewScreenState createState() => _ReviewScreenState();
// }

// class _ReviewScreenState extends State<ReviewScreen> {
//   final _formKey = GlobalKey<FormState>();
//   double _rating = 3.0;
//   String _comment = '';

//   Future<void> _submitReview() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       Review review = Review(
//         id: '',
//         userId: widget.userId,
//         destinationId: widget.destinationId,
//         rating: _rating,
//         comment: _comment,
//         createdAt: Timestamp.now(),
//       );

//       await FirebaseFirestore.instance
//           .collection('Destinations')
//           .doc(widget.destinationId)
//           .collection('Reviews')
//           .add(review.toMap());

//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Review'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Slider(
//                 value: _rating,
//                 onChanged: (newRating) {
//                   setState(() {
//                     _rating = newRating;
//                   });
//                 },
//                 min: 1,
//                 max: 5,
//                 divisions: 4,
//                 label: '$_rating',
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Comment'),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a comment';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _comment = value!;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitReview,
//                 child: Text('Submit Review'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'review_model.dart';  // Import the Review model

// class ReviewsList extends StatelessWidget {
//   final String destinationId;

//   ReviewsList({required this.destinationId});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('Destinations')
//           .doc(destinationId)
//           .collection('Reviews')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }

//         List<Review> reviews = snapshot.data!.docs.map((doc) {
//           return Review.fromDocument(doc);
//         }).toList();

//         return ListView.builder(
//           itemCount: reviews.length,
//           itemBuilder: (context, index) {
//             Review review = reviews[index];
//             return ListTile(
//               title: Text(review.comment),
//               subtitle: Text('Rating: ${review.rating}'),
//             );
//           },
//         );
//       },
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'review_screen.dart';  // Import the ReviewScreen
// import 'reviews_list.dart';  // Import the ReviewsList

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DestinationScreen(destinationId: 'some_destination_id', userId: 'user_id'),
//     );
//   }
// }

// class DestinationScreen extends StatelessWidget {
//   final String destinationId;
//   final String userId;

//   DestinationScreen({required this.destinationId, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Destination Details'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ReviewScreen(destinationId: destinationId, userId: userId),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ReviewsList(destinationId: destinationId),
//     );
//   }
// }
