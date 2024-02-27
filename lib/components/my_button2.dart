import 'package:flutter/material.dart';

class MyButton2 extends StatelessWidget {
  final Function()? onTap;

  const MyButton2({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 60),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(48),
        ),
        child: const Center(
            child: Text("Create group",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16))),
      ),
    );
  }
}
