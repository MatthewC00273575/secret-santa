import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretsanta/components/drawer.dart';
import 'package:secretsanta/pages/group_infopage.dart';
import 'package:secretsanta/pages/join_group.dart';
import 'package:secretsanta/pages/prof_page.dart';
import 'package:secretsanta/theme/colours.dart';

class SavedGroups extends StatefulWidget {
  const SavedGroups({Key? key});

  @override
  State<SavedGroups> createState() => _SavedGroupsState();
}

class _SavedGroupsState extends State<SavedGroups> {
  final User currentUser = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Search Groups'),
              content: SizedBox(
                width: double.maxFinite, // Ensure content takes full width
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter group name',
                        ),
                        onChanged: (value) {
                          // Update the filtered groups and trigger a rebuild
                          setState(() {
                            _filteredGroups = _filterGroups(value);
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Display filtered groups here
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredGroups.length,
                        itemBuilder: (context, index) {
                          final doc = _filteredGroups[index];
                          final String groupName = doc['name'];

                          return ListTile(
                            title: Text(groupName),
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Implement join group functionality here
                                joinGroup(context,
                                    groupName); // Pass context and groupName
                              },
                              child: Text('Join'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Reload the dialog box to show the search items
                    Navigator.of(context).pop();
                    _showSearchDialog();
                  },
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Inside your class...

  List<DocumentSnapshot> _filteredGroups = []; // List to hold filtered groups

  List<DocumentSnapshot> _filterGroups(String query) {
    // Clear the previous filtered groups
    _filteredGroups.clear();

    // Query Firestore to retrieve groups with names containing the query string
    FirebaseFirestore.instance
        .collection('Groups')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name',
            isLessThanOrEqualTo:
                query + '\uf8ff') // '\uf8ff' is a high surrogate
        .get()
        .then((QuerySnapshot querySnapshot) {
      // Add the filtered groups to the list
      _filteredGroups.addAll(querySnapshot.docs);
    }).catchError((error) {
      // Handle any errors
      print('Error filtering groups: $error');
    });

    // Return the filtered groups
    return _filteredGroups;
  }

  void joinGroup(BuildContext context, String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinGroupScreen(groupName: groupName),
      ),
    );
  }

// Screen
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
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

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Groups")
                          .doc(groupName)
                          .collection('userGroups')
                          .where('email', isEqualTo: currentUser.email)
                          .snapshots(),
                      builder: (context, userGroupSnapshot) {
                        if (userGroupSnapshot.connectionState ==
                                ConnectionState.waiting ||
                            userGroupSnapshot.data == null ||
                            userGroupSnapshot.data!.docs.isEmpty) {
                          // If the user's email is not found in userGroups, return an empty container
                          return Container();
                        } else {
                          // If the user's email is found in userGroups, display the group
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 25, right: 25, top: 15, bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              title: Text(
                                groupName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteGroup(groupName);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GroupInformationScreen(
                                      groupName: groupName,
                                      creator: doc['creator'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
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
      await FirebaseFirestore.instance
          .collection("Groups")
          .doc(groupName)
          .delete();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group $groupName deleted successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete group: $e'),
        ),
      );
    }
  }
}
