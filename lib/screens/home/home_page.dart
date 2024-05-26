import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek/screens/home/details_page.dart';
import 'package:projek/screens/nav_pages/main_wrapper.dart';
import 'package:projek/screens/nav_pages/search_screen.dart';
import 'package:projek/screens/widgets/wisata_list.dart';
import '../../models/category_model.dart';
import '../../models/people_also_like_mode.dart';
import '../widgets/reuseable_text.dart';
import '../widgets/painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user});

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController tabController;
  int _selectedIndex = 0;
  List<PeopleAlsoLikeModel> favorites = [];
  final EdgeInsetsGeometry padding =
      const EdgeInsets.symmetric(horizontal: 10.0);

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
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
        backgroundColor: Theme.of(context).colorScheme.background,
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
                    child: const AppText(
                      text: "TraveLine",
                      size: 30,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: const AppText(
                      text: "Mau kemana hari ini?",
                      size: 25,
                      color: Colors.black,
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
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          filled: true,
                          fillColor: Colors.blue.shade700,
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                          hintStyle: const TextStyle(
                            fontFamily: 'fonts/Inter-Black.ttf',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
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
                          tabs: categoryComponents.map((current) {
                            return Tab(
                              icon: Column(
                                children: [
                                  Image.asset(
                                    current.image,
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    current.name,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
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
                            TabViewChild(
                                combinedPeopleAlsoLikeModelList:
                                    PeopleAlsoLikeModel.places),
                            TabViewChild(
                                combinedPeopleAlsoLikeModelList:
                                    PeopleAlsoLikeModel.inspiration),
                            TabViewChild(
                                combinedPeopleAlsoLikeModelList:
                                    PeopleAlsoLikeModel.popular),
                            TabViewChild(
                                combinedPeopleAlsoLikeModelList:
                                    PeopleAlsoLikeModel.perkotaan),
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
                            //     builder: (context) => SeeAllPage(), // Ganti SeeAllPage dengan halaman yang sesuai
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
                    child: SizedBox(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: WisataList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        //   bottomNavigationBar: CustomNavigationBar(
        //   onItemSelected: (index) {
        //     setState(() {
        //       _selectedIndex = index;
        //     });
        //   },
        //   selectedIndex: _selectedIndex,
        // ),
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
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainWrapper(user: widget.user),
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

class TabViewChild extends StatelessWidget {
  const TabViewChild({
    Key? key,
    required this.combinedPeopleAlsoLikeModelList,
  }) : super(key: key);

  final List<PeopleAlsoLikeModel> combinedPeopleAlsoLikeModelList;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ListView.builder(
      itemCount: combinedPeopleAlsoLikeModelList.length,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        PeopleAlsoLikeModel current = combinedPeopleAlsoLikeModelList[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                  personData: current,
                  isCameFromPersonSection: true,
                  id: combinedPeopleAlsoLikeModelList[index].id),
            ),
          ),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Hero(
                tag: current.image,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  width: size.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(current.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: size.height * 0.2,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  width: size.width * 0.53,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(153, 0, 0, 0),
                        Color.fromARGB(118, 29, 29, 29),
                        Color.fromARGB(54, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: size.width * 0.07,
                bottom: size.height * 0.045,
                child: AppText(
                  text: current.title,
                  size: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Positioned(
                left: size.width * 0.07,
                bottom: size.height * 0.025,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    AppText(
                      text: current.location,
                      size: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
