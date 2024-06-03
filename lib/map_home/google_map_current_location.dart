import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projek/map_home/location_service_home.dart';

class GoogleMapsScreens extends StatefulWidget {
  const GoogleMapsScreens({super.key});

  @override
  State<GoogleMapsScreens> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreens> {
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition? _cameraPosition;
  Set<Marker> _markers = {};
  late MarkerId _currentLocationMarkerId;

  @override
  void initState() {
    super.initState();
    _initializePosition();
  }

  Future<void> _initializePosition() async {
    Position? currentPosition = await LocationService.getCurrentPosition();
    if (currentPosition != null) {
      setState(() {
        _cameraPosition = CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 15,
        );
        _currentLocationMarkerId = MarkerId('current_location');
        _markers.add(
          Marker(
            markerId: _currentLocationMarkerId,
            position:
                LatLng(currentPosition.latitude, currentPosition.longitude),
            infoWindow: const InfoWindow(
              title: 'Lokasi Anda Saat Ini',
              snippet: 'Disini Anda Berada',
            ),
          ),
        );
      });
    }
  }

  void _addMarker(LatLng position, String title, String snippet) {
    final markerId = MarkerId(position.toString());
    final marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: _cameraPosition != null
          ? GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _cameraPosition!,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                Future.delayed(const Duration(milliseconds: 500), () {
                  controller.showMarkerInfoWindow(_currentLocationMarkerId);
                });
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
