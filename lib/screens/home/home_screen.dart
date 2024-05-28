import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek/models/wisata.dart';
import 'package:projek/screens/home/details_page.dart';
import 'package:projek/screens/nav_pages/main_wrapper.dart';
import 'package:projek/screens/nav_pages/search_screen.dart';
import 'package:projek/screens/widgets/tab_view_child.dart';
import 'package:projek/screens/widgets/wisata_list.dart';
import 'package:projek/services/upload_service.dart';
import '../../models/category_model.dart';
import '../../models/people_also_like_model.dart';
import '../widgets/reuseable_text.dart';
import '../widgets/painter.dart';

class HomePage extends StatefulWidget {
  User? user;

  HomePage({Key? key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController tabController;
  int _selectedIndex = 0;
  List<PeopleAlsoLikeModel> favorites = [];
  final EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10.0);

   final Stream<List<Wisata>>? wisataStream = // Replace with your actual Stream/Future
      FirebaseFirestore.instance
          .collection('Destinations') // Replace 'wisata' with your collection name
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Wisata.fromDocument(doc)).toList();
      });

  List<Wisata> allWisata = []; // List to store all Wisata objects
  List<Wisata> filteredWisata = []; // List to store filtered Wisata objects
  String selectedCategory = 'All'; // Default category

  void filterByCategory(String category) {
    setState(() {
      if (category == 'All') {
        filteredWisata = allWisata;
      } else {
        filteredWisata = allWisata.where((wisata) => wisata.kategori == category).toList();
      }
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
     wisataStream!.listen((data) {
      allWisata = data;
      filteredWisata = allWisata;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List<PeopleAlsoLikeModel> _peopleAlsoLikeModelList =
        PeopleAlsoLikeModel.peopleAlsoLikeModeList +
            PeopleAlsoLikeModel.peopleAlsoLikeModeList1 +
            PeopleAlsoLikeModel.inspiration +
            PeopleAlsoLikeModel.perkotaan +
            PeopleAlsoLikeModel.places +
            PeopleAlsoLikeModel.popular;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // backgroundColor: Colors.blue.shade50,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(size),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: padding,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: AppText(
                      text: "TraveLine",
                      size: 30,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: AppText(
                      text: "Mau kemana hari ini?",
                      size: 25,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: size.height * 0.01, top: size.height * 0.02),
                      child: TextField(
                        style: TextStyle(
                          fontFamily: 'fonts/Inter-Black.ttf',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          filled: true,
                          fillColor: Theme.of(context).canvasColor,
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          hintStyle: TextStyle(
                            fontFamily: 'fonts/Inter-Black.ttf',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                          ),
                          hintText: "Mencari ...",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SearchScreen();
                          }));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      width: size.width,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          labelPadding: EdgeInsets.only(
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                          ),
                          controller: tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: const CircleTabBarIndicator(
                            color: Color.fromARGB(255, 63, 141, 219),
                            radius: 4,
                          ),
                          tabs: [
              Tab(child: Text('pantai')),
              Tab(child: Text('gunung')),
              Tab(child: Text('danau')),
              Tab(child: Text('perkotaan')), // Add more tabs for other categories
            ],
            onTap: (index) {
              String category;
              switch (index) {
                case 0:
                  category = 'pantai';
                  break;
                case 1:
                  category = 'gunung';
                  break;
                case 2:
                  category = 'danau';
                  break;
                case 3:
                  category = 'perkotaan';
                  break;
                default:
                  category = 'pantai';
              }
              filterByCategory(category);
            },
          ),
                      ),
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: Container(
                      margin: EdgeInsets.only(top: size.height * 0.01),
                      width: size.width,
                      height: size.height * 0.4,
                      child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tabController,
                          children: [
                            TabViewChild(wisata: filteredWisata.where((wisata) => wisata.kategori == 'pantai').toList()),
                            TabViewChild(wisata: filteredWisata.where((wisata) => wisata.kategori == 'gunung').toList()),
                            TabViewChild(wisata: filteredWisata.where((wisata) => wisata.kategori == 'danau').toList()),
                            TabViewChild(wisata: filteredWisata.where((wisata) => wisata.kategori == 'perkotaan').toList()),
                          ]),
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 900),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                          text: "Rekomendasi",
                          size: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => SeeAllPage(),
                            //   ),
                            // );
                          },
                          child: const AppText(
                            text: "Lihat Semua",
                            size: 16,
                            color: Colors
                                .blue, // Sesuaikan dengan warna yang diinginkan
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 1000),
                    child: const SizedBox(
                      child:  WisataList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(Size size) {
    return PreferredSize(
      preferredSize: Size.fromHeight(size.height * 0.09),
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainWrapper(user: widget.user!),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("images/panah1.png"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

