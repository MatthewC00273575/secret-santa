import 'package:flutter/material.dart';
import 'package:secretsanta/models/store_item.dart';

class Shop extends ChangeNotifier {
  // store items list
  final List<Item> _storeItems = [
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

// member wish list
  List<Item> _wishList = [];

//getter methods
  List<Item> get storeItems => _storeItems;
  List<Item> get wishList => _wishList;

// add to cart
  void addToCart(Item storeItem, int quantity) {
    for (int i = 0; i < quantity; i++) {
      _wishList.add(storeItem);
    }
    notifyListeners();
  }

// remove from cart
  void removeFromWishList(Item item) {
    _wishList.remove(item);
    notifyListeners();
  }
}
