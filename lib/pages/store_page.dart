import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/drawer.dart';
import 'package:secretsanta/components/elevatedbutton.dart';
import 'package:secretsanta/components/items_tile.dart';
import 'package:secretsanta/models/store_item.dart';
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

  // store items list
  List storeItems = [
    // flusk
    Item(
        name: "Flusk",
        price: "18.00",
        imagePath: 'lib/images/flusk.png',
        rating: "4.8"),

    // charger
    Item(
      name: "Cableless Charge",
      price: "46.00",
      imagePath: 'lib/images/charger.png',
      rating: "4.2",
    ),

    //handbag
    Item(
        name: "Handbag",
        price: "60.00",
        imagePath: 'lib/images/Handbag-PNG.png',
        rating: "4.5"),

    // scarf
    Item(
        name: "Scarf",
        price: "24.00",
        imagePath: 'lib/images/scarf.png',
        rating: "4.9"),
  ];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // promo banner
            Container(
                decoration: BoxDecoration(
                    color: accentsColour,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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

            const SizedBox(height: 20),

            // search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Search here.."),
              ),
            ),

            const SizedBox(height: 25),

            // Explore
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Explore",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: darkGrey,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: storeItems.length,
                itemBuilder: (context, index) => ItemsTile(
                  item: storeItems[index],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // popular
            Container(
              decoration: BoxDecoration(
                color: secondaryColour,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // image
                  Row(
                    children: [
                      Image.asset(
                        'lib/images/speakers.png',
                        height: 60,
                      ),

                      const SizedBox(width: 20),

                      // name and price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // name
                          Text(
                            "Logitech Speakers",
                            style: GoogleFonts.dmSerifDisplay(fontSize: 18),
                          ),

                          const SizedBox(height: 10),

                          //price
                          Text(
                            '\$56.00',
                            style: TextStyle(color: darkGrey),
                          )
                        ],
                      ),
                    ],
                  ),

                  // heart
                  Icon(
                    Icons.favorite_outline,
                    color: darkGrey,
                    size: 20,
                  )
                ],
              ),
            )
          ],
        ));
  }
}
