import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchProfile extends StatelessWidget {
  final String email;

  const FetchProfile({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(email), // Display the email as the title
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Username: ${userData['username']}'),
                Text('Age: ${userData['age']}'),
                Text('Bio: ${userData['bio']}'),
                // Add more user details as needed
              ],
            ),
          );
        },
      ),
    );
  }
}
