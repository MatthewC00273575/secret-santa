// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupInformationScreen extends StatelessWidget {
  final String groupName;
  final String creator;

  const GroupInformationScreen({
    Key? key,
    required this.groupName,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {
              // open a dialog to invite members to the group
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                        'Send an email to invite participants to $groupName?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          // Fetch emails of the stored members in the group
                          QuerySnapshot membersSnapshot =
                              await FirebaseFirestore.instance
                                  .collection("Groups")
                                  .doc(groupName)
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
                                'subject=Join my group&body=Click here to join my group',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Groups")
            .doc(groupName)
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
              return ListTile(
                title: Text(name),
                subtitle: Text(email),
                onTap: () {
                  // Perform action when item is clicked
                  // For example, navigate to another screen
                },
              );
            },
          );
        },
      ),
    );
  }
}
