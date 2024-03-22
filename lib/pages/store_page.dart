import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/drawer.dart';
import 'package:secretsanta/components/elevatedbutton.dart';
import 'package:secretsanta/pages/prof_page.dart';
import 'package:secretsanta/theme/colours.dart';
import 'package:google_fonts/google_fonts.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePage();
}

class _StorePage extends State<StorePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // navigate to profile page
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 75.0),
            child: Text(
              'Secret Santa',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        // Side menu
        drawer: MyDrawer(
          onProfileTap: goToProfilePage,
          onSignout: signUserOut,
        ),

        // body
        body: Column(
          children: [
            // promo banner
            Container(
                decoration: BoxDecoration(
                    color: accentsColour,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(25),
                child: Row(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // promo messages
                      Text(
                        'Get 32% Promo',
                        style: GoogleFonts.dmSerifDisplay(
                            fontSize: 20, color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      // redeem button
                      MyButton2(
                          onTap: () {},
                          text: 'Redeem',
                          iconData: Icons.arrow_right),
                    ],
                  ),

                  // image
                  Image.asset('lib/images/KeyboardImage.png', height: 100),
                ])),

            // search bar

            // store items list

            //
          ],
        ));
  }
}
