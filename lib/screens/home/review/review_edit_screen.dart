import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek/models/review.dart';
import 'package:projek/screens/home/review/pickLocation.dart';
import 'package:projek/services/review_service.dart';
import 'package:provider/provider.dart';

class ReviewEditScreen extends StatefulWidget {
  const ReviewEditScreen({super.key, this.review, this.initialLocation});
  final Review? review;
  final String? initialLocation;

  @override
  State<ReviewEditScreen> createState() => _ReviewEditScreenState();
}

class _ReviewEditScreenState extends State<ReviewEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  File? _imageFile;
  LatLng? _currentPosition;
  double? _rating = 0.0;
  String? pickedLocation;

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      _titleController.text = widget.review!.title;
      _commentController.text = widget.review!.comment;
      _rating = widget.review!.rating ?? 0;
      pickedLocation = widget.review!.location;
    } else {
      pickedLocation = widget.initialLocation;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickLocation() async {
    final LatLng? selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LocationPicker()),
    );

    if (selectedLocation != null) {
      setState(() {
        pickedLocation =
            '(${selectedLocation.latitude.toStringAsFixed(3)}, ${selectedLocation.longitude.toStringAsFixed(3)})';
        _currentPosition = selectedLocation;
      });
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
          child: SingleChildScrollView(
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
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(-0.15, 0),
                        child: Text(
                          widget.review == null
                              ? 'Add Reviews'
                              : 'Edit Reviews',
                          style: const TextStyle(
                            fontFamily: 'Bayon',
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 3,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title : ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Bayon',
                            fontSize: 20,
                          ),
                        ),
                        TextField(
                          controller: _titleController,
                          style: TextStyle(
                            fontFamily: 'Basic',
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Image : ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Bayon',
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _imageFile != null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: FileImage(_imageFile!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : (widget.review?.imageUrl != null &&
                                        Uri.parse(widget.review!.imageUrl!)
                                            .isAbsolute
                                    ? Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                widget.review!.imageUrl!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container()),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: _pickImage,
                                  icon: Icon(
                                    Icons.add_a_photo,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Comment : ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Bayon',
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextField(
                          controller: _commentController,
                          style: TextStyle(
                            fontFamily: 'Basic',
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Text(
                                'Rating : ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Bayon',
                                  fontSize: 20,
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: _rating ?? 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 235, 177, 0),
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _rating = rating;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Text(
                                'Pick Your Location : ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Bayon',
                                  fontSize: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: _pickLocation,
                                icon: Icon(
                                  Icons.location_pin,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  pickedLocation ?? 'Location not selected',
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                String? imageUrl;
                                if (_imageFile != null) {
                                  imageUrl = await ReviewService.uploadImage(
                                      _imageFile!);
                                } else {
                                  imageUrl = widget.review?.imageUrl;
                                }
                                Review review = Review(
                                  id: widget.review?.id,
                                  title: _titleController.text,
                                  comment: _commentController.text,
                                  imageUrl: imageUrl,
                                  rating: _rating,
                                  location: pickedLocation,
                                  latitude: _currentPosition?.latitude,
                                  longitude: _currentPosition?.longitude,
                                  createdAt: widget.review?.createdAt,
                                );

                                if (widget.review == null) {
                                  ReviewService.addReview(review).whenComplete(
                                      () => Navigator.of(context).pop());
                                } else {
                                  ReviewService.updateReview(review)
                                      .whenComplete(
                                          () => Navigator.of(context).pop());
                                }
                              },
                              child: Text(
                                  widget.review == null ? 'Add' : 'Update'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}