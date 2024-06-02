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
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  File? _imageFile;
  Position? _currentPosition;
  final _formKey = GlobalKey<FormState>();

  final List<String> _kategori = ['pantai', 'gunung', 'danau', 'perkotaan'];

  String? _selectedKategori;

  @override
  void initState() {
    super.initState();
    if (widget.wisata != null) {
      _nameController.text = widget.wisata!.name;
      _descriptionController.text = widget.wisata!.description;
      _hargaController.text = widget.wisata!.harga;
      _selectedKategori = widget.wisata!.kategori;
      _latitudeController.text = widget.wisata!.latitude.toString();
      _longitudeController.text = widget.wisata!.longitude.toString();
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
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
        title: Text(
            widget.wisata == null ? 'Add Destination' : 'Update Destination'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Destinasi: ',
                  textAlign: TextAlign.start,
                ),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Deskripsi: ',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Harga: ',
                  ),
                ),
                TextFormField(
                  controller: _hargaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Kategori: ',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedKategori,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedKategori = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  items: _kategori.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Latitude: ',
                  ),
                ),
                TextFormField(
                  controller: _latitudeController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the latitude';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Longitude: ',
                  ),
                ),
                TextFormField(
                  controller: _longitudeController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the longitude';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
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
                              errorWidget: (context, url, error) =>
                                  const Center(
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
                        if (_formKey.currentState!.validate()) {
                          try {
                            String? imageUrl;
                            if (_imageFile != null) {
                              imageUrl =
                                  await _uploadImageToFirebase(_imageFile!);
                            } else {
                              imageUrl = widget.wisata?.imageUrl;
                            }

                            // Handle null values properly before conversion
                            double latitude = 0.0;
                            double longitude = 0.0;

                            if (_latitudeController.text.isNotEmpty) {
                              latitude = double.tryParse(_latitudeController.text) ?? 0.0;
                            }

                            if (_longitudeController.text.isNotEmpty) {
                              longitude = double.tryParse(_longitudeController.text) ?? 0.0;
                            }

                            final destination = Wisata(
                              id: widget.wisata?.id ?? '',
                              name: _nameController.text,
                              description: _descriptionController.text,
                              harga: _hargaController.text,
                               kategori: _selectedKategori ?? '',
                              imageUrl: imageUrl ?? '',
                              latitude: latitude,
                              longitude: longitude,
                              createdAt: widget.wisata?.createdAt,
                              isFavorite: false,
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
      ),
    );
  }
}
