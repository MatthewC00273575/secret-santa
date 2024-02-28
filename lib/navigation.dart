import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:secretsanta/pages/creategroup.dart';
import 'package:secretsanta/pages/homepage.dart';
import 'package:secretsanta/pages/inbox_page.dart';
import 'package:secretsanta/pages/profile_page.dart';
import 'package:secretsanta/pages/wishlist_page.dart';

class MyNavigation extends StatefulWidget {
  const MyNavigation({super.key});

  @override
  State<MyNavigation> createState() => _HomePageState();
}

class _HomePageState extends State<MyNavigation> {
  int _selectedIndex = 0; // To keep track of the selected tab index

  // List of pages you want to navigate to
  final List<Widget> _pages = const [
    HomePage(),
    MyWishlist(),
    MyInbox(),
    MyProfile(),
    CreateGroup()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 241, 233, 230),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: const Color.fromARGB(255, 241, 233, 230),
            tabBackgroundColor: Color.fromARGB(255, 170, 230, 115),
            padding: const EdgeInsets.all(16),
            gap: 8,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.favorite_border, text: 'Wish List'),
              GButton(icon: Icons.message, text: 'Inbox'),
              GButton(icon: Icons.person, text: 'Me'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
