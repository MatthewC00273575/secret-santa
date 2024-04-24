import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretsanta/components/create_bottom_sheet.dart';

void updateDocument(String email) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  try {
    await userCollection
        .doc(currentUser.email)
        .collection('group')
        .doc(email) // Use email as the document ID
        .update({
      'email': email, // Update the 'email' field with the new value
    });
    print('Document updated successfully');
  } catch (e) {
    print('Error updating document: $e');
  }
}

void updateBottomSheet(BuildContext context, String email) {
  // Set initial values for controllers
  emailController.text = email;

  // Show modal bottom sheet
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: const Color.fromARGB(255, 241, 233, 230),
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                "Update member",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "email",
                hintText: "eg.ron@gmail.com",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call updateDocument function with updated values
                updateDocument(emailController.text);
                // Clear the controllers
                emailController.clear();
                // Dismiss keyboard after updating
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        ),
      );
    },
  );
}
