import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: GNav(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          tabBackgroundColor: Color.fromARGB(167, 255, 210, 7),
          padding: EdgeInsets.all(16),
          gap: 8,
          tabs: [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.favorite_border, text: 'Wish List'),
            GButton(icon: Icons.search),
            GButton(icon: Icons.settings, text: 'Settings'),
          ],
        ),
      ),
    ));
  }
}
