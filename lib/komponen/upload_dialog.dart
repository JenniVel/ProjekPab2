import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek/models/wisata.dart';
import 'package:projek/services/upload_service.dart';

class UploadDialog extends StatefulWidget {
  final Wisata? wisata;

  const UploadDialog({super.key, this.wisata});

  @override
  State<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
   final TextEditingController _longitudeController = TextEditingController();
  File? _imageFile;
  // Position? _currentPosition;
  // String? _currentAddress;

  @override
  void initState() {
    super.initState();
    if (widget.wisata != null) {
      _nameController.text = widget.wisata!.name;
      _descriptionController.text = widget.wisata!.description;
      _hargaController.text = widget.wisata!.harga;
      _kategoriController.text = widget.wisata!.kategori;
      _latitudeController.text = widget.wisata!.latitude.toString();
      _longitudeController.text = widget.wisata!.longitude.toString();
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
    return AlertDialog(
      title: Text(widget.wisata == null ? 'Add Destination' : 'Update Destination'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Destinasi: ',
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _nameController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Deskripsi: ',
            ),
          ),
          TextField(
            controller: _descriptionController,
          ),
           const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Harga: ',
            ),
          ),
          TextField(
            controller: _hargaController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Kategori: ',
            ),
          ),
          TextField(
            controller: _kategoriController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'latitude: ',
            ),
          ),
          TextField(
            controller: _latitudeController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Longitude: ',
            ),
          ),
          TextField(
            controller: _longitudeController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Image: '),
          ),
          Expanded(
              child: _imageFile != null
                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                  : (widget.wisata?.imageUrl != null &&
                          Uri.parse(widget.wisata!.imageUrl!).isAbsolute
                      ? Image.network(widget.wisata!.imageUrl!, fit: BoxFit.cover)
                      : Container())),
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
        ],
      ),
      actions: [
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
            Wisata wisata = Wisata(
              id: widget.wisata?.id,
              name: _nameController.text,
              description: _descriptionController.text,
              harga: _hargaController.text,
              kategori: _kategoriController.text,
              imageUrl: imageUrl,
              createdAt: widget.wisata?.createdAt, 
              latitude: double.tryParse(_latitudeController.text) ?? 0.0,
              longitude: double.tryParse(_longitudeController.text) ?? 0.0,
              isFavorite: false,
            );

            if (widget.wisata == null) {
              UploadService.addDestination(wisata)
                  .whenComplete(() => Navigator.of(context).pop());
            } else {
              UploadService.updateDestination(wisata)
                  .whenComplete(() => Navigator.of(context).pop());
            }
          },
          child: Text(widget.wisata == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}