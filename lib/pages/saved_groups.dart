import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretsanta/pages/group_infopage.dart';

class SavedGroups extends StatefulWidget {
  const SavedGroups({Key? key}) : super(key: key);

  @override
  State<SavedGroups> createState() => _SavedGroupsState();
}

class _SavedGroupsState extends State<SavedGroups> {
  final User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Groups'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Groups").snapshots(),
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
              final String groupName = doc['name'];
              final String creator = doc['creator'];
              final bool isCurrentUserCreator = creator == currentUser.email;

              return ListTile(
                title: isCurrentUserCreator
                    ? Text(groupName)
                    : Container(), // Display group name only if current user is the creator
                onTap: () {
                  // Navigate to GroupInformationScreen only if the current user is the creator
                  if (isCurrentUserCreator) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupInformationScreen(
                          groupName: groupName,
                          creator: creator,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
