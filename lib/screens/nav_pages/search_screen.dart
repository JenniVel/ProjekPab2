import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projek/models/wisata.dart';
import 'package:projek/screens/home/details_page.dart';
import 'package:projek/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";
  List<String> searchHistory = [];
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  void _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  void _addToSearchHistory(String term) async {
    final prefs = await SharedPreferences.getInstance();
    if (!searchHistory.contains(term)) {
      searchHistory.add(term);
      await prefs.setStringList('searchHistory', searchHistory);
    }
  }

  void _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    setState(() {
      searchHistory = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText1?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).primaryColor),
                onPressed: () {
                  if (currentUser != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(user: currentUser!),
                      ),
                    );
                  }
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _addToSearchHistory(value);
                      }
                    },
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontFamily: 'fonts/Inter-Black.ttf',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor,
                      ),
                      hintText: "Cari nama wisata...",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).canvasColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (searchHistory.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Riwayat",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  TextButton(
                    onPressed: _clearSearchHistory,
                    child: Text(
                      "Hapus",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 8.0,
              children: searchHistory.map((term) {
                return ActionChip(
                  label: Text(term),
                  onPressed: () {
                    setState(() {
                      query = term;
                    });
                  },
                );
              }).toList(),
            ),
          ],
          Expanded(
            child: StreamBuilder<List<Wisata>>(
              stream: FirebaseFirestore.instance
                  .collection('Destinations')
                  .snapshots()
                  .map((snapshot) {
                return snapshot.docs
                    .map((doc) => Wisata.fromDocument(doc))
                    .where((wisata) =>
                        wisata.name.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data yang ditemukan'));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final document = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(wisataId: document.id!),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              document.imageUrl != null &&
                                      Uri.parse(document.imageUrl!).isAbsolute
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0),
                                      ),
                                      child: Image.network(
                                        document.imageUrl!,
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: 150,
                                      color: Theme.of(context)
                                          .floatingActionButtonTheme
                                          .backgroundColor,
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  document.name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
