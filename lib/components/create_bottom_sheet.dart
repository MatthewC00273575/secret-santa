import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();

// Assuming you have a userCredential object already
void createUserDocument() async {
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Create a reference to the "Users" collection
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Users");

  // Create a document reference using the user's email
  DocumentReference userDocRef = usersCollection.doc(currentUser.email);

  // Create a subcollection within the user document
  CollectionReference subCollection = userDocRef.collection('group');

  // Create a document within the subcollection
  DocumentReference groupDocRef =
      subCollection.doc(nameController.text.toString());

  // Define fields for the widget document
  Map<String, dynamic> groupData = {
    "name": nameController.text.toString(),
    "email": emailController.text.toString(),
  };

  // Set the data for the widget document
  await groupDocRef.set(groupData);
}

void createBottomSheet(BuildContext context) {
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
                  "Add member",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "eg.Cristiano",
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
                    createUserDocument();
                    // For clearing the controllers
                    nameController.clear();
                    emailController.clear();
                    // dismiss keyboard after adding items
                    Navigator.pop(context);
                  },
                  child: const Text("add"))
            ],
          ),
        );
      });
}
