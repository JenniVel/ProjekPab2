import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek/screens/awalan/masuk_screen.dart';
import 'package:projek/screens/home/edit_screen.dart';
import 'package:projek/screens/nav_pages/profile_page.dart';
import 'package:projek/services/upload_service.dart';

class DestinationListScreen extends StatefulWidget {
  const DestinationListScreen({Key? key}) : super(key: key);

  @override
  State<DestinationListScreen> createState() => _DestinationListScreenState();

  static Future<void> confirmSignOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Keluar',
            style: Theme.of(context).textTheme.headline6),
        content: Text('Apakah Anda yakin ingin keluar?',
            style: Theme.of(context).textTheme.bodyText1),
        actions: [
          TextButton(
            child: Text('Tidak', style: Theme.of(context).textTheme.bodyText1),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Ya', style: Theme.of(context).textTheme.bodyText1),
            onPressed: () async {
              Navigator.pop(context);
              await _signOut(context);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Use Future.delayed to ensure navigation happens after the widget tree update
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MasukScreen()),
          (Route<dynamic> route) => false,
        );
      });
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}

class _DestinationListScreenState extends State<DestinationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 10),
            const Text('Destinations'),
            Spacer(),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () => DestinationListScreen.confirmSignOut(context),
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
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
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class DestinationList extends StatelessWidget {
  const DestinationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UploadService.getDestinationList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.redAccent)),
          );
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
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
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
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
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
                          title: Text(
                            document.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(document.kategori,
                              style: TextStyle(color: Colors.grey[700])),
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
                                              UploadService.deleteDestination(
                                                      document)
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
                                  child: Icon(Icons.delete, color: Colors.redAccent),
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

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.blueAccent,
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(color: Colors.black),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    home: DestinationListScreen(),
  ));
}