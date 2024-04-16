// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretsanta/components/create_bottom_sheet.dart';
import 'package:secretsanta/components/update_bottom_sheet.dart';
import 'package:secretsanta/pages/saved_groups.dart';

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

  String groupName = '';

  void saveGroup(BuildContext context) async {
    // Prompt user for group name
    String? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Group Name'),
        content: TextField(
          onChanged: (value) {
            setState(() {
              groupName = value;
            });
          },
          decoration: const InputDecoration(hintText: 'Group Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, groupName);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    // Check if group name is provided
    if (result != null && result.isNotEmpty) {
      // Save group information with provided group name
      await FirebaseFirestore.instance.collection("Groups").doc(result).set({
        'name': result,
        'creator': currentUser.email,
        // Add more fields as needed
      });

      // Store user's group information in the new group
      QuerySnapshot userGroupsSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .collection('group')
          .get();

      userGroupsSnapshot.docs.forEach((doc) async {
        await FirebaseFirestore.instance
            .collection("Groups")
            .doc(result)
            .collection('userGroups')
            .doc(doc.id)
            .set({
          'name': doc['name'],
          'email': doc['email'],
          // Add more fields as needed
        });
      });

      // Navigate to SavedGroups screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SavedGroups()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 75.0),
          child: Text(
            'Add participants',
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
            child: const Icon(Icons.save),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          doc['name'], // Document ID as the title
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          doc['email']
                              .toString(), // Email field as the subtitle
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
                                    doc['name'].toString(), // name
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
