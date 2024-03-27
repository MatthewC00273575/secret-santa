import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretsanta/components/create_bottom_sheet.dart';
import 'package:secretsanta/components/update_bottom_sheet.dart';

class CreateGroupDetails extends StatefulWidget {
  final String name;
  const CreateGroupDetails({Key? key, required this.name}) : super(key: key);

  @override
  State<CreateGroupDetails> createState() => _CreateGroupDetails();
}

class _CreateGroupDetails extends State<CreateGroupDetails> {
  // User
  final User currentUser = FirebaseAuth.instance.currentUser!;
  // Firestore collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 75.0),
          child: Text(
            'Secret Santa',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        iconTheme: const IconThemeData(color: Colors.white),
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
                        // You can add more fields as needed
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
