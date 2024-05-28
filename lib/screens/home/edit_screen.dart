import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek/models/wisata.dart';
import 'package:projek/services/upload_service.dart';

class DestinationEditScreen extends StatefulWidget {
  final Wisata? wisata;

  const DestinationEditScreen({Key? key, this.wisata}) : super(key: key);

  @override
  State<DestinationEditScreen> createState() => _DestinationEditScreenState();
}

class _DestinationEditScreenState extends State<DestinationEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  File? _imageFile;
  Position? _currentPosition;

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
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileName = DateTime.now().toString() + '.jpg';
    final imageRef = storageRef.child('images/$fileName');

    try {
      await imageRef.putFile(imageFile);
      final imageUrl = await imageRef.getDownloadURL();
      print('Image uploaded to Firebase Storage: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wisata == null ? 'Add Destination' : 'Update Destination'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
                  'Latitude: ',
                ),
              ),
              TextField(
                controller: _latitudeController,
                keyboardType: TextInputType.number,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Longitude: ',
                ),
              ),
              TextField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('Image: '),
              ),
              _imageFile != null
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: kIsWeb
                          ? Image.network(
                              _imageFile!.path,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_imageFile!.path),
                              fit: BoxFit.cover,
                            ),
                    )
                  : (widget.wisata?.imageUrl != null &&
                          Uri.parse(widget.wisata!.imageUrl!).isAbsolute
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: CachedNetworkImage(
                            imageUrl: widget.wisata!.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        )
                      : Container()),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 32),
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
                      try {
                        String? imageUrl;
                        if (_imageFile != null) {
                          imageUrl = await _uploadImageToFirebase(_imageFile!);
                        } else {
                          imageUrl = widget.wisata?.imageUrl;
                        }

                        final destination = Wisata(
                          id: widget.wisata?.id ?? '',
                          name: _nameController.text,
                          description: _descriptionController.text,
                          harga: _hargaController.text,
                          kategori: _kategoriController.text,
                          imageUrl: imageUrl ?? '',
                          latitude: double.tryParse(_latitudeController.text) ?? 0.0,
                          longitude: double.tryParse(_longitudeController.text) ?? 0.0,
                          createdAt: widget.wisata?.createdAt,
                        );

                        if (widget.wisata == null) {
                          await UploadService.addDestination(destination);
                        } else {
                          await UploadService.updateDestination(destination);
                        }
                        Navigator.of(context).pop();
                      } catch (e) {
                        print("Error saving destination: $e");
                      }
                    },
                    child: Text(widget.wisata == null ? 'Add' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
