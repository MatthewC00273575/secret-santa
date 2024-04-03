import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secretsanta/models/shop.dart';
import 'package:secretsanta/models/store_item.dart';
import 'package:secretsanta/theme/colours.dart';

class MyWishlist extends StatelessWidget {
  const MyWishlist({super.key});

  // remove from wishlist
  void removeFromWish(Item item, BuildContext context) {
    // get acces to shop
    final shop = context.read<Shop>();

    // remove from Cart
    shop.removeFromWishList(item);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Shop>(
        builder: (context, value, child) => Scaffold(
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
              body: ListView.builder(
                  itemCount: value.wishList.length,
                  itemBuilder: (context, index) {
                    // get items from wishlist
                    final Item item = value.wishList[index];

                    //get item name
                    final String itemName = item.name;

                    // get item price
                    final String itemPrice = item.price;

                    // return list tile
                    return Container(
                      decoration: BoxDecoration(
                          color: primaryColour,
                          borderRadius: BorderRadius.circular(8)),
                      margin:
                          const EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: ListTile(
                        title: Text(
                          itemName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(itemPrice),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeFromWish(item, context),
                        ),
                      ),
                    );
                  }),
            ));
  }
}
