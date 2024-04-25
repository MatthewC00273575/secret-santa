// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretsanta/components/create_bottom_sheet.dart';
import 'package:secretsanta/components/update_bottom_sheet.dart';
import 'package:secretsanta/navigation.dart';
import 'package:secretsanta/theme/colours.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateGroupDetails extends StatefulWidget {
  const CreateGroupDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateGroupDetails> createState() => _CreateGroupDetails();
}

class _CreateGroupDetails extends State<CreateGroupDetails> {
  final String userProfileDeepLink =
      'https://secretsanta.flutter.com/user-groups';
  // User
  final User currentUser = FirebaseAuth.instance.currentUser!;
  // Firestore collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Users");

  void sendInvitationEmail(
    String groupName,
    String password,
    String maxGiftPrice,
  ) async {
    // Fetch emails of the stored members in the group
    QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.email)
        .collection('group')
        .get();

    // Extract emails from the snapshot and join them with commas
    List<String> emails =
        membersSnapshot.docs.map((doc) => doc['email'] as String).toList();
    String emailsString = emails.join(',');

    // Construct the email URI with subject and body
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailsString,
      query:
          'subject=Join my group&body=Hey!! I\'m inviting you to join my Secret Santa group'
          '\nClick the link below to join my group '
          '\n $userProfileDeepLink \n\n Search for my group in the app. \nGroup name: $groupName \nPassword: $password'
          '\n\n Rules: \nMax Gift Price: €$maxGiftPrice',
    );

    // Launch email app with the URI
    if (await canLaunch(emailUri.toString())) {
      launch(emailUri.toString());
    } else {
      throw 'Could not launch $emailUri';
    }
  }

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

      // Send invitation emails
      sendInvitationEmail(groupName, password, maxGiftPrice);

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
