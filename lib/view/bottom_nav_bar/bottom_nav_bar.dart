import 'package:flutter/material.dart';
import 'package:news_app/view/home_screen/home_screen.dart';
import 'package:news_app/view/profile_screen/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  List Screens = [
    HomeScreen(),
    Container(
      child: Text("Discover"),
    ),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {
            selectedIndex = value;
            setState(() {});
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.public), label: "Discover"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Profile")
          ]),
    );
  }
}
