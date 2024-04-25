// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretsanta/pages/fetch_profile.dart';
import 'package:secretsanta/theme/colours.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupInformationScreen extends StatefulWidget {
  final String groupName;
  final String creator;

  const GroupInformationScreen({
    Key? key,
    required this.groupName,
    required this.creator,
  }) : super(key: key);

  @override
  State<GroupInformationScreen> createState() => _GroupInformationScreenState();
}

class _GroupInformationScreenState extends State<GroupInformationScreen> {
  final String userProfileDeepLink =
      'https://secretsanta.flutter.com/user-groups';

  @override
  Widget build(BuildContext context) {
    bool isCreator = FirebaseAuth.instance.currentUser!.email == widget.creator;

    return Scaffold(
      backgroundColor: primaryColour,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarColor,
        title: Text(
          widget.groupName,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () {
              // Open a dialog to invite members to the group
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                        'Send an email to invite participants to ${widget.groupName}?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          // Fetch emails of the stored members in the group
                          QuerySnapshot membersSnapshot =
                              await FirebaseFirestore.instance
                                  .collection("Groups")
                                  .doc(widget.groupName)
                                  .collection('userGroups')
                                  .get();

                          // Extract emails from the snapshot and join them with commas
                          List<String> emails = membersSnapshot.docs
                              .map((doc) => doc['email'] as String)
                              .toList();
                          String emailsString = emails.join(',');

                          // Construct the email URI with subject and body
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: emailsString,
                            query:
                                'subject=Join my group&body=Click the link below to join my group \n\n $userProfileDeepLink',
                          );

                          // Launch email app with the URI
                          if (await canLaunch(emailUri.toString())) {
                            launch(emailUri.toString());
                          } else {
                            throw 'Could not launch $emailUri';
                          }
                        },
                        child: const Text('Invite'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Note:\nClick your name to see who you're getting a gift for ", // Title added here
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Groups")
                  .doc(widget.groupName)
                  .collection('userGroups')
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
                    final String name = doc['name'];
                    final String email = doc['email'];
                    final bool isCurrentUser =
                        email == FirebaseAuth.instance.currentUser!.email;

                    return ListTile(
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(email),
                      onTap: () async {
                        // Check if the user exists in Firestore
                        DocumentSnapshot snapshot = await FirebaseFirestore
                            .instance
                            .collection('Users')
                            .doc(email)
                            .get();
                        if (snapshot.exists) {
                          // Navigate to the user's profile page if they exist
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FetchProfile(
                                email: email,
                                assignedGiftee: doc['assignedGiftee'] ??
                                    '', // Pass assigned giftee data
                              ),
                            ),
                          );
                        } else {
                          // Display a message if the user does not exist
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('User Has Not Registered'),
                                content: Text(
                                    'The user with email $email has not registered yet.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      trailing: isCurrentUser
                          ? IconButton(
                              icon: const Icon(Icons.exit_to_app),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Leave Group'),
                                      content: Text(
                                          'Are you sure you want to leave ${widget.groupName}?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            // Perform leaving group action
                                            // For simplicity, I'm just deleting the user's entry from the group
                                            await FirebaseFirestore.instance
                                                .collection("Groups")
                                                .doc(widget.groupName)
                                                .collection('userGroups')
                                                .doc(doc.id)
                                                .delete();

                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('Leave'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isCreator
          ? FloatingActionButton(
              onPressed: () async {
                // Fetch the list of participants
                QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
                    .collection("Groups")
                    .doc(widget.groupName)
                    .collection('userGroups')
                    .get();

                // Extract names and emails from the snapshot
                List<Map<String, dynamic>> participants = membersSnapshot.docs
                    .map((doc) => {
                          'docId': doc.id,
                          'name': doc['name'] as String,
                          'email': doc['email'] as String,
                        })
                    .toList();

                // Randomly shuffle the participants
                participants.shuffle();

                // Update the Firestore documents for each participant
                for (int i = 0; i < participants.length; i++) {
                  String assignedGiftee =
                      participants[(i + 1) % participants.length]['name'];

                  // Update the Firestore document with the assigned recipient
                  await FirebaseFirestore.instance
                      .collection("Groups")
                      .doc(widget.groupName)
                      .collection('userGroups')
                      .doc(participants[i]['docId'])
                      .update({'assignedGiftee': assignedGiftee});
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Secret Santa assignment completed.'),
                  ),
                );
              },
              tooltip: 'Assign Secret Santa', // Tooltip added here
              child: const Icon(Icons.shuffle), // Icon= shuffle button
            )
          : null,
    );
  }
}
