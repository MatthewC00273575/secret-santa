import 'package:flutter/material.dart';
import 'package:secretsanta/theme/colours.dart';

class MyWishlist extends StatelessWidget {
  const MyWishlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentsColour,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 75.0),
          child: Text(
            'My Wishlist',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // body
      body: ListView.builder(itemBuilder: (context, Index) {
        // get items from wishlist

        //get item name

        // get item price
      }),
    );
  }
}
