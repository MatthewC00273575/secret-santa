import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            alignment: Alignment.bottomCenter,
            height: 170,
            decoration: BoxDecoration(color: Color.fromARGB(255, 12, 121, 15)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome to",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "Secret Santa",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 11, 95, 15)),
                        child: IconButton(
                          onPressed: signUserOut,
                          icon: const Icon(Icons.logout),
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
                ]),
          )
        ]),

        // logout
        /*appBar: AppBar(actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ]),*/

        // Bottom navigation bar
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
                GButton(icon: Icons.message, text: 'inbox'),
                GButton(icon: Icons.person, text: 'me'),
              ],
            ),
          ),
        ));
  }
}
