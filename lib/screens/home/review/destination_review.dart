import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:projek/models/wisata.dart';
import 'package:projek/services/upload_service.dart';
import 'package:provider/provider.dart';

class DestinationReviewScreen extends StatefulWidget {
  const DestinationReviewScreen({Key? key, required this.wisataId})
      : super(key: key);

  final String wisataId;

  @override
  State<DestinationReviewScreen> createState() =>
      _DestinationReviewScreenState();
}

class _DestinationReviewScreenState extends State<DestinationReviewScreen> {
  final db = UploadService();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Wisata>(
        future: db.getDestinationById(widget.wisataId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading Destination'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Destination not found'));
          }

          final Destination = snapshot.data!;
          return Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0x004B39EF),
                              elevation: 0,
                              side: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              width: 353,
                              height: 304,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: Destination.imageUrl != null
                                    ? DecorationImage(
                                        image:
                                            NetworkImage(Destination.imageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 220,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: SingleChildScrollView(
                              child: Container(
                                width: 393,
                                height: 598,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      Destination.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!,
                                    ),
                                    const SizedBox(height: 5),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Creator: ',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Bayon',
                                              color: Color(0xFFFF8A00),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Column(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: _rating,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
                                                _rating = rating;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '$_rating',
                                            style: const TextStyle(
                                              fontFamily: 'Bayon',
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          // Simpan nilai rating ke Firestore
                                          await db.updateDestinationRating(
                                              widget.wisataId, _rating);

                                          // Beri umpan balik kepada pengguna bahwa nilai rating telah disimpan
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Rating telah disimpan.'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        } catch (e) {
                                          // Tangani kesalahan jika terjadi
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Terjadi kesalahan: $e'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0XFFF1B26F),
                                        shape: const ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        elevation: 5.0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 15),
                                      ),
                                      child: const Text(
                                        'SIMPAN',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'BAYON',
                                          color: Color(0XFF543310),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
