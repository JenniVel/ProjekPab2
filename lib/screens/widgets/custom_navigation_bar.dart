
// import 'package:destinasi_wisata_jinzoo/screens/home_screen.dart';
// import 'package:destinasi_wisata_jinzoo/screens/nav_pages/favorite.dart';
// import 'package:destinasi_wisata_jinzoo/screens/nav_pages/mail.dart';
// import 'package:destinasi_wisata_jinzoo/screens/nav_pages/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

// class CustomNavigationBar extends StatefulWidget {
//   final Function(int) onItemSelected;
//   final int selectedIndex;

//   const CustomNavigationBar(
//       {super.key, required this.onItemSelected, required this.selectedIndex});

//   @override
//   State<CustomNavigationBar> createState() => _CustomNavigationBarState();
// }

// class _CustomNavigationBarState extends State<CustomNavigationBar> {
//     late final PageController pageController;
//   int currentIndex = 0;
//   List<Widget> pages =  [
//     HomePage(),
//     Bar(),
//     Mail(),
//     Profile(),
//   ];

//   @override
//   void initState() {
//     pageController = PageController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }

//   void onTap(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//     pageController.animateToPage(index,
//         duration: const Duration(milliseconds: 1000), curve: Curves.linear);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WaterDropNavBar(
//         bottomPadding: 10.0,
//         waterDropColor: Colors.deepPurpleAccent,
//         backgroundColor: Colors.white,
//         onItemSelected: onTap,
//         selectedIndex: currentIndex,
//         barItems: [
//           BarItem(
//             filledIcon: Icons.home_filled,
//             outlinedIcon: Icons.home_outlined,
//           ),
//           BarItem(
//               filledIcon: Icons.favorite_rounded,
//               outlinedIcon: Icons.favorite_border_rounded),
//           BarItem(
//               filledIcon: Icons.mail,
//               outlinedIcon: Icons.mail_outline_outlined),
//           BarItem(filledIcon: Icons.people, outlinedIcon: Icons.people_outline),
//         ],
//       );
//   }

//   Widget navItem(
//       IconData icon, IconData borderIcon, int index, String routeName) {
//     return IconButton(
//       icon: Icon(
//         widget.selectedIndex == index ? icon : borderIcon,
//         color: widget.selectedIndex == index ? Colors.blue : Colors.black26,
//       ),
//       onPressed: () {
//         widget.onItemSelected(index);
//         if (widget.selectedIndex != index) {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             '/$routeName',
//             (route) => false,
//           );
//         }
//       },
//       highlightColor: Colors.transparent,
//     );
//   }
// }
