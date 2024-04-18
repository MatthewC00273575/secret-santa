import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretsanta/components/drawer.dart';
import 'package:secretsanta/pages/group_infopage.dart';
import 'package:secretsanta/pages/prof_page.dart';
import 'package:secretsanta/theme/colours.dart';

class SavedGroups extends StatefulWidget {
  const SavedGroups({Key? key});

  @override
  State<SavedGroups> createState() => _SavedGroupsState();
}

class _SavedGroupsState extends State<SavedGroups> {
  final User currentUser = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // navigate to profile page
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentsColour,
      appBar: AppBar(
        title: const Text(
          'Festive Exchange',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Side menu
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignout: signUserOut,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Text(
                "My groups",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Groups").snapshots(),
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
                    final bool isCurrentUserCreator =
                        creator == currentUser.email;

                    return Container(
                      margin: const EdgeInsets.only(
                          left: 25, right: 25, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        title: isCurrentUserCreator
                            ? Text(
                                groupName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        trailing: isCurrentUserCreator
                            ? IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Delete the group when delete button is clicked
                                  deleteGroup(groupName);
                                },
                              )
                            : null,
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteGroup(String groupName) async {
    try {
      // Delete the group document
      await FirebaseFirestore.instance
          .collection("Groups")
          .doc(groupName)
          .delete();
      // Also delete all documents in the 'userGroups' subcollection
      await FirebaseFirestore.instance
          .collection("Groups")
          .doc(groupName)
          .collection('userGroups')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group $groupName deleted successfully!'),
        ),
      );
    } catch (e) {
      // Show error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete group: $e'),
        ),
      );
    }
  }
}
