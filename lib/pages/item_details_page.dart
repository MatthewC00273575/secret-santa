import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:secretsanta/components/my_button.dart';
import 'package:secretsanta/models/shop.dart';
import 'package:secretsanta/models/store_item.dart';
import 'package:secretsanta/theme/colours.dart';

class ItemDetailsPage extends StatefulWidget {
  final Item item;

  const ItemDetailsPage({super.key, required this.item});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
//quantity
  int quantityCount = 0;

// decrement quantity
  void decrementQuantity() {
    setState(() {
      if (quantityCount > 0) {
        quantityCount--;
      }
    });
  }

  //increment quantity
  void incrementQuantity() {
    setState(() {
      quantityCount++;
    });
  }

  // add to wishlist
  void addToWish() {
    // only add if there is something to the cart
    if (quantityCount > 0) {
      // get access to shop
      final shop = context.read<Shop>();

      //add to cart
      shop.addToCart(widget.item, quantityCount);

      // letting user know if it was successful
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: accentsColour,
          content: const Text(
            "Successfully added to cart",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            // okay button
            IconButton(
              onPressed: () {
                // pop once to remove the dialog box
                Navigator.pop(context);

                // pop again to go to previus screen
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.done,
                color: Colors.white,
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          // Listview of item details
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListView(
              children: [
                // image
                Image.asset(
                  widget.item.imagePath,
                  height: 200,
                ),

                const SizedBox(height: 10),

                // rating
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),

                    const SizedBox(width: 10),

                    //rating number
                    Text(widget.item.rating,
                        style: TextStyle(
                          color: darkGrey,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),

                const SizedBox(height: 10),

                // item name
                Text(
                  widget.item.name,
                  style: GoogleFonts.dmSerifDisplay(fontSize: 28),
                ),

                const SizedBox(height: 25),

                // description
                Text(
                  "Description",
                  style: TextStyle(
                      color: darkGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),

                const SizedBox(height: 10),

                Text(
                  "Indulge in timeless elegance with our exquisite brown leather handbag! Crafted with precision and passion, this accessory exudes sophistication and style. From its rich, supple leather exterior to its meticulously designed interior compartments, every detail is thoughtfully curated to enhance your everyday ensemble. Elevate your look effortlessly and make a statement wherever you go with our luxurious brown leather handbag. Shop now and add a touch of refined glamour to your wardrobe!",
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 14,
                    height: 2,
                  ),
                ),
              ],
            ),
          )),

          Container(
            color: accentsColour,
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                //price + quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // price
                    Text(
                      "\$" + widget.item.price,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    // quantity
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: accentsColour2, shape: BoxShape.circle),
                          child: IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onPressed: decrementQuantity,
                          ),
                        ),

                        // quantity count
                        SizedBox(
                          width: 40,
                          child: Center(
                            child: Text(
                              quantityCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        //plus button
                        Container(
                          decoration: BoxDecoration(
                              color: accentsColour2, shape: BoxShape.circle),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: incrementQuantity,
                          ),
                        )
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 25),

                // add to wishlist button
                MyButton(
                  onTap: addToWish,
                  text: "Add to wishlist",
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
