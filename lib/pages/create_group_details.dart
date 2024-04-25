// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretsanta/components/create_bottom_sheet.dart';
import 'package:secretsanta/components/update_bottom_sheet.dart';
import 'package:secretsanta/navigation.dart';
import 'package:secretsanta/theme/colours.dart';

class CreateGroupDetails extends StatefulWidget {
  const CreateGroupDetails({
    super.key,
  });

  @override
  State<CreateGroupDetails> createState() => _CreateGroupDetails();
}

class _CreateGroupDetails extends State<CreateGroupDetails> {
  // User
  final User currentUser = FirebaseAuth.instance.currentUser!;
  // Firestore collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Users");

  void saveGroup(BuildContext context) async {
    String groupName = ''; // Group name
    String assignedGiftee = '';
    String groupDisplayName = ''; // Group display name
    String maxGiftPrice = ''; // Maximum gift price
    String password = ''; // Password

    // Prompt user for group rules
    bool isSaved = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Group Rules'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  groupName = value;
                });
              },
              decoration: const InputDecoration(hintText: 'Group Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  groupDisplayName = value;
                });
              },
              decoration: const InputDecoration(hintText: 'Group Display Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  maxGiftPrice = value;
                });
              },
              decoration: const InputDecoration(hintText: 'Max Gift Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Cancel
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (groupName.isNotEmpty &&
                  groupDisplayName.isNotEmpty &&
                  maxGiftPrice.isNotEmpty &&
                  password.isNotEmpty) {
                Navigator.pop(context, true); // Save
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('Please provide all required group information.'),
                ));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    // Check if the user saved the group rules
    if (isSaved) {
      // Save group information with provided group name and display name
      await FirebaseFirestore.instance.collection("Groups").doc(groupName).set({
        'name': groupName,
        'creator': currentUser.email,
        'max_gift_price': maxGiftPrice,
        'password': password,
      });

      // Store current user's email and display name in the group
      await FirebaseFirestore.instance
          .collection("Groups")
          .doc(groupName)
          .collection('userGroups')
          .doc(currentUser.email)
          .set({
        'email': currentUser.email,
        'name': groupDisplayName,
        'assignedGiftee': assignedGiftee
      });

      // Navigate to SavedGroups screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: accentsColour,

      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 75.0),
          child: Text(
            'Create Group',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          FloatingActionButton(
            onPressed: () => saveGroup(context),
            mini: true, // Pass BuildContext
            child: const Text("Save"),
          ),
        ],
      ),

      // For Read/Display operation
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser.email)
                  .collection('group')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return Card(
                      // Other code remains the same...
                      child: ListTile(
                        title: Text(
                          doc['email'].toString(), // Display email
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            // For update operation
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  updateBottomSheet(
                                    context,
                                    doc['email'].toString(), // Email
                                  );
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text("edit"),
                              ),
                            ),

                            // For delete operation
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: () async {
                                  Navigator.pop(context);
                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(currentUser.email)
                                      .collection('group')
                                      .doc(doc.id)
                                      .delete();
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text("delete"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // For Create operation
      floatingActionButton: FloatingActionButton(
        onPressed: () => createBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
