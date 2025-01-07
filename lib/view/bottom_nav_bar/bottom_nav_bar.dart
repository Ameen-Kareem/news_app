import 'package:flutter/material.dart';
import 'package:news_app/view/home_screen/home_screen.dart';
import 'package:news_app/view/profile_screen/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, this.country});
  final String? country;
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey();
  late List Screens;
  void initState() {
    super.initState();
    Screens = [
      HomeScreen(
        country: widget.country,
      ),
      ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
            if (selectedIndex == 0) {
              homeScreenKey.currentState?.refresh();
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Profile")
          ]),
    );
  }
}
