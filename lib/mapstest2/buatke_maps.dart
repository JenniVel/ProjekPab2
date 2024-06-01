import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projek/mapstest2/loc.dart';

class NoteEditScreen extends StatefulWidget {
  final Location? location;

  const NoteEditScreen({Key? key, this.location}) : super(key: key);

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  GoogleMapController? _mapController;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      _latitude = widget.location!.latitude;
      _longitude = widget.location!.longitude;
    }
  }

  Future<void> _pickLocation() async {
    final currentPosition = await LocationService.getCurrentPosition();
    setState(() {
      _latitude = currentPosition?.latitude;
      _longitude = currentPosition?.longitude;
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(
      LatLng(_latitude!, _longitude!),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location == null ? 'Add Notes' : 'Update Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickLocation,
              child: const Text('Get Current Location'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition:
                        _latitude != null && _longitude != null
                            ? CameraPosition(
                                target: LatLng(_latitude!, _longitude!),
                                zoom: 15,
                              )
                            : const CameraPosition(
                                target: LatLng(0, 0),
                                zoom: 2,
                              ),
                    onMapCreated: (controller) {
                      setState(() {
                        _mapController = controller;
                      });
                    },
                  ),
                  if (_latitude != null && _longitude != null)
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: Text(
                          '$_latitude, $_longitude',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
    );
  }
}
