import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek/models/wisata.dart';
import 'package:projek/services/upload_service.dart';

class DestinationEditScreen extends StatefulWidget {
  final Wisata? wisata;

  const DestinationEditScreen({super.key, this.wisata});

  @override
  State<DestinationEditScreen> createState() => _DestinationEditScreenState();
}

class _DestinationEditScreenState extends State<DestinationEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  Position? _currentPosition;
  // String? _currentAddress;

  @override
  void initState() {
    super.initState();
    if (widget.wisata != null) {
      _nameController.text = widget.wisata!.name;
      _descriptionController.text = widget.wisata!.description;
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

  // Future<void> _pickLocation() async {
  //   final currentPosition = await LocationService.getCurrentPosition();
  //   // final currentAddress = await LocationService.getAddressFromLatLng(_currentPosition!);
  //   setState(() {
  //     _currentPosition = currentPosition;
  //     // _currentAddress = currentAddress;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wisata == null ? 'Add Destination' : 'Update Destination'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title: ',
              textAlign: TextAlign.start,
            ),
            TextField(
              controller: _nameController,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Description: ',
              ),
            ),
            TextField(
              controller: _descriptionController,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Image: '),
            ),
            _imageFile != null
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  )
                : (widget.wisata?.imageUrl != null &&
                        Uri.parse(widget.wisata!.imageUrl!).isAbsolute
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(widget.wisata!.imageUrl!,
                            fit: BoxFit.cover),
                      )
                    : Container()),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            // TextButton(
            //   onPressed: _pickLocation,
            //   child: const Text('Get Current Location'),
            // ),
            // Text('LAT: ${_currentPosition?.latitude ?? ""}'),
            // Text('LNG: ${_currentPosition?.longitude ?? ""}'),
            // Text('ADDRESS: ${_currentAddress ?? ""}'),

            SizedBox(
              height: 32,
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String? imageUrl;
                    if (_imageFile != null) {
                      imageUrl = await UploadService.uploadImage(_imageFile!);
                    } else {
                      imageUrl = widget.wisata?.imageUrl;
                    }
                    Wisata Destination = Wisata(
                      id: widget.wisata?.id,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      imageUrl: imageUrl,
                      // latitude: _currentPosition?.latitude,
                      // longitude: _currentPosition?.longitude,
                      createdAt: widget.wisata?.createdAt,
                    );

                    if (widget.wisata == null) {
                      UploadService.addDestination(Destination)
                          .whenComplete(() => Navigator.of(context).pop());
                    } else {
                      UploadService.updateDestination(Destination)
                          .whenComplete(() => Navigator.of(context).pop());
                    }
                  },
                  child: Text(widget.wisata == null ? 'Add' : 'Update'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}