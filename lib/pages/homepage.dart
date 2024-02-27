import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          alignment: Alignment.bottomCenter,
          height: 170,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 12, 121, 15)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome to",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Secret Santa",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 11, 95, 15)),
                  child: IconButton(
                    onPressed: signUserOut,
                    icon: const Icon(Icons.logout),
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ]),
        )
      ]),

      // logout
      /*appBar: AppBar(actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ]),*/
    );
  }
}
