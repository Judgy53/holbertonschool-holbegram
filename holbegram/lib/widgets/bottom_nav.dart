import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/screens/Pages/add_image.dart';
import 'package:holbegram/screens/Pages/favorite.dart';
import 'package:holbegram/screens/Pages/feed.dart';
import 'package:holbegram/screens/Pages/profile_screen.dart';
import 'package:holbegram/screens/Pages/search.dart';

class BottomNav extends StatefulWidget {

  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChange(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      {"title": "Home", "icon": Icons.home_outlined},
      {"title": "Search", "icon": Icons.search_outlined},
      {"title": "Add", "icon": Icons.add},
      {"title": "Favorites", "icon": Icons.favorite_outline},
      {"title": "Profile", "icon": Icons.person_outline},
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          const Feed(),
          const Search(),
          AddImage(setPageIndex: _onPageChange),
          const Favorite(),
          const Profile()
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: _onPageChange,
        items: items.map((item) => BottomNavyBarItem(
          icon: Icon(item["icon"] as IconData),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item["title"] as String, style: const TextStyle(fontSize: 25, fontFamily: "Billabong"))
            ]
          ),
          activeColor: Colors.red,
          inactiveColor: Colors.black,
          textAlign: TextAlign.center,
        )).toList(),
      ),
    );
  }

}
