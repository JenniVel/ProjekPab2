import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/reuseable_text.dart';
import '../../models/people_also_like_model.dart';
import 'package:projek/models/wisata.dart';

class DetailsPage extends StatefulWidget {
  final String wisataId;

  const DetailsPage({
    super.key,
    required this.wisataId,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController datetimeinput = TextEditingController();
  int selected = 0;
  final EdgeInsetsGeometry padding =
      const EdgeInsets.symmetric(horizontal: 20.0);
  dynamic current;
  List<Marker> markers = [];
  Wisata? wisata;

  @override
  void initState() {
    super.initState();
    fetchLocations();
    _fetchWisataDetails();
  }

  Future<void> fetchLocations() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('locations').get();
      List<DocumentSnapshot> documents = snapshot.docs;

      setState(() {
        markers = documents.map((doc) {
          GeoPoint geoPoint = doc['location'];
          return Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(geoPoint.latitude, geoPoint.longitude),
            infoWindow: InfoWindow(title: doc['name']),
          );
        }).toList();
      });
    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  Future<void> _launchMaps(double latitude, double longitude) async {
    Uri googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunch(googleUrl.toString())) {
      await launch(googleUrl.toString());
    } else {
      print('Could not open the map.');
    }
  }

  Future<void> _fetchWisataDetails() async {
    final docRef = FirebaseFirestore.instance
        .collection('Destinations')
        .doc(widget.wisataId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      setState(() {
        wisata = Wisata.fromDocument(docSnapshot);
      });
    } else {
      print("Wisata not found with ID: ${widget.wisataId}");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final List<PeopleAlsoLikeModel> _peopleAlsoLikeModelList =
        PeopleAlsoLikeModel.peopleAlsoLikeModeList +
            PeopleAlsoLikeModel.peopleAlsoLikeModeList1 +
            PeopleAlsoLikeModel.inspiration +
            PeopleAlsoLikeModel.perkotaan +
            PeopleAlsoLikeModel.places +
            PeopleAlsoLikeModel.popular;

    bool toggleIsFavorite(bool isFavorite) {
      return !isFavorite;
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: wisata == null
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    child: wisata!.imageUrl != null &&
                            Uri.parse(wisata!.imageUrl!).isAbsolute
                        ? Hero(
                            tag: wisata!.name,
                            child: Image.network(
                              wisata!.imageUrl!,
                              fit: BoxFit.cover,
                              width: size.width,
                              height: size.height * 0.45,
                            ),
                          )
                        : Container(color: Colors.grey[200]),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: padding,
                      width: size.width,
                      height: size.height * 0.65,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInUp(
                              delay: const Duration(milliseconds: 200),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: wisata!.name,
                                          size: 28,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.black54,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: "Lokasi",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                GoogleMapsScreen(
                                                              markers: [],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            FadeInUp(
                              delay: const Duration(milliseconds: 300),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.monetization_on,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  AppText(
                                    text: "\Rp. " + wisata!.harga,
                                    size: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            FadeInUp(
                              delay: const Duration(milliseconds: 400),
                              child: Row(
                                children: [
                                  Wrap(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < 4
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: index < 4
                                            ? Colors.amber
                                            : Colors.grey,
                                      );
                                    }),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.01,
                                  ),
                                  const AppText(
                                    text: "(4.0)",
                                    size: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FadeInUp(
                                  delay: const Duration(milliseconds: 1000),
                                  child: const AppText(
                                    text: "Deskripsi",
                                    size: 21,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _launchMaps(
                                        current.latitude, current.longitude);
                                  },
                                  child: const Text('Tampilkan Peta'),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            FadeInUp(
                              delay: const Duration(milliseconds: 1100),
                              child: AppText(
                                text: wisata!.description,
                                size: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: size.height * 0.08),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: wisata == null
          ? SizedBox.shrink()
          : Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FadeInUp(
                    delay: const Duration(milliseconds: 1000),
                    child: Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              debugPrint('favorite');
                            },
                            child: Container(
                              width: size.width * 0.14,
                              height: size.height * 0.06,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 26, 123, 214),
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // child: IconButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       bool isFavorite = toggleIsFavorite(
                              //           _peopleAlsoLikeModelList[widget.id].isFavorite);
                              //       _peopleAlsoLikeModelList[widget.id].isFavorite =
                              //           isFavorite;
                              //     });
                              //   },
                              //   icon: Icon(
                              //     _peopleAlsoLikeModelList[widget.id].isFavorite
                              //         ? Icons.favorite
                              //         : Icons.favorite_border,
                              //     color: const Color.fromARGB(255, 26, 123, 214),
                              //   ),
                              // ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return const ReviewScreen();
            // }));
          },
          icon: const Icon(Icons.reviews),
        ),
      ],
    );
  }
}

class GoogleMapsScreen extends StatelessWidget {
  final List<Marker> markers;

  GoogleMapsScreen({required this.markers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-6.1751, 106.8650), // Example coordinates (Jakarta)
          zoom: 12,
        ),
        markers: Set.from(markers),
      ),
    );
  }
}
