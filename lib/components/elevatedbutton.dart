import 'package:flutter/material.dart';

class MyButton2 extends StatelessWidget {
  final Function()? onTap;
  final IconData iconData; // Add this line to include icon data
  const MyButton2(
      {Key? key,
      required this.onTap,
      required this.text,
      required this.iconData})
      : super(key: key); // Update constructor

  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 84, 145, 152),
        padding: const EdgeInsets.all(20),
      ),
      child: Row(
        // Use Row to align icon and text horizontally
        children: [
          Icon(iconData), // Icon widget
          const SizedBox(width: 10), // Add space between icon and text
          Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 229, 213, 231),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
