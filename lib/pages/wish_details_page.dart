import 'package:flutter/material.dart';

class WishListDetails extends StatelessWidget {
  final String wishlistName;

  const WishListDetails({Key? key, required this.wishlistName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wishlistName),
      ),
      body: Center(
        child: Text('Wishlist details for $wishlistName'),
      ),
    );
  }
}
