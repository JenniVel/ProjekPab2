import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projek/screens/home/home_screen.dart';
import 'package:projek/screens/nav_pages/profile_page.dart';
import 'package:projek/screens/nav_pages/search_screen.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import 'favorite.dart';

class MainWrapper extends StatefulWidget {
  final User user;
  const MainWrapper({super.key, required this.user});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late final PageController pageController;

  int currentIndex = 0;
  List<Widget> _widgetOptions() {
    return [
      HomePage(user: widget.user),
      FavoriteScreen(),
      SearchScreen(),
      ProfilPage(),
    ];
  }

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 400), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: _widgetOptions(),
        ),
        bottomNavigationBar: WaterDropNavBar(
          bottomPadding: 10.0,
          waterDropColor: Colors.blue.shade500,
          backgroundColor: Theme.of(context).backgroundColor,
          onItemSelected: onTap,
          selectedIndex: currentIndex,
          barItems: [
            BarItem(
              filledIcon: Icons.home_filled,
              outlinedIcon: Icons.home_outlined,
            ),
            BarItem(
              filledIcon: Icons.favorite_rounded,
              outlinedIcon: Icons.favorite_border_rounded,
            ),
            BarItem(
              filledIcon: Icons.search,
              outlinedIcon: Icons.search,
            ),
            BarItem(
              filledIcon: Icons.people,
              outlinedIcon: Icons.people_outline,
            ),
          ],
        ),
      ),
    );
  }
}
