import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secretsanta/models/store_item.dart';
import 'package:secretsanta/theme/colours.dart';

class ItemsTile extends StatelessWidget {
  final Item item;
  final void Function()? onTap;
  const ItemsTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColour,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(left: 25),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // image
            Image.asset(
              item.imagePath,
              height: 110,
            ),

            // text
            Text(
              item.name,
              style: GoogleFonts.dmSerifDisplay(fontSize: 20),
            ),

            // price + rating
            SizedBox(
              width: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // price
                  Text(
                    '\$${item.price}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: darkGrey),
                  ),

                  // rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 240, 208, 31),
                      ),
                      Text(
                        item.rating,
                        style: TextStyle(color: darkGrey),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
