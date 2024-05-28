import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class GoogleMapsScreen extends StatefulWidget {
  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _cameraPosition;
  late Set<Marker> _markers = {};
  
  @override
  void initState() {
    super.initState();
    _cameraPosition = const CameraPosition(
      target: LatLng(-6.200000, 106.816666), // Default to Jakarta
      zoom: 5,
    );
    _fetchDestinations();
  }

  Future<void> _fetchDestinations() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('destinations').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final data = doc.data();
        final markerId = MarkerId(doc.id);
        final marker = Marker(
          markerId: markerId,
          position: LatLng(data['latitude'], data['longitude']),
          infoWindow: InfoWindow(
            title: data['title'],
            snippet: data['description'],
          ),
        );
        setState(() {
          _markers.add(marker);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToLocation,
        label: const Text('To the location!'),
        icon: const Icon(Icons.directions_car),
      ),
    );
  }

  Future<void> _goToLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }
}
