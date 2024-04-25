import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secretsanta/theme/colours.dart';

class FetchProfile extends StatelessWidget {
  final String email;
  final String assignedGiftee;

  const FetchProfile(
      {super.key, required this.email, required this.assignedGiftee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColour,
      appBar: AppBar(
        title: Text(
          email,
          style: const TextStyle(color: Colors.white),
        ), // Display the email as the title
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Users').doc(email).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // if account has not yet been registered display this.
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User has not yet registered'));
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Username: ${userData['username']}'),
                  Text('Age: ${userData['age']}'),
                  Text('Bio: ${userData['bio']}'),
                  if (FirebaseAuth.instance.currentUser!.email == email)
                    Text(
                        'You\'re getting a gift for: $assignedGiftee'), // Display assigned giftee
                  const SizedBox(height: 20), // Add some space
                  // Display wishlist details
                  const Text(
                    'Wishlist Details:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Wishlists')
                        .doc(email)
                        .collection('items')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final items = snapshot.data!.docs;
                      if (items.isEmpty) {
                        return const Center(
                            child: Text('No items in wishlist'));
                      }
                      return Column(
                        children: items.map((item) {
                          return ListTile(
                            title: Text(item['name']),
                            subtitle: Text(item['description']),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
