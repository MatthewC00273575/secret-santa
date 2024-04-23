import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinGroupScreen extends StatefulWidget {
  final String groupName;

  const JoinGroupScreen({super.key, required this.groupName});

  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  String displayName = ''; // Variable to store the entered display name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your display name:',
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              onChanged: (value) {
                displayName = value;
              },
              decoration: const InputDecoration(
                hintText: 'Display Name',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Check if display name is not empty
                if (displayName.isNotEmpty) {
                  // Add the user to the group in Firestore
                  FirebaseFirestore.instance
                      .collection('Groups')
                      .doc(widget.groupName)
                      .collection('userGroups')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    'displayName': displayName,
                    'email': FirebaseAuth.instance.currentUser!.email,
                  }).then((value) {
                    print('User added to the group successfully.');
                    Navigator.of(context).pop(); // Close the screen
                  }).catchError((error) {
                    // Handle any errors
                    print('Error adding user to the group: $error');
                  });
                } else {
                  // Display an error message if display name is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a display name.'),
                    ),
                  );
                }
              },
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
