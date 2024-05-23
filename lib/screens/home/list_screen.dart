import 'package:flutter/material.dart';
import 'package:projek/screens/home/edit_screen.dart';
import 'package:projek/services/upload_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DestinationListScreen extends StatefulWidget {
  const DestinationListScreen({super.key});

  @override
  State<DestinationListScreen> createState() => _DestinationListScreenState();
}

class _DestinationListScreenState extends State<DestinationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinations'),
      ),
      body: const DestinationList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DestinationEditScreen(),
              ));
        },
        tooltip: 'Add Destination',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DestinationList extends StatelessWidget {
  const DestinationList({super.key});

  // Future<void> _launchMaps(double latitude, double longitude) async {
  //   Uri googleUrl = Uri.parse(
  //       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  //   try {
  //     await launchUrl(googleUrl);
  //   } catch (e) {
  //     print('Could not open the map: $e');
  //     // Optionally, show a message to the user
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UploadService.getDestinationList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: snapshot.data!.map((document) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DestinationEditScreen(
                              wisata: document,
                            ),
                          ));
                    },
                    child: Column(
                      children: [
                        document.imageUrl != null &&
                                Uri.parse(document.imageUrl!).isAbsolute
                            ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.network(
                                  document.imageUrl!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 150,
                                ),
                              )
                            : Container(),
                        ListTile(
                          title: Text(document.name),
                          subtitle: Text(document.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Konfirmasi Hapus'),
                                        content: Text(
                                            'Yakin ingin menghapus data \'${document.name}\' ?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Hapus'),
                                            onPressed: () {
                                              UploadService.deleteDestination(document)
                                                  .whenComplete(() =>
                                                      Navigator.of(context)
                                                          .pop());
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Icon(Icons.delete),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}