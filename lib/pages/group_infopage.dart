import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
